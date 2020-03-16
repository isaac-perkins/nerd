<?php declare(strict_types=1);
/*
 * This file is part of Nerd (Named Entity Recognition Dashboard).
 *
 * (c) Boulevard Software (hello@blvd.ai)
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

namespace Nerd\Model;

use Illuminate\Database\Eloquent\Model;

final class Training extends Model
{
    public $timestamps = false;

    protected $table = 'training';

    protected $fillable = [
        'job_id',
        'url',
        'file',
        'updated_at',
    ];

    public static function list(int $jobID)
    {
        return self::where('job_id', '=', $jobID)->orderBy('id', 'desc')->get();
    }

    public static function item(int $trainingID) : array
    {
        $rv = self::find($trainingID)->toArray();

        $rv['content'] = self::getContents($rv['file']);

        return \array_merge(Message::format(200, 'training_retrieved'), $rv);
    }

    public static function show(int $jobID, int $trainingID = 0) : array
    {
        $training = null;

        $rv = [];

        try {

            $rv = self::getJob($jobID);

        } catch (\Exception $e) {

            return Message::format(500, Message::Translate('can_not_find_job'), ['exception'   => $e->getMessage()]);
        }

        $rv['job_id'] = $jobID;

        $rv['Annotation'] = Annotation::list();

        $trainings = self::list($jobID);

        if ($trainingID > 0) {

            $training = self::find($trainingID);

        } else {

            if ($trainings->first()) {

                $training = $trainings->first();
            }
        }

        if ($training) {

            $rv['content'] = self::getContents($training->file);

        } else {

            $rv['content'] = $training->file;
        }

        $rv['links'] = $trainings;

        return $rv;
    }

    //Remove all training files for a job id
    public static function clear(string $jobID) : array
    {
        try {

            self::where('job_id', '=', $id)->delete();

            $rv = Message::format(200, 'training_cleared');

        } catch (\Exception $e) {

            $rv = Message::format(500, 'training_not_found', ['exception' => $e->getMessage()]);
        }

        return $rv;
    }

    //Get training file content
    public static function getFile(string $id) : array
    {
        $f = self::find($id)->file;

        if (\file_exists($f)) {
            $rv = Message::format(200, 'training_retrieved', [
                'content'     => \file_get_contents($f, false, null, 0, 64000),
                'file'        => $f,
            ]);
        } else {
            Message::format(500, 'error_getting_url', ['file' => $f]);
        }

        return $rv;
    }

    //Add training to db
    public static function add(int $jobID, string $url, string $file)
    {
        try {

            $training         = new self;
            $training->job_id = $jobID;
            $training->url    = $url;
            $training->file   = $file;
            $training->save();

        } catch (\Exception $e) {

            throw new \Exception(Message::Translate('training_not_found') . ' : ' . $file . '. ' . $e->getMessage());
        }

        return $training;
    }

    //Remove training file + db
    public static function remove(int $trainingID) : array
    {
        $train = self::find($trainingID);

        try {

            if (\file_exists($train->file)) {
                \unlink($train->file);
            }

            self::destroy($train->id);

            $rv = Message::format(200, 'training_removed');

        } catch (\Exception $e) {

            $rv =  Message::format(500, 'training_remove_error', ['exception' => $e->getMessage()]);
        }

        return \array_merge($rv, [
            'id' => $train->id,
            'url'  => $train->url,
            'file' => $train->file,
        ]);
    }

    public static function fetch(int $jobID, string $url) : array
    {
        $f = Content::getFilename($url);

        $rv = [];

        $trainingFile = self::getDirectory($jobID) . '/' . $f;

        $train = self::add($jobID, $url, $trainingFile);

        if (\file_exists($trainingFile)) {
            \unlink($trainingFile);
        }

        $fr = Content::fetch($url, $trainingFile);

        $cs = Content::sentences($trainingFile);

        if ($fr['status'] == 200) {
            $train->save();

            $rv = Message::format(200, 'got_training_contents', [
                'id'  => $train->id,
                'url' => $train->url,
                'file'  => $trainingFile,
                'output' => $cs,
                'content'        => \file_get_contents($trainingFile),
            ]);
        } else {
            $rv = Message::format(500, 'get_training_contents_error', [
                'content'     => 'Error saving file: ' . $trainingFile,
            ]);
        }

        return $rv;
    }

    public static function saveFile(int $trainingID, string $content) : array
    {
        $training = self::find($trainingID);

        $training->updated_at = \date('Y-m-d H:i:s');

        $f = $training->file;

        $training->labels = Content::getLabelCount($f);

        $training->save();

        $xml = self::getXMLstring($content);

        \set_error_handler(['self', 'handleXmlError']);

        $dom = new \DOMDocument();

        try {
            $xml = \str_replace('&', ' ', $xml);

            $dom->loadXml($xml);

        } catch (\Exception $e) {

            \restore_error_handler();

            \file_put_contents($f, $content);

            return $this->json($response, [
                'code'        => 500,
                'status'      => 'danger',
                'msg'         => 'Syntax error: ' . \str_replace(['and document in Entity, ', 'entity', 'xmlParseEntityRef: no name in Entity', 'DOMDocument::loadXML() :'], '', $e->getMessage()),
            ]);
        }

        \restore_error_handler();

        return [
            'code' => 200,
            'status'      => (\file_put_contents($f, $content) !== false) ? 'success':'danger',
            'msg'         => Message::translate('json.saved_training')
        ];
    }

    public static function getJob(int $id) : array
    {
        try {

            $job = Job::find($id);
            $rv = $job->toArray();
            //$rv['job_command'] =  Command::getRunning($id);

        } catch (\Exception $e) {

            throw new \Exception(Message::translate('nerd.can_not_find_job') . ' : ' . $id);
        }

        return $rv;
    }

    public static function getContents(string $file) :string
    {
        if (\file_exists($file)) {

            return \file_get_contents($file, false, null, 0, 64000);
        }

        return 'File Not Found: ' . $file;
    }

    public static function getDirectory(int $jobID) :string
    {
        return \realpath(__DIR__ . "/../../data/$jobID/training/");
    }
/*
    public static function train($jobID)
    {
        $jobDir = __DIR__ . '/../../' . $jobID;

        $cmd = \realpath(__DIR__ . '/../../console/bin/model') . ' -j ' . $jobID;

        \exec($cmd, $out, $rv);

        $out = \implode("\n", $out);

        return Message::format(
            (($rv == 0) ? 200 : 500),
            (($rv == 0) ? 'training_built' : 'training_build_error'),
            [
                'rv'          => $rv,
                'cmd'         => $cmd,
                'out'         => $out,
            ]
        );
    }
*/
    public static function upload(array $files, int $jobID, int $trainingID = null) : array
    {
        $rv = [];

        if (empty($files['newfile'])) {
            return Message::format(500, 'training_no_file');
        }

        $nf=$files['newfile'];

        if ($nf->getError() === \UPLOAD_ERR_OK) {
            $fn = Content::getFilename($nf->getClientFilename());

            if ($trainingID > 0) {
                $training = self::find($trainingID);
            } else {
                try {
                    $training = self::add(
                      $jobID,
                      'file://' . $fn,
                      \realpath(__DIR__ . '/../../data/' . $jobID . '/training') . '/' . $fn
                  );
                } catch (\Exception $e) {
                    $rv = Message::format(500, 'training_add_error', ['exception' => $nf->getError()]);
                }
            }

            if ($training) {

              //echo $training->file;exit;
                $nf->moveTo($training->file);

                $rv = Message::format(200, 'file_uploaded', ['content' => \file_get_contents($training->file)]);

            } else {

                $rv = Message::format(500, 'Nope');
            }
        } else {
            $rv = Message::format(500, 'training_upload_error', ['exception' => $nf->getError()]);
        }

        return $rv;
    }

    public static function targets(string $jobID)
    {
        return Annotations::totals(self::list($jobID));
    }
/*
    public static function tag(int $jobID, Int $trainingID)
    {
        $training = self::find($trainingID)->file;

        $tags = Annotations::unique(self::list($jobID));

        $train = \file_get_contents($training);

        foreach ($tags as $key => $values) {

            foreach ($values as $value) {

                if (\strpos($train, $value) !== false) {
                    $train = \str_replace($value, " <START:$key> $value <END> ", $train);
                }
            }
        }

        \file_put_contents($training, $train);
    }
*/
    public static function getXML(string $xml)
    {
        $xml = \str_replace('<START:', '<entity type="', $xml);
        $xml = \str_replace('>', '">', $xml);
        $xml = \str_replace('<END">', '</entity>', $xml);
        $xml = '<document>' . $xml . '</document>';
        $xml = tidy_repair_string($xml, [
            'input-xml'    => true,
            'output-xml'   => true,
        ]);
        $dom = new \DomDocument;
        $dom->loadXML($xml);

        return $dom;
    }

    //TODO two functions?
    public static function getXMLstring(string $content)
    {
        $xml = \str_replace('<START:', '<entity type="', $content);
        $xml = \str_replace('>', '">', $xml);
        $xml = \str_replace('<END">', '</entity>', $xml);

        return '<document>' . $xml . '</document>';
    }

    public function handleXmlError($errno, $errstr, $errfile, $errline)
    {
        if ($errno == \E_WARNING && (\substr_count($errstr, 'DOMDocument::loadXML()') > 0)) {
            $this->errorLine = $errline;

            throw new \DOMException($errstr);
        }

        return false;
    }
}

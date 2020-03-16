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

use Illuminate\Database\Capsule\Manager as DB;
use Illuminate\Database\Eloquent\Model;

//use GO\Scheduler;

class Job extends Model
{
    protected $table = 'jobs';

    protected $fillable = [
        'owner_id',
        'type_id',
        'title',
        'description',
        'status',
        'started',
        'ended'
    ];

    protected $hidden = [
        'updated_at',
        'created_at',
    ];

    //List jobs from db view view_jobs_list
    public static function list(int $userID)
    {
        $sql = DB::raw("SELECT * FROM view_jobs_list");

        return DB::select($sql);
    }

    //Find a job by ID
    public static function item(int $id)
    {
        return self::find($id);
    }

    //Add  a new job
    public static function add(int $ownerID, string $title, string $desc) : array
    {
        try {
            $job              = new self;
            $job->owner_id    = $ownerID;
            $job->title       = $title;
            $job->description = $desc;
            $job->type_id     = 1; //as yet unused

            $job->save();

            $dir = __DIR__ . '/../../data/' . $job->id;

            \mkdir($dir, 0775);
            \mkdir($dir . '/content', 0775);
            \mkdir($dir . '/training', 0775);
            \mkdir($dir . '/result', 0775);

            \copy(__DIR__ . '/../../bootstrap/parameters.yml', $dir . '/parameters.yaml');

            \copy(__DIR__ . '/../Resources/assets/job.json', $dir . '/job.json');

            $rv = Message::format(200, 'job_saved', ['job_id'   => $job->id]);

        } catch (\Exception $e) {

            $rv = Message::format(500, 'can_not_add_new_job', ['exception'   => $e->getMessage()]);
        }

        return \array_merge($rv, ['job' => $job->toArray()]);
    }

    //Edit a job
    public static function edit(int $id, array $post) : array
    {
        $job = self::find($id);

        if (!$job) {
            return Message::format(500, 'can_not_find_job', ['id' => $id]);
        }

        try {

            $job->title       = $post['title'];
            $job->description = $post['description'];
            $job->save();

        } catch (\Exception $e) {

            return Message::format(500, 'can_not_edit_db_record_for_job', [
                'id'          => $id,
                'exception'   => $e->getMessage(),
            ]);
        }

        if (self::saveMeta($id, $post) > 0) {

            $rv = Message::format(200, 'job_saved');

        } else {

            $rv = Message::format(500, 'can_not_edit_meta_for_job', ['id' => $id]);
        }

        return $rv;
    }

    //Clear job model, content and results
    public static function clear(int $id) : array
    {
        try {
            $dir = __DIR__ . '/../../data/' . $id . '/';

            \array_map('unlink', \glob($dir . 'content/*'));

            \unlink($dir . 'model.bin');

            Result::clear($id);

            $rv = Message::format(200, 'job_cleared');

        } catch (\Exception $e) {

            $rv = Message::format(500, 'Can not clear job', [
                'id'        => $id,
                'exception' => $e->getMessage(),
            ]);
        }

        return $rv;
    }

    //Remove job (from db + file system)
    public static function remove(int $id) : array
    {
        try {

            self::destroy($id);

            $dir = __DIR__ . '/../../data/' . $id;

            \shell_exec('rm -r ' . $dir);

            $rv = Message::format(200, 'job_removed');

        } catch (\Exception $e) {

            $rv = Message::format(500, 'can_not_remove_job', [
                'id'          => $id,
                'exception'   => $e->getMessage(),
            ]);
        }

        return $rv;
    }

    //Run a job command $action[crawl,model,tag,result,locate]
    public static function build(int $userID, int $id, string $action) : array
    {
        Result::clear((string) $id);

        $job = self::item($id);
        $job->status = Command::index($action);
        $job->save();

        return Command::process($userID, $id, $action);
    }

    //Get job extra data (crawl/documents)
    public static function getMeta(int $id) : string
    {
        $json = __DIR__ . '/../../data/' . $id . '/job.json';

        if (!\file_exists($json)) {
            $rv = '';
        } else {
            $rv = \file_get_contents($json);
        }

        return $rv;
    }

    //Save job extra data (crawl/documents)
    public static function saveMeta(int $id, array $jobMeta) : bool
    {
        $json = __DIR__ . '/../../data/' . $id . '/job.json';

        if (\file_exists($json)) {
            \unlink($json);
        }

        return (\file_put_contents($json, \json_encode($jobMeta)) > 0) ? true : false;
    }

    //Get job locate status (just a text field in job table)
    public static function getLocate(int $id) : string
    {
        $job = self::find($id);

        return $job->locate;
    }

    //locate job with code
    public static function locate(int $id, string $code) : array
    {
        $rv = [];

        $job = self::find($id);

        $job->locate = $code;

        $cmd = \realpath(__DIR__ . '/../../console/bin');

        $cmd .= '/locate -j ' . $id . ' -c "' . $code . '"';

        \exec($cmd . ' > /dev/null 2>&1 &', $out, $rv);

        $rv = Message::format(200, 'check_back', [
            'cmd'         => $cmd,
            'code'        => $code,
            'jobID'       => $id,
        ]);

        $job->save();

        return $rv;
    }

    //Show log pages as array ['log' => 'crawl']
    public static function log(string $id, string $type) : array
    {
        $rv = __DIR__ . '/../../data/' . $id . '/' . $type . '.log';

        if (!\file_exists($rv)) {
            $rv = 'File Not Found';
        } else {
            $rv = \file_get_contents($rv);
        }

        return [
            'log' => $rv,
        ];
    }

    public function getName(string $title) : string
    {
        return \strtolower(\str_replace(' ', '-', $title));
    }

    /*
      public static function setSchedule(int $jobID, Array $schedule)
      {
        try {

          $job = self::find($jobID);

          $job->cron = $schedule['cron'];

          $schedule = new Schedule;

          $schedule->add([
            'job_id' => $jobID,
            'cmd' => realpath(__DIR__ . '/../../console/bin') . '/job -j ' . $jobID,
            'cron' => $job->cron
          ]);

          $job->save();

          $rv = [
            'status' => self::$trans->trans('json.+1'),
            'msg' => 'Job scheduled'
          ];

        } catch (\Exception $e) {

          $rv = [
            'status' => self::$trans->trans('json.-1'),
            'msg' => $e->getMessage()
          ];
        }

        return $rv;
      }
    */
}

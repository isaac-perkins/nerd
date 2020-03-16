<?php
/*
 * This file is part of Nerd.
 *
 * (c) Boulevard Software (hello@blvd.ai)
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */
namespace Console\Model;

use Illuminate\Database\Capsule\Manager as DB;
use Illuminate\Database\Schema\Blueprint;
use Monolog\Logger as Logger;
use XslDom\XslDomDocument;
use Nerd\Model\DocumentsMeta;
use Nerd\Model\Annotations;

class Results extends Crawl
{
    private $name;

    public function __construct(Job $job, Logger $log)
    {
        parent::__construct($job, $log);

        self::clear($job->getID());

        $this->create();
    }

    //create result table
    public function create()
    {
        $jobDir = $this->job->getDir();

        $types = self::types($jobDir)->getElementsByTagName('type');

        $jobID = \basename($jobDir);

        $this->name = 'tmp_' . $jobID;

        DB::schema()->create($this->name, function (Blueprint $table) use ($types) {

            $table->increments('item_id');

            $table->unsignedInteger('document_id');

            foreach ($types as $type) {
                if (!\preg_match('/document/', $type->nodeValue)) {
                    $table->text($type->nodeValue)->nullable();
                }
            }
        });

        return true;
    }

    //process result output into columns
    public function process() : int
    {
        $d  = new \DomDocument;
        $e  = new \DomDocument;
        $xs = new XslDomDocument;
        $i  = 0;

        $jobDir = $this->job->getDir();

        $types = self::types($jobDir);

        $sTypes = $types->saveXML($types->documentElement);

        $files = \glob($jobDir . '/result/*.xml');

        //TODO: fix this mess
        foreach ($files as $file) {

            $i++;

            $d->load($file);

            if ($this->job->isMulti()) {

                $d->loadXML('<result>' . $sTypes . $d->saveXML($d->documentElement) . '</result>');

                $xs->load(__DIR__ . '/../../http/Resources/assets/itemize.xsl');

                $e->loadXML('<document>' . $sTypes . $xs->transform($d) . '</document>');

                $xs->load(__DIR__ . '/../../http/Resources/assets/result-multi.xsl');

            } else {

                $e->loadXML('<result>' . $sTypes . $d->saveXML($d->documentElement) . '</result>');

                $xs->load(__DIR__ . '/../../http/Resources/assets/result-single.xsl');
            }

            $d->loadXML($xs->transform($e));

            $docID = $this->insertDocument($d, $types, $file);

            $this->insertRows($docID, $d);

            $this->log->info("Processed : $file");
        }

        $this->log->info('Results Complete!');

        return \file_exists($jobDir . '/result/1.html');
    }

    //Remove results & documents + meta
    public static function clear($jobID)
    {
        if (DB::schema()->hasTable("tmp_$jobID")) {

            DB::table('documents')
              ->where('job_id', '=', $jobID)->delete();
        }

        DB::schema()->dropIfExists("tmp_$jobID");
    }

    //aka annotations as xml
    public static function types(string $dir) : \DomDocument
    {
        $x = $dir . '/types.xml';

        $d = new \DomDocument;

        $sql =  '
        SELECT XMLELEMENT (NAME "types",
                XMLAGG(
                  XMLELEMENT(NAME "type",
        		XMLATTRIBUTES(a.multi, a.type),
        		a.name
        	  )
        	)
          ) as xml
        FROM annotations a;';

        $annotations = DB::select(DB::raw($sql));

        $d->loadXML($annotations[0]->xml);

        $d->save($x);

        return $d;
    }

    //insert document & document meta data
    public function insertDocument(\DomDocument $result, \DomDocument $types, String $file) : int
    {
        $docRow = [
            'job_id' => $this->job->getID(),
            'url'    => $this->getFileUrl($file),
        ];

        DB::table('documents')->insert($docRow);

        $docID = DB::getPdo()->lastInsertId();

        $xpTypes = new \DOMXpath($types);

        $types = $xpTypes->query('//type[contains(., "document")]');

        foreach ($types as $type) {

            $metaItems = $result->getElementsByTagName($type->nodeValue);

            if ($metaItems) {

                if (isset($metaItems[0])) {

                    $dm = new DocumentsMeta;

                    $dm->document_id = $docID;

                    $dm->name = $type->nodeValue;

                    switch($type->getAttribute('type')) {

                        case 1:
                          $dm->value = $metaItems[0]->nodeValue;
                          break;

                        case 2:
                          $dm->value_number = (int) $metaItems[0]->nodeValue;
                          break;

                        case 3:
                          $dm->value_date = date("Y-m-d h:i:s", strtotime($metaItems[0]->nodeValue));
                          break;
                    }

                    $dm->save();

                }
            }
        }

        return $docID;
    }

    //insert result rows to db
    public function insertRows(Int $docID, \DomDocument $result)
    {
        $items = $result->getElementsByTagName('item');

        $rv = [];

        foreach ($items as $item) {

            $r                = [];
            $r['document_id'] = $docID;

            foreach ($item->childNodes as $fld) {

                $r[$fld->nodeName] = $fld->nodeValue;
            }

            \array_push($rv, $r);
        }

        DB::table($this->name)->insert($rv);
    }

    //get url associated with a file from crawl list (jobdir/content/list.xml)
    public function getFileUrl(String $file)
    {
        $d = new \DomDocument;

        $d->load($this->job->getDir() . '/content/list.xml');

        $xp = new \DOMXpath($d);

        $lnk = $xp->query('//link[file="' . \basename(\substr($file, 0, -4)) . '"]')[0];

        if ($lnk) {

            $url = $lnk->getElementsByTagName('url')[0];

            if ($url) {

                return trim($url->nodeValue);

            }
        }
    }
}

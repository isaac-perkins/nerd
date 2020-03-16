<?php
/*
 * This file is part of Nerd (Named Entity Recognition Dashboard).
 *
 * (c) Boulevard Software (hello@blvd.ai)
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */
namespace Nerd\Model\Export;

use Illuminate\Database\Capsule\Manager as DB;
use Interop\Container\ContainerInterface;

class Export
{
    public $container;

    public $jobID;

    public $status = 500;

    public $body = 'Internal Server Error';

    public function __construct(ContainerInterface $container)
    {
        $this->container = $container;
    }

    public function zip(int $jobID)
    {
        $zip = new \ZipArchive();

        $x = __DIR__ . "/../../../cache/export_$jobID.xml";

        $this->xml()->save($x);

        $z = $x . '.zip';

        if (\file_exists($z)) {
            \unlink($z);
        }

        $zip->open($z, \ZIPARCHIVE::CREATE);

        $zip->addFile($x, "/markers-$jobID.xml");

        $zip->close();

        //remove temp xml
        \unlink($x);

        return \realpath($z);
    }

    public function getStatus()
    {
        return $this->status;
    }

    public function getBody()
    {
        return $this->body;
    }

    public function getJobFields(int $jobID)
    {
        $sql = "SELECT *
            FROM information_schema.columns
            WHERE table_name   = 'tmp_" . $jobID . "';";

        return (array) DB::select($sql);

        //return \array_column($fields, 'column_name');
    }

    public function getDocumentFields(int $jobID)
    {
        $sql = "
        SELECT       DISTINCT dm.name, a.type
        FROM        documents_meta dm
        INNER JOIN  tmp_$jobID r ON r.document_id = dm.document_id
        LEFT JOIN   annotations a ON dm.name = a.name";

        return \array_column((array) DB::select($sql), 'name');
    }
}

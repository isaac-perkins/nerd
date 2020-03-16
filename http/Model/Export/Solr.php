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
use Psr\Http\Message\ResponseInterface;

class Solr extends Export
{
    public const IsZip = false;

    private $client;

    private $solr;

    public function __construct(ContainerInterface $container)
    {
        parent::__construct($container);

        $this->solr = $this->container->get('settings')['solr'];

        if (isset($this->solr['usr'])) {

            $this->client = new \GuzzleHttp\Client([
                'auth' => [
                    $this->solr['usr'],
                    $this->solr['pwd'],
                ],
            ]);

        } else {

            $this->client = new \GuzzleHttp\Client();
        }
    }

    /*public function import()
    {
      $url = $this->solr['url'] . $this->solr['core'] . "/update?commit=true";

      return $this->client->request('POST', $url, [
        'headers' => [
          'Content-Type' => 'application/json',
          'Accept' => 'application/json'
        ],
        'body' => $body
      ]);
    }
*/
    public function export(string $jobID, bool $remove = false) : array
    {
        if ($remove == true || $this->solr['config']['export'] !== 'update') {

            try {

                $rv = $this->remove($jobID);

            } catch (\Exception $e) {

                return [
                    'status' => 'danger',
                    'msg'    => $e->getMessage(),
                ];
            }
        }

        $rv = $this->request($this->xml($jobID), 'text/xml');

        return [
            'status' => $rv->getStatusCode(),
            'msg'    => $rv->getBody(),
        ];
    }

    public function request(string $body, string $contentType = 'application/json', string $accept = 'text/xml') //: ResponseInterface
    {
        $url = $this->solr['url'] . $this->solr['core'] . '/update?commit=true';

        return $this->client->request('POST', $url, [
            'headers' => [
                'Content-Type' => $contentType,
                'Accept'       => $accept,
            ],
            'body' => $body,
        ]);
    }

    public function remove(string $jobID)
    {
        $rv = DB::select("SELECT item_id as id FROM tmp_$jobID");

        $rv = \array_map(function ($value) {
            return (array) ['id' => $value->id];
        }, $rv);

        return $this->request(\json_encode(['delete' => $rv]));
    }

    //Select job's result table as XML
    public function xml(string $jobID)
    {
        $jobFields = $this->getJobFields($jobID);

        $documentFields = (array) $this->getDocumentFields($jobID);

        $dv = 'dm.value';
        $dm = "concat(to_char(value_date, 'YYYY-MM-DD'),'T',to_char(value_date, 'HH:MI:SS'), 'Z')";

        $sql = '
        SELECT XMLELEMENT (NAME "add",
         XMLAGG(
          XMLELEMENT(NAME "doc",';

        foreach ($jobFields as $col) {

            switch ($col->column_name) {

                case 'item_id' :
                  $sql .= 'XMLELEMENT (NAME "field", XMLATTRIBUTES(' . "'id'" . ' as name), r.item_id),';
                  break;

                case 'id' :
                  $sql .= 'XMLELEMENT (NAME "field", XMLATTRIBUTES(' . "'source_id'" . ' as name), rtrim(r.id)),';
                  break;

                default:
                  if ($col->data_type == 'text') {
                    $column = 'trim(r.' . $col->column_name . ')';
                  } else {
                    $column = 'r.' . $col->column_name;
                  }
                  $sql .= 'XMLELEMENT (NAME "field", XMLATTRIBUTES(' . "'" . $col->column_name . "'" . ' as name), ' . $column . '),';
              }
        }

        $sql .= 'XMLELEMENT (NAME "field", XMLATTRIBUTES(' . "'" . 'latlong' . "'" . " as name), CONCAT(r.lat, ',', r.lng)),";
        //TODO: fix document_date hack and work with $df->type
        foreach($documentFields as $df) {
              $sql .= '
                XMLELEMENT (NAME "field", XMLATTRIBUTES(' . "'" . str_replace('_', '-', $df) . "'" . ' as name),
                  ( SELECT ' . (($df == 'document_date') ? $dm : "rtrim($dv)") . ' as value FROM documents_meta dm WHERE r.document_id = dm.document_id AND dm.name = ' . "'" . $df . "'" . ')),';
        }

        $sql = \rtrim($sql, ',');
        $sql .= '
                )
              )
            ) as xml
        FROM tmp_' . $jobID . ' r';

        $rv = DB::select($sql);

        if ($rv[0]) {
            //print $rv[0]->xml;
            //exit;

            return $rv[0]->xml;
        }

        throw new \Exception('no data');
    }
}

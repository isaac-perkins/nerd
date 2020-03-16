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

//use Symfony\Component\Yaml\Yaml;
use Illuminate\Database\Capsule\Manager as DB;

/*
SELECT *
FROM   tmp_66 r
INNER JOIN documents d ON r.document_id = d.id
*/

class Markers extends Export
{
    public function __construct(int $jobID)
    {
        $this->jobID = $jobID;
    }

    public function isZip()
    {
        return true;
    }

    public function xml()
    {
        $jobID = $this->jobID;

        $jfs = $this->getJobFields($jobID);

        $dfs = $this->getDocumentFields($jobID);

        $d = new \DomDocument;

        $sql = '
        SELECT XMLELEMENT (NAME "markers",
            XMLAGG(
              XMLELEMENT(NAME "marker",';

        foreach ($dfs as $df) {
            $sql .= '
                  XMLELEMENT (NAME "' . $df . '",
                    (SELECT string_agg(dm.value, ' . "' ')" . ' FROM documents_meta dm WHERE r.document_id = dm.document_id AND dm.name = ' . "'" . $df . "'" . ' GROUP BY dm.name)
                  ),';
        }

        foreach ($jfs as $col) {
            $sql .= 'XMLELEMENT (NAME "' . $col . '", r.' . $col . '),';
        }
        $sql = \rtrim($sql, ',');
        $sql .= '
              )
           )
      ) AS XML
      FROM 	tmp_' . $jobID . ' as r
      WHERE	length(cast (r.address as text)) > 0
      AND	r.lat != 0
      AND	r.lng != 0';

        $items = DB::select($sql)[0];

        $d->loadXML((string) \str_replace(',', '', $items->xml));

        return $d;
    }
}

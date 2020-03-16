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

class Code
{
    private $code;

    private $jobID;

    public function __construct($code)
    {
        $code       = \str_replace(['{{', '}}'], '', $code) . ',';

        $this->code = \explode(' ', $code);
    }

    public function select($jobID)
    {
        $this->jobID = $jobID;

        $sql = 'SELECT i.item_id,' . $this->pass('fields');

        $sql = \rtrim($sql, ',');

        $sql .= " FROM tmp_$jobID i";

        return $sql;
    }

    public function update(array $values, string $item) : string
    {
        if (\count($values) > 0) {

            $sql = "UPDATE tmp_$this->jobID SET ";

            foreach ($values as $k => $v) {

                $sql .= $k . ' =  ' . $v . ',';

            }

            $sql = \rtrim($sql, ',');

            $sql .= ' WHERE item_id = ' . $item;
      
            return $sql;
        }
    }

    public function pass()
    {
        $rv = '';

        foreach ($this->code as $field) {
            echo $field . PHP_EOL;
            $fld = $this->fields($field);

            if (\strlen($fld)) {
                $rv .= $fld . ',';
            }
        }

        return \rtrim($rv, ',');
    }

    public function fields($field)
    {
        $r = '';

        switch (\substr($field, 0, 2)) {

            case  'd.':

              $r = \str_replace('d.', '', $field);
              $r = "(SELECT dm.value FROM documents_meta dm WHERE dm.document_id = i.document_id AND dm.name = '" . \rtrim($r, ',') . "')";

              break;

            case 'i.':
              $r = $field;

              break;

            default:
              $r = "'" . \str_replace('_', ' ', $field) . "'";
        }

        return $r;
    }
}

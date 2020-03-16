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
use Psr\Http\Message\ServerRequestInterface as Request;
use timgws\QueryBuilderParser;

class Result
{
    //list results page data
    public static function list(string $jobID, int $page = 1) : array
    {
        $items =  DB::table("tmp_$jobID")->orderBy('item_id', 'ASC')->paginate(100);

        return [
            'results' => self::objectToArray($items->toArray()),
            'job_id'  => $jobID
        ];
    }

    //call from request's method - put/post/delete
    public static function item(string $jobID, string $method, array $post) : array
    {
        $tbl = "tmp_$jobID";

        $method = \strtolower($method);

        return self::$method($tbl, $post);
    }

    //insert row to jobs temporary table
    public static function put(string $tbl, array $row) : array
    {
        $rv = [];
        $rv['fields']['item_id'] = 0;

        $sql = 'INSERT INTO ' . $tbl . ' (';

        foreach ($row as $col => $value) {
            $sql .= $col . ',';
        }

        $sql = \rtrim($sql, ',') . ') VALUES (';

        foreach ($row as $col => $value) {
          $rv['fields'][$col] = $value;
            $sql .= "'" . $value . "'" . ',';
        }

        $sql = \rtrim($sql, ',') . ');';
        $rv['sql'] = $sql;

        $dbr = DB::insert($sql);
        //$dbr  = DB::connection()->getPdo()->exec($sql);

        $rv['fields']['item_id']  = DB::getPdo()->lastInsertId();

        $code = (($dbr > 0) ? 200 : 500);

        return array_merge(Message::format($code, 'result_add'), $rv);
    }

    //edit a row from jobs temporary table
    public static function post(string $tbl, array $row) : array
    {
        $rv = [];

        $sql = 'UPDATE ' . $tbl . ' SET ';
        print_r($row);
        foreach ($row as $col => $value) {
            if ($col == 'item_id') {
                break;
            }

            $sql .= $col . " = '$value',";
        }

        $sql = \rtrim($sql, ',');

        $sql .= ' WHERE item_id = ' . $row['item_id'];

        $rv['sql'] = $sql;

        $dbr = 0;

        try {

            $dbr = DB::connection()->getPdo()->exec($sql);

        } catch (\Exception $e) {

            $rv['exception'] = $e->getMessage();

        }

        $rc = (($dbr > 0) ? 200 : 500);

        return array_merge(Message::format($rc, 'result_edit'), $rv);
    }

    //Remove a row from jobs temporary table
    public static function delete(string $tbl, array $row) : array
    {
        $sql = 'DELETE FROM ' . $tbl . '  WHERE item_id = ' . $row['item_id'] . ';';

        $dbr = DB::connection()->getPdo()->exec($sql);

        $code = (($dbr > 0) ? 200 : 500);

        return Message::format($code, 'result_remove');
    }

    //filter values
    public static function filter(string $jobID, object $query) : array
    {

        $qbp = new QueryBuilderParser();

        $table = DB::table('tmp_' . $jobID);

        $query = $qbp->parse($query, $table);

        $rv = $query->delete();

        if ($rv > 0) {

            $rv = Message::format(200, 'json.+1');

        } else {

            $rv = Message::format(500, 'json.-1');
        }

        return $rv;
    }

    //find and replace column values
    public static function replace(int $jobID, string $query) : array
    {
        $col = $request->getParam('node');

        $sql = '
        UPDATE
        tmp_' . $jobID . '
        SET ' . $col . " = replace($col, '" .
          \trim($request->getParam('find')) . "', '" . \trim($request->getParam('replace')) . "');";

        try {

            $rv = Message::format(200, 'json.+1', [
                    'sql' => DB::connection()->getPdo()->exec($sql)
                  ]);

        } catch (\Exception $e) {

            $rv = Message::format(500, 'json.-1', [
                    'exception' => $e->getMessage()
                  ]);
        }

        return \array_merge($rv, [
            'request' => [
                'column'    => $col,
                'find'    => $request->getParam('find'),
                'replace' => $request->getParam('replace')
              ]
            ]);
    }

    //set job locate code (post) or return code
    public static function locate(string $method, string $jobID, string $code) : array
    {
        $rv = [];

        if (\strtolower($method) == 'post') {

            $rv = Job::locate((int) $jobID, $code);

        } else {

            $rv = Message::format(200, 'locate_success', ['code' => Job::getLocate($jobID)]);

        }

        return $rv;
    }

    //run console result
    public static function build(string $jobID) : string
    {
        $rv = \shell_exec(\realpath(__DIR__ . '/../../console/bin') . '/result -j ' . $jobID . ' -s');

        return ($rv == null ? '' : $rv);
    }

    //convert results to array
    function objectToArray($data)
    {
        if (\is_object($data)) {

            $data = \get_object_vars($data);

        }

        if (\is_array($data)) {

            return array_map(@[self, 'objectToArray'], $data);

        }

        return $data;
    }

    //remove result files
    public static function clear(string $jobID)
    {
        \array_map('unlink', \glob(__DIR__ . "/../../data/$jobID/result/*"));
    }

}

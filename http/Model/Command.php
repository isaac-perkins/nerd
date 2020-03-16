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

class Command
{
/*
    public $timestamps = false;

    protected $table = 'commands';

    protected $fillable = [
        'user_id',
        'job_id',
        'type_id',
        'process_id',
        'command_type',
        'command',
        'output',
        'completed_at',
    ];
*/
    private static $commands = [
      'crawl',
      'model',
      'tag',
      'result',
      'locate'
    ];

    public static function index(string $command) : int
    {
        return array_search($command, self::$commands);
    }


    public static function process(int $userID, int $jobID, string $action) : array
    {
        if(!in_array($action, self::$commands)) {

          return Message::format(500, Message::Translate('can_not_command'));

        }

        $act = array_search($action, self::$commands);

        //$rv = self::running($jobID);

        //if (!is_array($rv) || !$rv instanceof Countable) {

        $cmd = \realpath(__DIR__ . '/../../console/bin/') . "/$action -j " . $jobID;

        $cmd = 'nohup ' . $cmd . ' > /dev/null 2>&1 & echo $!';

        \exec($cmd, $out, $rv);

            //return self::start($userID, $jobID, $act, $cmd, $out, $rv);
        //}
        return Message::format((($rv > -1) ? 200 : 500), 'command_action_' . $action, ['output'   => $out]);

    }
/*
    public static function running(int $jobID)
    {
        $command = self::where('job_id', '=', $jobID)->whereNull('completed_at')->latest()->get()->first();

        if ($command) {
            $pid = $command->process_id;

            \exec("ps -p $pid", $out);

            if (\count($out) == 1) {
                $command->completed_at = \date('Y-m-d H:i:s');
                $command->save();
            }

            return $command->toArray();
        }
    }
*/
/*
    public static function start(int $userID, int $jobID, int $act, string $cmd, array $out, int $rv) : array
    {

        $command = new self;

        $command->user_id      = $userID;
        $command->job_id       = $jobID;
        $command->process_id   = (int) $out[0];
        $command->command_type = $act;
        $command->command      = $cmd;
        $command->output       = \implode("\n", $out);

        $command->save();

        return array_merge([
          'code' => 200,
          'status'      => 'success',
          'msg'         => Message::translate('json.command_action_' . $act)
        ], $command->toArray());
    }
*/
/*
    public static function stop(string $jobID)
    {
        return self::where('job_id', '=', $jobID)->whereNull('completed_at')->update(['completed_at' => \date('Y-m-d H:i:s')]);
    }
*/
}

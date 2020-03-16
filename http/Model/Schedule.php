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

class Schedule
{
    private $log;

    public function __construct(string $log = __DIR__ . '/../../cache/schedule.json')
    {
        $this->log = $log;
    }

    public function add(array $schedule)
    {
        $cron = $this->get();

        $jobs = \array_column($cron['schedule'], 'job_id');

        $jobID = $schedule['job_id'];

        $index = \array_search($jobID, $jobs);

        if ($index === false) {
            \array_push($cron['schedule'], $schedule);
        } else {
            $cron['schedule'][$index]['cron'] = $schedule['cron'];
        }

        return \file_put_contents($this->log, \json_encode($cron));
    }

    public function list()
    {
        $cron = $this->get();

        return $cron['schedule'];
    }

    public function get()
    {
        return \json_decode(\file_get_contents($this->log), true);
    }
}

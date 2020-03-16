<?php declare(strict_types=1);
/*
 * This file is part of Nerd (Named Entity Recognition Dashboard).
 *
 * (c) Boulevard Software (hello@blvd.ai)
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

namespace Nerd\Test;

use Illuminate\Database\Capsule\Manager;
use Nerd\Model\Jobs;
use Nerd\Model\Training;

use PHPUnit\Framework\TestCase;
use Symfony\Component\Yaml\Yaml;

$parameters = Yaml::parse(\file_get_contents(__DIR__ . '/../../bootstrap/parameters.yml'))['parameters'];

$capsule = new Manager();
$capsule->addConnection($parameters);
$capsule->setAsGlobal();
$capsule->bootEloquent();

final class TrainingTest extends TestCase
{
    public function testFetch(): void
    {
        //add Job
        $rv = $this->addJob();

        $this->assertInternalType('int', $rv['jobID']);

        //keep jobid and job directory
        $jobID  = (string) $rv['jobID'];
        $jobDir = __DIR__ . '/../../data/' . $jobID;

        $rv = Training::fetch($jobID, 'http://commissions.sfplanning.org/cpcpackets/20190228_cal_min.pdf');

        $this->assertEquals(true, ($rv['status'] == 'success'));
        $this->assertEquals(true, \file_exists($jobDir . '/training/http-commissions-sfplanning-org-cpcpackets-20190228-cal-min-pdf'));
    }

    public function addJob(): array
    {
        return Jobs::add('1', 'test', 'test');
    }

    public function deleteJob($jobID)
    {
        $rv = Jobs::remove($jobID);

        $this->assertEquals($rv, [
            'status' => 'success',
            'msg'    => 'Job removed!',
        ]);
    }
}

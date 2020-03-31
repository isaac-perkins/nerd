<?php declare(strict_types=1);
/*
 * This file is part of nerd (Named Entity Recognition Dashboard).
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

namespace Nerd\Test;

use PHPUnit\Framework\TestCase;
use Nerd\Model\Training;

require __DIR__ . '/../../vendor/autoload.php';

require __DIR__ . '/../../bootstrap/capsule.php';

/**
 * @covers Nerd\ModelTraining
*/
final class TestTraining extends TestCase
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

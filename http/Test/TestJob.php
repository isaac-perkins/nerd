<?php declare(strict_types=1);
/*
 * This file is part of nerd (Named Entity Recognition Dashboard).
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

namespace Nerd\Test;

use Cartalyst\Sentinel\Native\Facades\Sentinel;
use Cartalyst\Sentinel\Native\SentinelBootstrapper;
use PHPUnit\Framework\TestCase;
use Nerd\Model\Job;

require __DIR__ . '/../../vendor/autoload.php';

require __DIR__ . '/../../bootstrap/capsule.php';

/**
 * @covers Nerd\Model\Job
*/
class TestJob extends TestCase
{
    private int $jobID = -1;

    public function testAdd(): void
    {
        //add
        $rv = $this->addJob();

        //keep id
        $jobID = (int) $rv['job']['id'];

        $this->assertIsInt($jobID);

        ///Count job table rows
        $rowCount = Job::where('id', '=', $jobID)->count();

        $this->assertEquals(1, $rowCount);

        $this->jobID = $jobID;
    }


    public function testJobList()
    {

        //get admin users' id
        $userID = $this->getAdminID();

        //add a new job
        $rv = Job::add(1, 'test', 'test');
        $jobID = $rv['job']['id'];

        //get jobs list
        $jobList = Job::list($userID->id);

        //Test job title
        $this->assertEquals('test', $jobList[0]->title);

        //delete job
        $this->deleteJob($jobID);

    }

    public function testJobItem()
    {
      //get admin users' id
      $userID = $this->getAdminID();

      //add a test job
      $rv = Job::add(1, 'test', 'test');
      $jobID = $rv['job']['id'];

      //get jobs list
      $jobList = Job::list($userID->id);

      //get job item  id from list
      $jobItemID = $jobList[0]->id;

      //get job item from model
      $jobItem = Job::item($jobItemID);

      //test item's $title
      $this->assertEquals('test', $jobItem->title);

    }

    public function testEdit(): void
    {
        //add job
        $rv = $this->addJob();

        //keep jobid
        $jobID = $rv['job']['id'];

        //job meta json file path
        $json = $this->getJobMeta($jobID);

        //json to array
        $meta = \json_decode(Job::getMeta($jobID), true);

        $meta['title']       = 'test';
        $meta['description'] = 'test';

        //edit job
        $this->assertEquals(Job::edit($jobID, $meta), [
            'code' => 200,
            'status' => 'success',
            'msg'    => 'Job Saved',
        ]);

        //delete job
        $this->deleteJob($jobID);
    }

    public function testClear(): void
    {
        //add job
        $rv = $this->addJob();

        //keep jobid
        $jobID = (int) $rv['job']['id'];

        $jobDir = __DIR__ . '/../../data/' . $jobID;

        //put a file in job content & result directory
        $file = \file_get_contents(__DIR__ . '/inc/job-id.json');

        \file_put_contents($jobDir . '/content/' . 'testfile.txt', $file);
        \file_put_contents($jobDir . '/result/' . 'testfile.txt', $file);

        //clear job
        Job::clear($jobID);

        //test content files gone
        $fi = new \FilesystemIterator($jobDir . '/content/', \FilesystemIterator::SKIP_DOTS);
        $this->assertEquals(0, \iterator_count($fi));

        //delete job
        $this->deleteJob($jobID);
    }

    public function getAdminID()
    {
        $sentinel = (new Sentinel(new SentinelBootstrapper(__DIR__ . '/../../bootstrap/sentinel.php')))->getSentinel();

        return $sentinel->findByCredentials(['login' => 'admin']);
    }
    private function getJobMeta(int $jobID)
    {
        return __DIR__ . '/../../data/' . $jobID . '/job.json';
    }

    private function addJob(): array
    {
        return Job::add(1, 'test', 'test');
    }

    private function deleteJob(int $jobID)
    {
        // Call job remove and ensure correct response
        $rv = Job::remove($jobID);

        $this->assertEquals($rv, [
            'code'   => 200,
            'status' => 'success',
            'msg'    => 'Job Removed',
        ]);

        //Verify jobs directory was removed
        $jobDir = __DIR__ . '/../../data/' . $jobID;

        $this->assertEquals(false, file_exists($jobDir));

    }
}

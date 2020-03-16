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
use PHPUnit\Framework\TestCase;

use Symfony\Component\Yaml\Yaml;

$parameters = Yaml::parse(\file_get_contents(__DIR__ . '/../../bootstrap/parameters.yml'))['parameters'];

$capsule = new Manager();
$capsule->addConnection($parameters);
$capsule->setAsGlobal();
$capsule->bootEloquent();

class JobsTest extends TestCase
{
    public function testAddDelete(): void
    {
        //add
        $rv = $this->addJob();

        $this->assertInternalType('int', $rv['jobID']);

        //keep id
        $jobID = (string) $rv['jobID'];

        $rv = Jobs::where('id', '=', $jobID)->count();

        $this->assertEquals(1, $rv);

        //delete
        $this->deleteJob($jobID);
    }

    public function testEdit(): void
    {
        //add job
        $rv = $this->addJob();

        //keep jobid
        $jobID = $rv['jobID'];

        //job meta json file path
        $json = $this->getJobMeta($jobID);

        //json to array
        $meta = \json_decode(Jobs::getMeta($jobID), true);

        $this->assertInternalType('array', $meta);

        $meta['title']       = 'test';
        $meta['description'] = 'test';

        //edit job
        $this->assertEquals(Jobs::edit($jobID, $meta), [
            'status' => 'success',
            'msg'    => 'Job saved!',
        ]);

        //delete job
        $this->deleteJob($jobID);
    }

    public function testClear(): void
    {
        //add job
        $rv = $this->addJob();

        //keep jobid
        $jobID = (string) $rv['jobID'];

        $jobDir = __DIR__ . '/../../data/' . $jobID;

        //put a file in job content & result directory
        $file = \file_get_contents(__DIR__ . '/data/parameters.yaml');

        \file_put_contents($jobDir . '/content/' . 'testfile.txt', $file);
        \file_put_contents($jobDir . '/result/' . 'testfile.txt', $file);

        //clear job
        Jobs::clear($jobID);

        //test files gone
        $fi = new \FilesystemIterator($jobDir . '/content/', \FilesystemIterator::SKIP_DOTS);
        $this->assertEquals(0, \iterator_count($fi));

        $fi = new \FilesystemIterator($jobDir . '/result/', \FilesystemIterator::SKIP_DOTS);
        $this->assertEquals(0, \iterator_count($fi));

        //delete job
        $this->deleteJob($jobID);
    }

    public function getJobMeta(int $jobID)
    {
        return __DIR__ . '/../../data/' . $jobID . '/job.json';
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

/*





$capsule->bootEloquent();

class TestCode extends TestCase
{

  function testAdd()
  {
      //$rv = Job::add(1, 'test-1', 'test job one');
      $this->assertEquals(true, Link::getFileName($url));
  }

  function testEdit()
  {
      //$this->assertEquals($answer, Link::getFileName($url));
  }

  function testDelete()
  {
      //$this->assertEquals($answer, Link::getFileName($url));
  }

}
*/

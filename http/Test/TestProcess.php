<?php declare(strict_types=1);
/*
 * This file is part of Nerd (Named Entity Recognition Dashboard).
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */
namespace Nerd\Test;

use Cartalyst\Sentinel\Hashing\NativeHasher;
use PHPUnit\Framework\TestCase;
use Nerd\Model\Job;

require __DIR__ . '/../../vendor/autoload.php';

require __DIR__ . '/../../bootstrap/capsule.php';

/**
 * @covers Nerd\Model
*/
class TestProcess extends TestCase
{

  public function testAddTestJobs(): void
  {
      //$jobs[] = $this->addTestJob('Job Process ID', __DIR__ . '/inc/job-id.json');
      //$jobs[] = $this->addTestJob('Job Process Expression', __DIR__ . '/inc/job-expression.json');
      $jobs[] = $this->addTestJob('Job Process Sentences', __DIR__ . '/inc/job-sentences.json');
      //$jobs[] = $this->addTestJob('Job Process XPath', __DIR__ . '/inc/job-xpath.json');

      var_dump($jobs);
  }

  private function addTestJob(String $title, String $file): int {

    $rv = Job::add(1, 'test', 'test');

    $jobID = $rv['job']['id'];

    $meta = \json_decode(\file_get_contents($file), true);

    Job::edit($jobID, $meta);

    $meta = \json_decode(Job::getMeta($jobID), true);

    $this->assertEquals($title, $meta['title']);

    return $jobID;
  }

}

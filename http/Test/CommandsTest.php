<?php declare(strict_types=1);
/*
 * This file is part of nerd (Named Entity Recognition Dashboard).
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

namespace Nerd\Test;
use PHPUnit\Framework\TestCase;
use Nerd\Model\Command;

require __DIR__ . '/../../vendor/autoload.php';

require __DIR__ . '/../../bootstrap/capsule.php';

/**
 * @covers Nerd\Model\Command
*/
class CommandsTest extends TestCase
{
    public function testProcess(): void
    {
        \print_r(Command::process(106, 'crawl', 242));

        //$this->assertInternalType('int', $rv['jobID']);

        //keep id
        //$jobID = (string) $rv['jobID'];
        /*$this->assertEquals(Jobs::edit($jobID, $meta), [
            'status' => 'success',
            'msg'    => 'Job saved!',
        ]);*/
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

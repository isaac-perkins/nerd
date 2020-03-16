<?php
/*
 * This file is part of Nerd.
 *
 * (c) Boulevard Software (hello@blvd.ai)
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */
namespace Console\Model;

require __DIR__ . '/../vendor/autoload.php';

use Monolog\Handler\StreamHandler as StreamHandler;
use Monolog\Logger as Logger;
use PHPUnit\Framework\TestCase;

class TestObserver extends TestCase
{
    public function getJob($id)
    {
        return new Job(21);
    }

    public function getLog(Job $job)
    {
        $log = new Logger('crawler');

        $log->pushHandler(new StreamHandler($job->getDir() . '/crawler.log', Logger::DEBUG));

        return $log;
    }

    public function getObserver(Job $job)
    {
        return new Observer($job, $this->getLog($job));
    }

    /*
        public function testContent()
        {
          $j = $this->getJob(-1);

          $o = $this->getObserver($j);

          $c = $j->getContentDir();

          $this->assertEquals($c, $j->getContentDir());

          if (file_exists($c . '/list.xml')) {
            unlink($c . '/list.xml');
          }

          $o->getContentList($c);

          $this->assertFileExists($c);

        }

        public function testIndex()
        {
          $j = $this->getJob('test');

          $o = $this->getObserver($j);

        }

    */
    public function testTargetRules()
    {
        $j = $this->getJob('test');

        $o = $this->getObserver($j);

        $this->assertEquals(false, $o->passes($j->getTarget(), 'http://sf-planning.org/not-meeting/something/else'));

        $u = 'http://sf-planning.org/not-meeting/but-with-minutes/else';
        $this->assertEquals(false, $o->passes($j->getTarget(), $u));

        $u = 'http://sf-planning.org/meeting/notminutes/else';
        $this->assertEquals(false, $o->passes($j->getTarget(), $u));

        $u = '/CityPlanning/meetingsandevents/MeetingAgendas/6-12-2018%20Meeting%20Minutes.pdf';
        $this->assertEquals(true, $o->passes($j->getTarget(), $u));
    }

    public function testHasBeenCrawled()
    {
        $j = $this->getJob('test');

        $o = $this->getObserver($j);

        $u = 'http://sf-planning.org/meeting/planning-commission-june-1-2017-minutes';

        //$cl = $j->dir . '/content/list.xml';
        //if (file_exists($cl)) {
        //  unlink($cl);
        //}
        //$n = $o->hasBeenCrawled($u, 'response');
        //$this->assertFileExists($j->dir . '/content/list.xml');
        //$this->assertFileExists($j->dir . "/content/$n.txt");
    }
}

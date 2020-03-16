<?php
/*
 * This file is part of Nerd.
 *
 * (c) Boulevard Software (hello@blvd.ai)
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */
namespace Console\Test;

require __DIR__ . '/../vendor/autoload.php';

use Console\Model\Crawl;
use Console\Model\Job;
use Console\Model\Profile;
use GuzzleHttp\Psr7\Uri;
use Monolog\Handler\StreamHandler;
use Monolog\Logger;
use PHPUnit\Framework\TestCase;
use Psr\Http\Message\UriInterface;

abstract class Url implements UriInterface
{
    private $url;

    public function __construct(String $url)
    {
        $this->url = $url;
    }

    public function __toString()
    {
        return $this->url;
    }
}

class TestProfile extends TestCase
{
    public function testSF()
    {
        $j = new Job('11');

        $l = __DIR__ . '/test-11.log';

        if (\file_exists($l)) {
            \unlink($l);
        }

        $log = new Logger('test-crawl-sf');

        $log->pushHandler(new StreamHandler($l, Logger::DEBUG));

        $p = new Profile($j, $log);
        $c = new Crawl($j, $log);

        $u = new Uri('http://sf-planning.org/meetings?page=2');
        $this->assertEquals(true, $p->shouldCrawl($u));

        $u = 'http://sf-planning.org/meeting/historic-preservation-commission-february-7-2018-supporting-documents';
        $this->assertEquals(false, $c->passes($j->getTarget(), $u));

        $u = 'http://sf-planning.org/meeting/historic-preservation-commission-february-7-2016-supporting-documents';
        $this->assertEquals(false, $c->passes($j->getTarget(), $u));

        $u = 'http://sf-planning.org/meeting/planning-commission-january-18-2017-minutes';
        $this->assertEquals(true, $c->passes($j->getTarget(), $u));

        $u = 'http://sf-planning.org/meeting/planning-commission-january-18-2017-agenda';
        $this->assertEquals(false, $c->passes($j->getTarget(), $u));

        $u = 'http://sf-planning.org/meeting/planning-commission-january-18-2016-minutes';
        $this->assertEquals(false, $c->passes($j->getTarget(), $u));

        $u = 'http://sf-planning.org/meeting/planning-commission-october-5-2017-minutes';
        $this->assertEquals(true, $c->passes($j->getTarget(), $u));
    }

    public function testMiami()
    {
        $j = new Job('13');

        $l = __DIR__ . '/test-13.log';

        if (\file_exists($l)) {
            \unlink($l);
        }

        $log = new Logger('test-crawl-miami');

        $log->pushHandler(new StreamHandler($l, Logger::DEBUG));

        $p = new Profile($j, $log);
        $c = new Crawl($j, $log);

        $u = new Uri('http://miamifl.iqm2.com/Citizens/Calendar.aspx?From=1/1/2017&To=12/31/2017&Print=Yes&View=List');
        $this->assertEquals(true, $p->shouldCrawl($u));

        $u = 'http://sf-planning.org/meeting/historic-preservation-commission-february-7-2018-supporting-documents';
        $this->assertEquals(false, $c->passes($j->getTarget(), $u));

        $u = 'http://sf-planning.org/meeting/historic-preservation-commission-february-7-2016-supporting-documents';
        $this->assertEquals(false, $c->passes($j->getTarget(), $u));

        $u = 'http://miamifl.iqm2.com/Citizens/Detail_Meeting.aspx?ID=1999';
        $this->assertEquals(true, $c->passes($j->getTarget(), $u));

        $u = 'http://miamifl.iqm2.com/Citizens/Detail_Meeting.aspx?ID=2000&Print=Yes';
        $this->assertEquals(false, $c->passes($j->getTarget(), $u));

        $u = 'http://miamifl.iqm2.com/Citizens/Detail_Meeting.aspx?ID=1998';
        $this->assertEquals(true, $c->passes($j->getTarget(), $u));

        $u = 'http://miamifl.iqm2.com/Citizens/Detail_Meeting.aspx?ID=1973&Print=Yes';
        $this->assertEquals(false, $c->passes($j->getTarget(), $u));
    }

    /*
      public function testTaoUrls()
      {
        $j = new Model\Job('2');

        $l = __DIR__ . '/test.log';

        if (file_exists($l)) {

          unlink($l);

        }

        $log = new Logger('test-crawl');

        $log->pushHandler(new StreamHandler($l, Logger::DEBUG));

        $p = new Model\Profile($j, $log);

        $u = new Url($j->base['urls'][0]);

        $this->assertEquals(true, $p->shouldCrawl($u));

        $u = new Url($j->target['urls'][0]);
        $this->assertEquals(true, $p->shouldCrawl($u));

        $u = new Url($j->target['urls'][1]);
        $this->assertEquals(true, $p->shouldCrawl($u));

        $u = new Url('http://cdp.local/test/data/1/1.html');
        $this->assertEquals(true, $p->shouldCrawl($u));

        $u = new Url('http://cdp.local/test/data/1/2.html');
        $this->assertEquals(true, $p->shouldCrawl($u));

        $u = new Url('http://cdp.local/test/data/1/3.html');
        $this->assertEquals(true, $p->shouldCrawl($u));

        $u = new Url('http://cdp.local/test/data/1/4.html');
        $this->assertEquals(true, $p->shouldCrawl($u));

      }
    */
}

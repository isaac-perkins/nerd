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

require_once __DIR__ . '/../vendor/autoload.php';

use Nerd\Model\Content as Content;

use PHPUnit\Framework\TestCase;

class TestCrawl extends TestCase
{
    public function testHtml()
    {
        $url = 'https://www.phila.gov/CityPlanning/meetingsandevents/Pages/commissionmeetings.aspx';
        print 'asdf';
        \print_r(Content::fetch($url, __DIR__ . '/test.html'));
    }

    public function testPDF()
    {

    //$url = 'http://www2.oaklandnet.com/oakca1/groups/ceda/documents/agenda/oak065489.pdf';

    //$this->assertEquals($answer, Link::getFileName($url));
    //echo Content::fetch($url);
    }
}

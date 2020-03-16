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

use PHPUnit\Framework\TestCase;

class TestClassify extends TestCase
{
    public function testTypes()
    {
        print Results::types(__DIR__ . '/../../data/11/');
    }

    public function testGetFileUrl()
    {
        $file = 'sf-planning-org-meeting-planning-commission-january-11-2018-minutes';

        $d = new \DomDocument;

        $d->load(__DIR__ . '/../../data/11/content/list.xml');

        $xp = new \DOMXpath($d);

        $lnk = $xp->query('//link[file = "' . $file . '"]')[0];

        $rv = '';

        if ($lnk) {
            $url = $lnk->getElementsByTagName('url')[0];

            if ($url) {
                //insert db meta
                $rv = $url->nodeValue;
            }
        }

        $this->assertEquals('http://sf-planning.org/meeting/planning-commission-january-11-2018-minutes', $rv);
    }
}

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

require __DIR__ . '/../../App/Console/vendor/autoload.php';

use PHPUnit\Framework\TestCase;

class TestClassify extends TestCase
{
    public function testLoad()
    {
        $j = new Job('test');

        $this->assertEquals('http://sf-planning.org/meetings/17', $j->base['url']);
        $this->assertEquals('year=2017', $j->base['qs']);
        $this->assertEquals(1, \count($j->base['filters']));

        $this->assertEquals('http://sf-planning.org/meeting/', $j->target['url']);
        $this->assertEquals('', $j->target['qs']);
        $this->assertEquals('minutes', $j->target['filters'][0]);
    }

    public function testUrl()
    {
        $j = new Job('test');
        $this->assertEquals('http://sf-planning.org/meetings/17?year=2017', $j->getUrl());
    }
}

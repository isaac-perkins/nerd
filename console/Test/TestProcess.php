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

class TestProcess extends TestCase
{
    public function testProcessCrawl()
    {
        $job = new Job(2);

        $process = new Process($job);

        $this->assertEquals(1, $process->start(Task::Crawl));
    }
}

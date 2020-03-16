<?php
/*
 * This file is part of Nerd.
 *
 * (c) Boulevard Software (hello@blvd.ai)
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */
namespace Nerd\Test;

require_once __DIR__ . '/../../vendor/autoload.php';

use PHPUnit\Framework\TestCase;

class testTesseract extends TestCase
{
    public function testFile()
    {
        $doc = __DIR__ . '/../../data/test/tesseract.pdf';

        $t = \realpath(__DIR__ . '/../../App/Console');

        \shell_exec($t . '/tess -d ' . $doc);
        //$this->assertEquals($answer, Link::getFileName($url));
    }
}

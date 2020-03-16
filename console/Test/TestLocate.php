<?php
declare(strict_types=1);
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

use Illuminate\Database\Capsule\Manager;
use PHPUnit\Framework\TestCase;
use Symfony\Component\Yaml\Yaml;

final class TestLocate extends TestCase
{
    public function testLocate()
    {

    //  $j = new Job(49);
        // get connection string
        $parameters = Yaml::parse(\file_get_contents($j->dir . '/parameters.yml'))['parameters'];

        //bootstrap eloquent
        $el = new Manager();
        $el->addConnection($parameters);
        $el->setAsGlobal();
        $el->bootEloquent();

        $l = new Locate($j, $el);

        \print_r($l->go('{{i.address}} {{dm.location}}'));

        //$this->assertEquals(true, $p->shouldCrawl($u, 'response'));
    }
}

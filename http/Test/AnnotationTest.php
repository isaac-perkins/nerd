<?php declare(strict_types=1);
/*
 * This file is part of Nerd (Named Entity Recognition Dashboard).
 *
 * (c) Boulevard Software (hello@blvd.ai)
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

namespace Nerd\Test;

use Illuminate\Database\Capsule\Manager;
use Nerd\Model\Annotation;
use PHPUnit\Framework\TestCase;

use Symfony\Component\Yaml\Yaml;

$parameters = Yaml::parse(\file_get_contents(__DIR__ . '/../../bootstrap/parameters.yml'))['parameters'];

$capsule = new Manager();
$capsule->addConnection($parameters);
$capsule->setAsGlobal();
$capsule->bootEloquent();

final class AnnotationTest extends TestCase
{
    public function testNewAndRemove(): void
    {
        //add single basic annotation
        $rv = Annotation::new('test', 0);

        $this->assertIsArray($rv);

        $this->assertIsInt($rv['id']);

        $id = (string) $rv['id'];

        $this->assertEquals(true, ($rv['code'] == 200));

        $rv = Annotation::where('id', '=', $id)->count();

        $this->assertEquals(1, $rv);

        //remove it
        $this->remove($id);

        //add multi captilized word annotation. eg: Test Multiple Items
        $rv = Annotation::new('Test Multiple Items', 1);

        $this->assertIsInt($rv['id']);

        $id = (string) $rv['id'];

        $this->assertEquals(true, ($rv['code'] == 200));

        $rv = Annotation::where('name', '=', 'test_multiple_items')->where('multi', '=', 1)->count();

        $this->assertEquals(1, $rv);

        //remove it
        $this->remove($id);
    }

    /*
    public function testUnique() : viod
    {

    }
    */

    public function remove(string $id)
    {
        $rv = Annotation::remove((int) $id);

        $this->assertEquals(true, ($rv['code'] == 200));

        $rv = Annotation::where('id', '=', $id)->count();

        $this->assertEquals(0, $rv);
    }
}

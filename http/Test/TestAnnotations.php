<?php declare(strict_types=1);
/*
 * This file is part of nerd (Named Entity Recognition Dashboard).
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

namespace Nerd\Test;

use PHPUnit\Framework\TestCase;
use Nerd\Model\Annotation;

require __DIR__ . '/../../vendor/autoload.php';

require __DIR__ . '/../../bootstrap/capsule.php';

/**
 * @covers Nerd\Model\Annotation
*/
final class TestAnnotations extends TestCase
{
    public function testNewAndRemove(): void
    {
        //add single basic annotation
        $rv = Annotation::new('test', 0, 1, 1);

        $this->assertIsArray($rv);
        var_dump($rv);

        $id = (Int) $rv['annotation']['id'];

        $this->assertIsInt($id);

        $this->assertEquals(200, $rv['code']);

        $rv = Annotation::where('id', '=', $id)->count();

        $this->assertEquals(1, $rv);

        //remove it
        $this->remove($id);

        //add multi captilized word annotation. eg: Test Multiple Items
        $rv = Annotation::new('Test Multiple Items', 1, 1, 1);

        $id = (Int) $rv['annotation']['id'];

        $this->assertIsInt($id);

        $this->assertEquals(200, $rv['code']);

        //get add multi annotation
        $rv = Annotation::where('name', '=', 'test_multiple_items')->where('multi', '=', 1)->count();

        $this->assertEquals(1, $rv);

        //remove add multi annotation
        $this->remove($id);
    }

    public function remove(Int $id)
    {
        $rv = Annotation::remove($id);

        $this->assertEquals(200, $rv['code']);

        $rv = Annotation::where('id', '=', $id)->count();

        $this->assertEquals(0, $rv);
    }
}

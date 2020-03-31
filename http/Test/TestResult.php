<?php declare(strict_types=1);
/*
 * This file is part of Nerd (Named Entity Recognition Dashboard).
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */
namespace Nerd\Test;

use Cartalyst\Sentinel\Hashing\NativeHasher;
use PHPUnit\Framework\TestCase;
use Nerd\Model\Result;

require __DIR__ . '/../../vendor/autoload.php';

require __DIR__ . '/../../bootstrap/capsule.php';

/**
 * @covers Nerd\Model\Result
*/
class TestResult extends TestCase
{
    /*
        Test result controller put
    */
    public static function testPut()
    {
      $environment = \Slim\Http\Environment::mock([
                  'REQUEST_METHOD' => 'put',
                  'REQUEST_URI' => '/result',
                  'QUERY_STRING'=>'']
              );
              $request = \Slim\Http\Request::createFromEnvironment($environment);
              $response = new \Slim\Http\Response();

              Result::put($request, )
    }


}

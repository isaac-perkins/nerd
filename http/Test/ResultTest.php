<?php declare(strict_types=1);
/*
 * This file is part of Nerd (Named Entity Recognition Dashboard).
 *s
 * (c) Boulevard Software (hello@blvd.ai)
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

namespace Nerd\Test;

use Cartalyst\Sentinel\Hashing\NativeHasher;
use Illuminate\Database\Capsule\Manager as DB;
use Nerd\Model\Result;
use PHPUnit\Framework\TestCase;
use Symfony\Component\Yaml\Yaml;

require(__DIR__ '/../../vendor/autoload.php');

$parameters = Yaml::parse(\file_get_contents(__DIR__ . '/../../bootstrap/parameters.yml'))['parameters'];

$capsule = new DB();
$capsule->addConnection($parameters);
$capsule->setAsGlobal();
$capsule->bootEloquent();

class ResultTest extends TestCase
{
    /*
        Get test user or add if already there
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

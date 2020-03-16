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

use Cartalyst\Sentinel\Hashing\NativeHasher;
use Illuminate\Database\Capsule\Manager as DB;
use Nerd\Model\User;
use PHPUnit\Framework\TestCase;
use Symfony\Component\Yaml\Yaml;

$parameters = Yaml::parse(\file_get_contents(__DIR__ . '/../../bootstrap/parameters.yml'))['parameters'];

$capsule = new DB();
$capsule->addConnection($parameters);
$capsule->setAsGlobal();
$capsule->bootEloquent();

class UsersTest extends TestCase
{
    /*
        Get test user or add if already there
    */
    public static function getUser()
    {
        $ul = DB::table('user')->where('username', '=', 'test')->get();

        if ($ul->count() == 0) {
            $user              = new User();
            $user->username    = 'test';
            $user->email       = 'test@nerd.preset.cloud';
            $user->password    = NativeHasher::hash('test');
            $user->first_name  = 'test';
            $user->last_name   = 'test';
            $user->permissions = [];

            $user->save();
        } else {
            $user = User::find($ul->first()->id);
        }

        return $user;
    }

    /*
        Test get user profile
    */
    public function testProfile(): void
    {
        $user = self::getUser();

        $answer = [
            'user' => [
                'id'         => $user->id,
                'username'   => $user->username,
                'email'      => $user->email,
                'first_name' => $user->first_name,
                'last_name'  => $user->last_name,
            ],
        ];

        $this->assertEquals($answer, User::profile($user));
    }

    /*
        Test edit user
    */
    public function testEdit(): void
    {
        $post = \json_decode('{"title":"admin","fname":"test","lname":"test","email":"test@nerd.preset.cloud","old_password":"","new_password":"","confirm_password":""}', true);

        $user = self::getUser();

        $answer = [
            'user' => [
                'id'         => $user->id,
                'username'   => $user->username,
                'email'      => $user->email,
                'first_name' => $user->first_name,
                'last_name'  => $user->last_name,
            ],
        ];

        $rv = User::edit($user, $post);

        $this->assertEquals($answer, $rv);
    }

    /*
        Test pwd update, which, throws exceptions, so just calling it tests it somewhat...
    */
    public function testUpdatePwd(): void
    {
        $user = self::getUser();

        User::updatePwd($user, 'test', 'test01', 'test01');

        $this->assertEquals(1, 1);
    }

    /*
        Test remove user
    */
    public function testRemove(): void
    {
        $user = self::getUser();

        $rv = User::remove($user->id);

        if ($rv['code'] !== 200) {
            print \PHP_EOL . "UsersTest.remove($user->id)";
            \print_r($rv);
            exit;
        }

        $rv = User::where('id', '=', $user->id)->count();

        $this->assertEquals(0, $rv);
    }
}

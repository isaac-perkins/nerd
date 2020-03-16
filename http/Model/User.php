<?php declare(strict_types=1);
/*
 * This file is part of Nerd (Named Entity Recognition Dashboard).
 *
 * (c) Boulevard Software (hello@blvd.ai)
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

namespace Nerd\Model;

use Cartalyst\Sentinel\Hashing\NativeHasher;
use Cartalyst\Sentinel\Users\EloquentUser;
use Illuminate\Database\Capsule\Manager as DB;

class User extends EloquentUser
{
    protected $table = 'user';

    protected $primaryKey = 'id';

    protected $fillable = [
        'username',
        'email',
        'password',
        'last_name',
        'first_name',
        'permissions',
    ];

    protected $loginNames = ['username', 'email'];

    /*
        Delete a user
    */
    public static function remove(int $id) : array
    {
        try {

            self::destroy($id);

            $rv = Message::format(200, 'user_deleted');

        } catch (\Exception $e) {

            $rv = Message::format(500, 'remove_user_error', ['exception'   => $e->getMessage()]);
        }

        return $rv;
    }

    /*
        Get user's profile as array
    */
    public static function profile($user)
    {
        return [
            'user' => [
                'id'         => $user->id,
                'username'   => $user->username,
                'email'      => $user->email,
                'first_name' => $user->first_name,
                'last_name'  => $user->last_name,
            ],
        ];
    }

    /*
        Edit user det's _+ pwd
    */
    public function edit($user, array $post)
    {
        if (\strlen($post['old_password']) > 0) {
            try {
                self::updatePwd(
              $user,
              $post['old_password'],
              $post['new_password'],
              $post['confirm_password']
          );
            } catch (\Exception $e) {
                return Message::format(500, 'Can not update password', ['exception' => $e->getMessage()]);
            }
        }

        if ($user->email !== $post['email']) {
            $user->email = $post['email'];
        }

        $user->first_name = $post['fname'];
        $user->last_name  = $post['lname'];

        $user->save();

        return Message::format(200, 'profile_updated', self::profile($user));
    }

    /*
        Update user password
    */
    public function updatePwd($user, string $old, string $new, string $confirm) : void
    {
        if (!NativeHasher::check($old, $user->password) || $new != $confirm) {
            throw new \Exception('Invalid password');
        }

        try {
            $sql = DB::raw('UPDATE "user" ' . "SET password = '" . NativeHasher::hash($new) . "' WHERE id = " . $user->id);

            DB::select($sql);
        } catch (\Exception $e) {
            throw new \Exception('Can not update password. ' . $e->getMessage());
        }
    }

    //Send email to invite a new user
    public function invite($locale, $mailer, $invite, $data) : array
    {
        $user        = new \StdClass;
        $user->name  = $data['name'];
        $user->email = $data['email'];

        try {

            $mailer->sendMessage('Emails/' . $locale . '/invite.twig', ['user' => $user, 'invite' => $invite], function ($message) use ($user) {
                $message->setTo($user->email, $user->name);
                $message->setSubject('Welcome to the Team!');
            });

            $rv = Message::format(200, 'email_sent');

        } catch (\Exception $e) {

            $rv = Message::format(500, 'email_error', ['exception' => $e->getMessage()]);
        }

        return $rv;
    }
}

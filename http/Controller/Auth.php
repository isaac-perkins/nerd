<?php declare(strict_types=1);
/*
 * This file is part of Nerd (Named Entity Recognition Dashboard).
 *
 * (c) Boulevard Software (hello@blvd.ai)
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */
namespace Nerd\Controller;

use Cartalyst\Sentinel\Checkpoints\ThrottlingException;
use Nerd\Model\Message;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

use Respect\Validation\Validator as V;

class Auth extends Controller
{
    public function login(Request $request, Response $response)
    {
        if ($request->isPost()) {
            $credentials = [
                'username' => $request->getParam('username'),
                'password' => $request->getParam('password'),
            ];

            try {

                if ($this->auth->authenticate($credentials)) {

                    return $this->json($response, Message::format(200, 'login_succesful'));
                }

            } catch (ThrottlingException $e) {

                return $this->json($response, Message::format(500, 'too_many_logins'));
            }

            return $this->json($response, Message::format(401, 'bad_username'));

        } else {
          
            $settings = $this->settings();

            $recap = $settings['google']['recaptcha'];

            if (\strlen($recap['key']) > 0 && (!$this->recpatcha($recap['secret'], $request->getParam('g-recaptcha-response')))) {
                return $this->redirect($response, 'home');
            }

            return $this->view->render($response, 'Auth/login.twig');
        }
    }

    public function register(Request $request, Response $response, $invited = null)
    {
        $invite = $this->settings()['invite'];

        if ($request->isPost()) {
            if ($request->getParam('invite') !== $invite) {
                $this->validator->addError('invite', Message::translate('nerd.invite_code_error'));
            } else {
                $username = $request->getParam('username');
                $email    = $request->getParam('email');
                $password = $request->getParam('password');

                $this->validator->validate($request, [
                    'username' => V::length(3, 25)->alnum('_')->noWhitespace(),
                    'email'    => V::noWhitespace()->email(),
                    'password' => [
                        'rules'    => V::noWhitespace()->length(6, 25),
                        'messages' => [
                            'length' => Message::translate('nerd.password_verify'),
                        ],
                    ],
                    'password_confirm' => [
                        'rules'    => V::equals($password),
                        'messages' => [
                            'equals' => Message::translate('nerd.password_match_error'),
                        ],
                    ],
                ]);

                if ($this->auth->findByCredentials(['login' => $username])) {
                    $this->validator->addError('username', Message::translate('nerd.username_exists'));
                }

                if ($this->auth->findByCredentials(['login' => $email])) {
                    $this->validator->addError('email', Message::translate('nerd.email_exists'));
                }

                if ($this->validator->isValid()) {

                    $role = $this->auth->findRoleByName('User');

                    $user = $this->auth->registerAndActivate([
                        'username'    => $username,
                        'email'       => $email,
                        'password'    => $password,
                        'permissions' => [
                            'user.delete' => 1,
                        ],
                    ]);

                    $role->users()->attach($user);


                $credentials = [
                    'username' => $username,
                    'password' => $password,
                ];

                $this->auth->authenticate($credentials);

                return $this->redirect($response, 'home');
              }
            }
        }

        $settings = $this->settings();

        if (!$this->recpatcha($settings['google']['recaptcha']['secret'], $request->getParam('g-recaptcha-response'))) {
            return $this->view->render($response, 'App/home.twig');
        }

        $rv = [
            'invite' => $request->getParam('invite'),
        ];

        return $this->view->render($response, 'Auth/register.twig', $rv);
    }

    public function logout(Request $request, Response $response): Response
    {
        $this->auth->logout();

        return $this->redirect($response, 'home');
    }
}

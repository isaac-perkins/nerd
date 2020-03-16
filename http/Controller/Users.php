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

use Nerd\Model\User;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

class Users extends Controller
{
    public function profile(Request $request, Response $response)
    {
        $usr = $this->auth->getUser();

        //$usr = User::find($usr->getUserId());

        if ($request->isPost()) {
            return $this->json($response, User::edit($usr, $this->jsonRequest($request)));
        }

        return $this->view->render($response, 'Users/profile.twig', User::profile($usr));
    }

    public function item(Request $request, Response $response, string $userID)
    {
        return $this->view->render($response, 'Users/list.twig');
    }

    public function list(Request $request, Response $response)
    {
        return $this->view->render($response, 'Users/list.twig', [
            'users' => User::orderBy('id', 'DESC')->get(),
        ]);
    }

    public function remove(Request $request, Response $response, Int $userID)
    {
        return $this->json($response, User::remove($userID));
    }

    public function accepted(Request $request, Response $response)
    {
        $settings = $this->settings();

        if (!$this->recpatcha($settings['google']['recaptcha']['secret'], $request->getParam('g-recaptcha-response'))) {
            $this->validator->addError('auth', 'The reCAPTCHA was not entered correctly.');

            $data = [
                'gcaptcha' => $settings['google']['recaptcha']['key'],
            ];

            return $this->view->render($response, 'Users/accept.twig');
        }

        $invite = $request->getParam('invite');

        if ($invite !== $settings['invite']) {
            $this->validator->addError('invite', 'Invalid invite code');

            return $this->view->render($response, 'Users/accept.twig');
        }

        return $this->view->render($response, 'Auth/register.twig', ['invite' => $invite]);
    }

    public function accept(Request $request, Response $response)
    {
        $data = ['invite' => $request->getParam('invite')];

        return $this->view->render($response, 'Users/accept.twig', $data);
    }

    public function invite(Request $request, Response $response)
    {
        $rv = User::invite(
            $this->settings()['locale'],
            $this->container->mailer,
            $this->settings()['invite'],
            $this->jsonRequest($request));

        return $this->json($response, $rv);
    }
}

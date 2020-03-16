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

use Nerd\Model\Templates;

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

class App extends Controller
{
    public function home(Request $request, Response $response): Response
    {
        if ($this->auth->getUser()) {
            return $this->redirect($response, 'jobsList');
        }

        $recapKey = $this->getSetting('google');
        $recapKey = $recapKey['recaptcha']['key'];

        if (\strlen($recapKey) > 0) {
            return $this->view->render($response, 'App/home.twig');
        }

        return $this->redirect($response, 'login');
    }

    public function wiki(Request $request, Response $response): Response
    {
        $oct = \substr(\sprintf('%o', \fileperms(__DIR__ . '/../../wiki')), -4);

        $data = [
            'is_writable' => ($oct == '0775') ? 1 : 0,
        ];

        return $this->view->render($response, 'App/wiki.twig', $data);
    }

    public function config(Request $request, Response $response): Response
    {
        $settingsPath = __DIR__ . '/../../bootstrap/settings.php';

        $trans = $this->container->translator;

        if ($request->isPost()) {
            $content = $request->getParam('content');

            try {
                \file_put_contents($settingsPath, $content);

                $rv  = [
                    'status_code' => 200,
                    'status'      => $trans->trans('nerd.+1'),
                    'msg'         => $trans->trans('nerd.config') . ' ' . $trans->trans('nerd.saved'),
                ];
            } catch (\Exception $e) {
                $rv  = [
                    'status_code' => 500,
                    'status'      => $trans->trans('nerd.-1'),
                    'msg'         => $trans->trans('nerd.could_not_save_config_file'),
                    'exception'   => $e->getMessage(),
                ];
            }

            return $this->json($response, $rv);
        }

        $config = ['config' => \file_get_contents($settingsPath)];

        return $this->view->render($response, 'App/config.twig', $config);
    }

    public function templates(Request $request, Response $response): Response
    {
        $data = Templates::list();

        return $this->view->render($response, 'App/templates.twig', $data);
    }

    public function template(Request $request, Response $response, string $template): Response
    {
        $locale = $this->settings()['locale'];

        if ($request->isPost()) {
            $rv = Templates::edit($template, $request->getParam('content'), $locale);

            return $this->json($response, $rv);
        }

        $data = [
            'content'   => \file_get_contents(Templates::getPath($template, $locale)),
            'templates' => Templates::item($template),
        ];

        return $this->view->render($response, 'App/template.twig', $data);
    }
}

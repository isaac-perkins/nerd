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

use Awurth\Slim\Validation\Validator;
use Cartalyst\Sentinel\Sentinel;
use Interop\Container\ContainerInterface;
use Psr\Http\Message\ResponseInterface as Response;
use Slim\Exception\NotFoundException;
use Slim\Http\Request as Request;
use Slim\Router;
use Slim\Views\Twig;

/**
 * @property Twig view
 * @property Router router
 * @property Validator validator
 * @property Sentinel auth
 */
abstract class Controller
{
    protected $container;

    public function __construct(ContainerInterface $container)
    {
        $this->container = $container;
    }

    public function __get($property)
    {
        return $this->container->get($property);
    }

    public function settings()
    {
        return $this->container->get('settings');
    }

    public function getSetting($key)
    {
        $settings = $this->container->get('settings');

        return $settings[$key];
    }

    public function recpatcha($secret, $gRecaptchaResponse): bool
    {
        try {

            $req = \file_get_contents('https://www.google.com/recaptcha/api/siteverify?secret=' . $secret . '&response=' . $gRecaptchaResponse);

            if ($req == false) {
              return false;
            }

            $resp = \json_decode($req);

        } catch (\Exception $e) {

            return [
                'code' => 500,
                'status'      => 'danger',
                'msg'         => 'Can not get recaptcha',
                'exception'   => $e->getMessage(),
            ];
        }

        return ($resp->success) ? true: false;
    }

    //Stop the script and print info about a variable
    public function debug($data)
    {
        die('<pre>' . \print_r($data, true) . '</pre>');
    }

    public function version(bool $create = false)
    {
        $svn = \shell_exec('svn info --xml');

        $dom = new \DOMDocument();

        $dom->loadXML($svn);

        $commit = $dom->getElementsByTagName('commit')[0];

        return '4' . $commit->getAttribute('revision');
    }

    public function params(Request $request, array $params)
    {
        $data = [];

        foreach ($params as $param) {
            $data[$param] = $request->getParam($param);
        }

        return $data;
    }

    public function redirect(Response $response, $route, array $params = [])
    {
        return $response->withRedirect($this->router->pathFor($route, $params));
    }

    public function redirectTo(Response $response, $url)
    {
        return $response->withRedirect($url);
    }

    public function json(Response $response, $data, $status = 200)
    {
        return $response->withJson($data, $status);
    }

    public function jsonRequest(Request $request): array
    {
        $json = $request->getBody();

        return \json_decode((string) $json, true);
    }

    public function xml(Response $response, \DomDocument $output, $status = 200)
    {
        $response->withHeader('Content-Type', 'application/xml');

        return $response->withStatus($status)->getBody()->write($output->saveXML());
    }

    public function write(Response $response, $data, $status = 200)
    {
        return $response->withStatus($status)->getBody()->write($data);
    }

    public function notFoundException(Request $request, Response $response)
    {
        return new NotFoundException($request, $response);
    }
}

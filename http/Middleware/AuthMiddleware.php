<?php
/*
 * This file is part of Nerd (Named Entity Recognition Dashboard).
 *
 * (c) Boulevard Software (hello@blvd.ai)
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */
namespace Nerd\Middleware;

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

class AuthMiddleware extends Middleware
{
    public function __invoke(Request $request, Response $response, callable $next)
    {
        if (!$this->auth->check()) {
            return $response->withRedirect($this->router->pathFor('login'));
        }

        return $next($request, $response);
    }
}

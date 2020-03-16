<?php
/*
 * This file is part of Nerd.
 *
 * (c) Boulevard Software (hello@blvd.ai)
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */
$app->add(new Nerd\Middleware\CsrfMiddleware($container));

$app->add(new Nerd\Middleware\MonologMiddleware($container));

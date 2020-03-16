<?php
/*
 * This file is part of Nerd (Named Entity Recognition Dashboard).
 *
 * (c) Boulevard Software (hello@blvd.ai)
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */
$app->group('', function () {
    $this->map(['GET', 'POST'], '/login', 'Auth:login')->setName('login');
    $this->map(['GET', 'POST'], '/register', 'Auth:register')->setName('register');
    $this->map(['GET'], '/accept', 'Users:accept')->setName('accept');
    $this->map(['GET'], '/accepted', 'Users:accepted')->setName('accepted');
})->add(new Nerd\Middleware\GuestMiddleware($container));

$app->group('', function () {
    $this->get('/logout', 'Auth:logout')->setName('logout');
    $this->map(['GET', 'POST'], '/profile', 'Users:profile')->setName('profile');
})->add(new Nerd\Middleware\AuthMiddleware($container));

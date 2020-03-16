<?php
/*
 * This file is part of Nerd.
 *
 * (c) Boulevard Software (hello@blvd.ai)
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */
$controllers = \glob(__DIR__ . '/../http/Controller/*.php');

foreach ($controllers as $controller) {
    $control             = \substr(\basename($controller), 0, -4);
    $container[$control] = function ($container) use ($control) {
        $control =  "Nerd\Controller\\" . $control;

        return new $control($container);
    };
}

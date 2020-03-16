<?php
/*
 * This file is part of Nerd.
 *
 * (c) Boulevard Software (hello@blvd.ai)
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */
\session_start();

require __DIR__ . '/../vendor/autoload.php';

$settings = require __DIR__ . '/../bootstrap/settings.php';

$app = new \Slim\App($settings);

require __DIR__ . '/../bootstrap/dependencies.php';

require __DIR__ . '/../bootstrap/handlers.php';

require __DIR__ . '/../bootstrap/middleware.php';

require __DIR__ . '/../bootstrap/controllers.php';

require __DIR__ . '/../bootstrap/routes.php';

$app->run();

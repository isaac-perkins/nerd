<?php
/*
 * This file is part of Nerd.
 *
 * (c) Boulevard Software (hello@blvd.ai)
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */
use Awurth\Slim\Validation\Validator;
use Awurth\Slim\Validation\ValidatorExtension;
use Cartalyst\Sentinel\Native\Facades\Sentinel;
use Cartalyst\Sentinel\Native\SentinelBootstrapper;
use Illuminate\Filesystem\Filesystem;
use Illuminate\Translation\FileLoader;
use Illuminate\Translation\Translator;
use Monolog\Handler\StreamHandler;
use Monolog\Logger as Logger;
use Nerd\Resources\TwigExtension\Cron;
use Nerd\Resources\TwigExtension\Translate;
//use Slim\Flash\Messages;

use Slim\Views\Twig;
use Slim\Views\TwigExtension;

$container = $app->getContainer();

require_once(__DIR__ . '/capsule.php');

$container['db'] = function () use ($capsule) {
    return $capsule;
};

$container['auth'] = function () {
    $sentinel = new Sentinel(new SentinelBootstrapper(__DIR__ . '/sentinel.php'));

    return $sentinel->getSentinel();
};
/*
$container['flash'] = function () {
    return new Messages();
};
*/
$container['validator'] = function () {
    return new Validator();
};

$container['mailer'] = function ($container) {

    $email = $container['settings']['email'];

    $server = $email['server'];

    $mailer = new \Anddye\Mailer\Mailer($container['view'], [
        'host'      => $server['host'],
        'port'      => $server['port'],
        'username'  => $server['username'],
        'password'  => $server['password'],
        'protocol'  => $server['protocol'],
    ]);

    // Set sender
    $mailer->setDefaultFrom($email['sender']['email'], $email['sender']['name']);

    return $mailer;
};

$container['translator'] = function ($container) {

    $loader = new FileLoader(new Filesystem(), __DIR__ . '/../http/Resources/lang');

    $settings = $container->get('settings');

    return new Translator($loader, $settings['locale']);
};

$container['view'] = function ($container) {

    $view = new Twig(
        $container['settings']['view']['template_path'],
        $container['settings']['view']['twig']
    );

    $view->addExtension(new TwigExtension(
        $container['router'],
        $container['request']->getUri()
    ));

    $view->addExtension(new Translate($container->get('translator')));

    $view->addExtension(new Twig_Extension_Debug());

    $view->addExtension(new ValidatorExtension($container['validator']));

    //$view->addExtension(new Cron($container['request']));

    //$view->getEnvironment()->addGlobal('flash', $container['flash']);

    $view->getEnvironment()->addGlobal('auth', $container['auth']);

    $view->getEnvironment()->addGlobal('cache', $container['settings']['view']['twig']['cache']);

    $view->getEnvironment()->addFilter(new Twig_SimpleFilter('cast_to_array', function ($stdClassObject) {
        $response = [];

        foreach ($stdClassObject as $key => $value) {
            $response[] = [$key, $value];
        }

        return $response;
    }));

    $twig = $view->getEnvironment();

    $twig->addGlobal('settings', $container->get('settings'));

    return $view;
};

$container['logger'] = function ($container) {
    $log = $container->get('settings')['monolog']['service'];

    $path = $log['path'];

    $logger = new Logger($path);

    $logger->pushHandler(new StreamHandler($path, $log['level']));

    return $logger;
};

Illuminate\Pagination\Paginator::currentPageResolver(function ($pageName = 'page') use ($container) {

    $page = $container->request->getParam($pageName);

    if (filter_var($page, FILTER_VALIDATE_INT) !== false && (int) $page >= 1) {
        return $page;
    }
    return 1;
});

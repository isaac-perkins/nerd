<?php
/*
 * This file is part of Nerd (Named Entity Recognition Dashboard).
 *
 * (c) Boulevard Software (hello@blvd.ai)
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */
/*$app->group('/jobs/{jobid}/schedule', function () {
  $this->get('', 'Jobs:getSchedule');
  $this->post('', 'Jobs:setSchedule');
})->add(new Nerd\Middleware\AuthMiddleware($container));*/

//Templates
$app->group('/templates', function () {
    $this->get('', 'App:templates');
    $this->get('/{template}', 'App:template');
    $this->post('/{template}', 'App:template');
})->add(new Nerd\Middleware\AuthMiddleware($container));

//Config
$app->group('/config', function () {
    $this->map(['get', 'post'], '', 'App:config');
})->add(new Nerd\Middleware\AuthMiddleware($container));

//Wiki
$app->group('/wiki', function () {
    $this->get('', 'App:wiki');
})->add(new Nerd\Middleware\AuthMiddleware($container));

//Solr
$app->group('/solr', function () {
    $this->get('', 'Solr:list');
    $this->get('/import', 'Solr:import');
    $this->post('/import', 'Solr:upload');
    $this->get('/import/{file}/log', 'Solr:getLog');
})->add(new Nerd\Middleware\AuthMiddleware($container));

//Users
$app->group('/users', function () {
    $this->get('', 'Users:list');
    $this->delete('/{userid}', 'Users:remove');
    $this->put('/invite', 'Users:invite');
})->add(new Nerd\Middleware\AuthMiddleware($container));

//Results
$app->group('/jobs/{jobid}/results', function () {
    $this->get('/', 'Results:list');
    $this->map(['PUT', 'POST', 'DELETE'], '', 'Results:item');
    $this->post('/sort', 'Results:sort');
    $this->post('/filter', 'Results:filter');
    $this->post('/replace', 'Results:replace');
    $this->map(['GET', 'POST'], '/locate', 'Results:locate');
    $this->get('/export', 'Results:export');
  //  $this->get('/map/markers', 'Results:markers');
})->add(new Nerd\Middleware\AuthMiddleware($container));

//Documents
$app->group('/jobs/{jobid}/documents/{document}', function () {
    $this->get('', 'Documents:item')->setName('documentsItem');
})->add(new Nerd\Middleware\AuthMiddleware($container));

//Training
$app->group('/jobs/{job}/training', function () {
    $this->get('', 'Training:item')->setName('trainingItem');
    $this->put('', 'Training:fetch')->setName('trainingAdd');
    $this->post('', 'Training:save')->setName('trainingSave');
    $this->delete('', 'Training:remove')->setName('trainingRemove');
    $this->post('/upload', 'Training:upload')->setName('trainingUpload');
    $this->get('/download', 'Training:download')->setName('trainingDownload');
})->add(new Nerd\Middleware\AuthMiddleware($container));

// Jobs
$app->group('/jobs', function () {
    $this->get('/list', 'Jobs:list')->setName('jobsList');
    $this->put('', 'Jobs:add')->setName('jobsAdd');
    $this->map(['GET', 'POST', 'DELETE'], '/{id}', 'Jobs:item')->setName('jobsItem');
    $this->get('/{id}/build', 'Jobs:build')->setName('jobsBuild');
    $this->get('/{id}/results', 'Results:list')->setName('jobsResults');
    $this->get('/{id}/log', 'Jobs:log')->setName('jobsLogs');
    $this->delete('/{id}/cache', 'Jobs:clear')->setName('jobsClear');
})->add(new Nerd\Middleware\AuthMiddleware($container));

// Annotations
$app->group('/annotations', function () {
    $this->get('', 'Annotations:list');
    $this->put('', 'Annotations:add');
    $this->delete('/{id}', 'Annotations:remove');
})->add(new Nerd\Middleware\AuthMiddleware($container));

//Home - robot
$app->get('/', 'App:home')->setName('home');

/*
 *       Make trailing slash same as without: http://www.slimframework.com/docs/cookbook/route-patterns.html
*/
use Psr\Http\Message\RequestInterface as Request;
use Psr\Http\Message\ResponseInterface as Response;

$app->add(function (Request $request, Response $response, callable $next) {
    $uri = $request->getUri();
    $path = $uri->getPath();

    if ($path != '/' && \substr($path, -1) == '/') {
        // permanently redirect paths with a trailing slash
        $uri = $uri->withPath(\substr($path, 0, -1));

        return $response->withRedirect((string) $uri, 301);
    }

    return $next($request, $response);
});

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

use Nerd\Model\Job;
use Psr\Http\Message\ResponseInterface as Response;

use Psr\Http\Message\ServerRequestInterface as Request;

class Jobs extends Controller
{
    public function list(Request $request, Response $response)
    {
        $user = $this->auth->getUser();

        return $this->view->render($response, 'Jobs/list.twig', [
            'jobs'    => Job::list($user->id),
            'version' => $this->version(),
        ]);
    }

    public function item(Request $request, Response $response, string $id)
    {
        $id = (int) $id;

        switch (\strtolower($request->getMethod())) {

          case 'post':

              $post = $this->jsonRequest($request);

              return $this->json($response, Job::edit($id, $post));

          case 'delete':

              return $this->json($response, Job::remove($id));

          default:

              $jm = Job::getMeta($id);

              $rv = [
                  'job'   => Job::item($id),
                  'crawl' => \json_decode($jm, true),
                  'json'  => $jm,
              ];

              return $this->view->render($response, 'Jobs/edit.twig', $rv);
        }
    }

    public function log(Request $request, Response $response, string $id)
    {
        return $this->view->render($response, 'Jobs/log.twig', Job::log($id, \strtolower($request->getParam('log'))));
    }

    public function clear(Request $request, Response $response, string $id)
    {
        return $this->json($response, Job::clear($id));
    }

    public function build(Request $request, Response $response, string $jobID)
    {
        $action = $request->getParam('act');

        if ($action) {

            $user = $this->container->auth->getUser();

            $rv = Job::build($user->id, (int) $jobID, $action);

        } else {

            $rv = [
                'status' => 'danger',
                'msg'    => 'Invalid qs param ?act=[crawl,model,tag,result,locate]'
            ];
        }

        return $this->json($response, $rv);
    }

    public function add(Request $request, Response $response)
    {
        $ownerID = $this->auth->getUser()->getUserId();

        $title = $request->getParam('title');

        $desc = $request->getParam('description');

        return $this->json($response, Job::add($ownerID, $title, $desc));
    }

    /*
      public function getSchedule(Request $request, Response $response, string $jobID)
      {
        return $this->json($response, Job::getSchedule($jobID));
      }

      public function setSchedule(Request $request, Response $response, string $jobID)
      {
        $json = $request->getBody();

        return $this->json($response, Job::setSchedule($jobID, json_decode($json, true)));
      }
    */
}

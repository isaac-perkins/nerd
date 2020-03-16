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

use Nerd\Model\Annotation;
use Psr\Http\Message\ResponseInterface as Response;

use Psr\Http\Message\ServerRequestInterface as Request;

class Annotations extends Controller
{
    public function list(Request $request, Response $response)
    {
        $data = [
            'annotations' => Annotation::list(),
        ];

        return $this->view->render($response, 'Annotation/list.twig', $data);
    }

    public function add(Request $request, Response $response)
    {
        $title = $request->getParam('title');

        $multi = (($request->getParam('multi')) ? 1 : 0);

        $type = $request->getParam('type');

        $order = $request->getParam('order');

        return $this->json($response, Annotation::new($title, $multi, $type, $order));
    }

    public function remove(Request $request, Response $response, Int $id)
    {
        return $this->json($response, Annotation::remove($id));
    }
}

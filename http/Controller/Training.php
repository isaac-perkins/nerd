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

use Nerd\Model\Training as TrainingModel;
use Psr\Http\Message\responseInterface as response;

use Psr\Http\Message\ServerrequestInterface as request;

class Training extends Controller
{
    public function item(request $request, response $response, string $id)
    {
        $trainingID = (int) $request->getParam('t');

        if ($request->isXhr()) {
            return $this->json($response, TrainingModel::item($trainingID));
        }
        
        return $this->view->render($response, 'Training/training.twig',
                  TrainingModel::show((int) $id, $trainingID));
    }

    public function upload(request $request, response $response, string $id)
    {
        TrainingModel::upload(
            $request->getUploadedFiles(),
            (int) $id,
            (int) $request->getParam('t')
        );

        $this->validator->addError('training', 'Training uploaded');

        $this->item($request, $response, $id);
    }

    public function download(request $request, response $response, string $id)
    {
        $training = TrainingModel::find($request->getParam('t'));

        if (!$training) {
            $this->validator->addError('training', 'Training not found');

            return $this->view->render($response, 'Jobs/log.twig', TrainingModel::show((int) $id));
        }

        $fh = \fopen($training->file, 'rb');

        $stream = new \Slim\Http\Stream($fh);

        return $response
            ->withHeader('Content-Type', 'application/force-download')
            ->withHeader('Content-Type', 'application/octet-stream')
            ->withHeader('Content-Type', 'application/download')
            ->withHeader('Content-Description', 'File Transfer')
            ->withHeader('Content-Transfer-Encoding', 'binary')
            ->withHeader('Content-Disposition', 'attachment; filename="' . \basename($training->file) . '.txt"')
            ->withHeader('Expires', '0')
            ->withHeader('Cache-Control', 'must-revalidate, post-check=0, pre-check=0')
            ->withHeader('Pragma', 'public')
            ->withBody($stream);
    }

    public function save(request $request, response $response, string $id)
    {
        $trainingID = (int) $request->getParam('t');

        return $this->json($response, TrainingModel::saveFile($trainingID, $request->getParam('content')));
    }

    public function fetch(request $request, response $response, string $id)
    {
        $post = $this->jsonrequest($request);

        return $this->json($response, TrainingModel::fetch((int) $id, $post['url']));
    }
    /*
    public function build(request $request, response $response, string $id)
    {
        return $this->json($response, TrainingModel::train($id));
    }
    */
    public function remove(request $request, response $response, string $id)
    {
        $trainingID = (int) $request->getParam('t');

        return $this->json($response, TrainingModel::remove($trainingID));
    }
}

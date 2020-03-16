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

use Nerd\Model\Result;
use Psr\Http\Message\responseInterface as Response;
use Psr\Http\Message\ServerrequestInterface as Request;

class Results extends Controller
{
    public function list(request $request, response $response, string $jobID)
    {
        return $this->view->render($response, 'Results/list.twig', Result::list($jobID, (int) $request->getParam('page')));
    }

    public function item(request $request, response $response, string $jobID)
    {
        return $this->json($response, Result::item($jobID, $request->getMethod(), $this->jsonrequest($request)));
    }

    public function filter(request $request, response $response, string $jobID)
    {
        return $this->json($response, Result::filter($jobID, $request->getBody()));
    }

    public function replace(request $request, response $response, string $jobID)
    {
        return $this->json($response, Result::replace($request, $jobID));
    }

    public function locate(request $request, response $response, string $jobID)
    {
        return $this->json($response, Result::locate($request->getMethod(), $jobID, $request->getParam('code')));
    }

  /*  public function map(request $request, response $response, string $jobID)
    {
        return $this->view->render($response, 'Result/map.twig');
    }

    public function markers(request $request, response $response, string $jobID)
    {
        return $this->export($request, $response, $jobID, false, 'Markers');
    }*/

    public function export(request $request, response $response, string $jobID, $zip = true, $flavour = null)
    {
        //export types
        $flavour = (isset($flavour)) ? $flavour : $request->getParam('f');

        //class
        $cls = 'Nerd\\Model\\Export\\' . $flavour;

        //export format
        $ef = new $cls($this->container);

        if (\class_exists($cls)) {

            if ($zip == true && $ef::IsZip) {

                $file = $ef->zip();

                $fh = \fopen($file, 'rb');

                $stream = new \Slim\Http\Stream($fh);

                return $response
                  ->withHeader('Content-Type', 'application/force-download')
                  ->withHeader('Content-Type', 'application/octet-stream')
                  ->withHeader('Content-Type', 'application/download')
                  ->withHeader('Content-Description', 'File Transfer')
                  ->withHeader('Content-Transfer-Encoding', 'binary')
                  ->withHeader('Content-Disposition', 'attachment; filename="' . \basename($file) . '"')
                  ->withHeader('Expires', '0')
                  ->withHeader('Cache-Control', 'must-revalidate, post-check=0, pre-check=0')
                  ->withHeader('Pragma', 'public')
                  ->withBody($stream);
            }

            $rv = $ef->export($jobID);

            if ($rv instanceof \DOMDocument) {
                return $this->xml($response, $rv);
            }

            return $this->write($response, $rv['msg']);
        }
    }
}

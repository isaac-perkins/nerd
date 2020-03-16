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

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

class Solr extends Controller
{
    /**
     * @return
     */
    public function list(Request $request, Response $response)
    {
        return $this->view->render($response, 'Solr/solr.twig');
    }

    public function getLog(Request $request, Response $response, string $file)
    {
        $pi = \pathinfo($file);

        $log = \realpath(__DIR__ . '/../../cache/import/log') . '/' . $pi['filename'] . '.log';

        return $this->view->render($response, 'Jobs/log.twig', [
            'log' => \file_get_contents($log),
        ]);
    }

    public function upload(Request $request, Response $response)
    {
        $settings = $this->settings();

        $colSettings = $settings['solr']['config']['import']['columns'];

        $files = $request->getUploadedFiles();

        if (empty($files['file'])) {
            throw new \Exception('No file to upload.');
        }

        $nf = $files['file'];

        if (!$nf->getError() === \UPLOAD_ERR_OK) {
            throw new \Exception('Upload error: ' . $nf->getError());
        }

        $file = \realpath(__DIR__ . '/../../cache/import') . '/' . $nf->getClientFilename();

        $nf->moveTo($file);

        if (($handle = \fopen($file, 'r')) !== false) {
          
            $headers = \fgetcsv($handle);

            if (!empty(\array_diff($headers, $colSettings))) {
                throw new \Exception('Import file must match criteria. See Column and Order section.');
            }

            $cmd = \realpath(__DIR__ . '/../../console/bin');

            $cmd .= '/solr -a import -f ' . $nf->getClientFilename();
            ///  echo $cmd;

            \exec($cmd . ' > /dev/null 2>&1 &', $out, $rv);
            //var_dump($out);
            $data = [
                'status' => 'success',
                'msg'    => 'System processing. See <a href="import/' . $nf->getClientFilename() . '/log">log</a> for progress updates.',
            ];
        } else {
            throw new \Exception('Can not read uploaded CSV.');
        }

        \fclose($handle);

        return $this->json($response, $data);
    }

    public function import(Request $request, Response $response)
    {
        return $this->view->render($response, 'Solr/import.twig');
    }
}

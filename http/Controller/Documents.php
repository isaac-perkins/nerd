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

use Nerd\Model\Document;

class Documents extends Controller
{
    public function item(Request $request, Response $response, string $jobID, string $documentID)
    {
        $jd = __DIR__ . '/../../data/' . $jobID;

        if(version_compare(PHP_VERSION, '7.2.0', '>=')) {
          error_reporting(E_ALL ^ E_NOTICE ^ E_WARNING);
        }

        $doc = Document::find($documentID);

        $rv = [
            'status' => 'success',
            'msg'    => 'Fetched document meta',
            'doc'    => [
                'id'   => $doc->id,
                'url'  => $doc->url,
                'meta' => $doc->meta,
            ],
        ];

        return $this->json($response, $rv);
    }
}

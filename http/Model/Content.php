<?php declare(strict_types=1);
/*
 * This file is part of Nerd (Named Entity Recognition Dashboard).
 *
 * (c) Boulevard Software (hello@blvd.ai)
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

namespace Nerd\Model;

use GuzzleHttp\Client;

class Content
{
    public static function getFilename(string $url) : string
    {
        return \preg_replace('/[^a-z0-9]+/', '-', \strtolower($url));
    }

    public static function getExtension(string $file) : string
    {
        return \substr(\basename($file), -3);
    }

    public static function getLabelCount(string $file) : Int
    {
        $f = \file_get_contents($file);

        return \substr_count($f, '<START:');
    }

    public static function sentences(string $fileIn) : array
    {
        $cmd = '$(readlink -f /usr/bin/java | sed "s:bin/java::")' .
        'bin/java -jar ' . \realpath(__DIR__ . '/../../console/nerd.jar') . ' ' .
        \realpath(__DIR__ . '/../../') . ' -tokens ' . $fileIn;

        \exec($cmd, $out, $rv);

        return [
            'status' => $rv,
            'output' => $out,
            'cmd'    => $cmd,
        ];
    }

    public static function fetch(string $url, string $file) : array
    {
        $client = new Client();

        $response = $client->request('GET', $url, [
            'sink'    => $file,
            'headers' => [
                'User-Agent'      => 'Nerd/v1.0',
                'Accept'          => 'text/html,application/xhtml+xml,application/pdf,application/xml;q=0.9,image/webp,image/apng',
                'Accept-Encoding' => 'gzip, deflate, br',
                'Accept-Language'	=> 'en-US,en;q=0.5',
            ], ]);

        return [
            'status' => $response->getStatusCode(),
            'msg'    => $response->getReasonPhrase(),
        ];
    }
}

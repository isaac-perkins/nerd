<?php
/*
 * This file is part of Nerd.
 *
 * (c) Boulevard Software (hello@blvd.ai)
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */
namespace Console\Model;

use GuzzleHttp\Cookie\CookieJar;

class Job
{
    private $dir;

    private $id;

    private $json = [];

    public function __construct(Int $jobID)
    {
        $this->id = $jobID;

        $this->dir  = \realpath(__DIR__ . '/../../data/' . $jobID);

        $this->getJob();
    }

    public function getContentDir()
    {
        return  $this->dir . '/content';
    }

    public function setStatus(String $status, Int $process)
    {
        //$this->json['status']['name'] = $status;
      //$this->json['status']['process'] = $process;

      //file_put_contents($this->dir . '/job.json', json_encode($this->json));
    }

    public function isMulti()
    {
        return ($this->json['multi'] == '1' || $this->json['multi'] == 'on') ? true : false;
    }

    public function getDir()
    {
        return $this->dir;
    }

    public function getJob()
    {
        $j = \file_get_contents($this->dir . '/job.json');

        $this->json = \json_decode($j, true);
    }

    public function getConfig()
    {
        return [
            'headers' => [
                'User-Agent'      => 'Nerd/v1.0',
                'Accept'          => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8',
                'Accept-Encoding' => 'gzip, deflate, br',
            ],
            'cookies' => $cookieJar
        ];
    }

    public function getCookies($url)
    {
        if ($url['cookies']) {
            $cookie = \explode('=', $url['cookies'][0]);
            $cookie = [
                $cookie[0] => $cookie[1],
            ];

            return CookieJar::fromArray($cookie, \parse_url($url['uri'], \PHP_URL_HOST));
        }

        return [];
    }

    public function getBase()
    {
        return $this->json['base']['urls'];
    }

    public function getTarget()
    {
        return $this->json['documents']['urls'];
    }

    public function getID()
    {
        return $this->id;
    }

    public function getUrl()
    {
        return $this->base['url'];
    }

    public function table()
    {
        return "tmp_$this->id";
    }
}

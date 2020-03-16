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

class Crawl
{
    public $job;

    public $log;

    public function __construct(Job $job, \Monolog\Logger $log)
    {
        $this->job = $job;
        $this->log = $log;
    }

    public function passes(array $bt, String $url): Bool
    {
        //echo PHP_EOL . $this->match($bt, $url);
        //echo PHP_EOL . $this->filters($bt, $url);
        if (\count($bt) == 0) {
            return true;
        }

        return $this->match($bt, $url) == true && $this->filters($bt, $url) == true;
    }

    public function match(array $bt, String $url): Bool
    {
        $rv = false;

        foreach ($bt as $u) {
            $uri = $u['uri'];

            if (\substr($url, 0, \strlen($uri)) == $uri) {
                return true;
            }
        }

        return $rv;
    }

    public function filters(array $bt, String $url): Bool
    {
        $rv = false;

        foreach ($bt as $u) {
            if (\count($u['filters']) == 0) {
                $rv = true;
            } else {
                $uri = $u['uri'];

                if (\substr($url, 0, \strlen($uri)) == $uri) {
                    foreach ($u['filters'] as $f) {
                        if ($f[0] == '!') {
                            if (\strpos($url, \ltrim($f, '!')) !== false) {
                                $rv = false;

                                break;
                            }
                            $rv = true;
                        } else {
                            if (\strpos($url, $f) !== false) {
                                $rv = true;
                            } else {
                                $rv = false;

                                break;
                            }
                        }
                    }
                }
            }

            if ($rv == true) {
                return $rv;
            }
        }

        return $rv;
    }
}

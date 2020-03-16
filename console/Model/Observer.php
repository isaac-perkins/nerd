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

use Nerd\Model\Content;
use Psr\Http\Message\UriInterface;
use Spatie\Crawler\CrawlObserver;

final class Observer extends Crawl implements CrawlObserver
{
    //content files index
    private $ci;

    //content xml
    private $cx;

    private $silent;

    public function __construct(Job $job, \Monolog\Logger $log, bool $silent = false)
    {
        //construct parent
        parent::__construct($job, $log);

        $content = $job->getContentDir();

        //index number of files in content directory
        $fi = new \FilesystemIterator($content, \FilesystemIterator::SKIP_DOTS);

        $this->ci = \iterator_count($fi);

        //create list xml
        $this->cx = $this->getContentList($content);

        $this->silent = $silent;
    }

    public function __destruct()
    {
        $ch = $this->cx->children();

        if (\count($ch) > 0) {
            $this->cx->asXml($this->job->getDir() . '/content/list.xml');
        } else {
            print \PHP_EOL . 'Error: No Links';
            $this->log->error('Error: No Links.');
        }
    }

    public function willCrawl(UriInterface $url)
    {

    }

    public function hasBeenCrawled(UriInterface $url, $response, UriInterface $foundOn = null)
    {
        if ($this->silent !== false) {
            print \PHP_EOL . 'Crawled: ' . (string) $url;
        }
        
        if ($this->passes($this->job->getTarget(), $url) == true && $this->isIndexed($url) == false) {

            $n = $this->getIndexNext();

            $url = (string) $url;

            $fn = Content::getFilename($url);

            Content::fetch($url, $this->job->getContentDir() . '/' . $fn, $n);

            $this->setIndexItem($n, $url, $fn);

            $this->log->info("Saved content for url: $url");

            if ($this->silent == false) {
                print \PHP_EOL . "Saved URL: $url";
            }

        } else {

            $this->log->info("Skip: $url");

            $n = 1;
        }

        return $n;
    }


    public function getContentList(String $contentDir)
    {
        $cl = $contentDir . '/list.xml';

        if (\file_exists($cl)) {
            $x = \simplexml_load_file($cl);
        } else {
            $x = \simplexml_load_string('<crawl/>');
        }

        return $x;
    }

    public function getIndexMax($dir)
    {
        $fi = new \FilesystemIterator($dir, \FilesystemIterator::SKIP_DOTS);

        return \iterator_count($fi);
    }

    public function setIndexItem($n, $url, $fileName)
    {
        $link = $this->cx->addChild('link');

        $link->addChild('index', $n);

        $un = $link->addChild('url');

        $domElement = \dom_import_simplexml($un);

        $domOwner = $domElement->ownerDocument;

        $domElement->appendChild($domOwner->createCDATASection("{$url}"));

        $f = $link->addChild('file');

        $domElement = \dom_import_simplexml($f);

        $domOwner = $domElement->ownerDocument;

        $domElement->appendChild($domOwner->createTextNode($fileName));
    }

    public function isIndexed($url)
    {
        $u = $this->cx->xpath('//link[url="' . $url . '"]');

        return (\count($u) > 0) ? true : false;
    }

    public function getIndexNext()
    {
        $this->ci = ($this->ci + 1);

        return $this->ci;
    }

    public function finishedCrawling()
    {
        print \PHP_EOL;
    }
}

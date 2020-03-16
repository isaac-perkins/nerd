<?php
/*
 * This file is part of Nerd.
 *
 * (c) Boulevard Software (hello@blvd.ai)
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */
require_once(__DIR__ . '/vendor/autoload.php');
use Psr\Http\Message\UriInterface;
use Spatie\Crawler\Crawler;
use Spatie\Crawler\CrawlObserver;

//echo file_get_contents('https://www.phila.gov/CityPlanning/meetingsandevents/pages/default.aspx');
//exit;

class CO implements CrawlObserver
{
    public function hasBeenCrawled(
        UriInterface $url,
        $response,
        ?UriInterface $foundOnUrl = null
    ) {
        print \PHP_EOL . 'hasBeenCrawled:' . $url;
        print \PHP_EOL . $response->getBody() . \PHP_EOL;
    }

    /**
     * Called when the crawler will crawl the url.
     */
    public function willCrawl(UriInterface $url)
    {
        print \PHP_EOL . 'WillCrawl:' . $url;
    }

    /**
     * Called when the crawler has crawled the given url successfully.
     *
     * @param \Psr\Http\Message\ResponseInterface $response
     */
    public function crawled(
        UriInterface $url,
        ResponseInterface $response,
        ?UriInterface $foundOnUrl = null
    ) {
        print \PHP_EOL . 'Crawled:' . $url;
    }

    /**
     * Called when the crawler had a problem crawling the given url.
     *
     * @param \GuzzleHttp\Exception\RequestException $requestException
     */
    public function crawlFailed(
        UriInterface $url,
        RequestException $requestException,
        ?UriInterface $foundOnUrl = null
    ) {
        print \PHP_EOL . 'Failed:' . $url;
    }

    /**
     * Called when the crawl has ended.
     */
    public function finishedCrawling()
    {
    }
}
$ob = new CO();

Crawler::create([
    'headers' => [
        'User-Agent'      => 'Name of your tool/v1.0',
        'Accept'          => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8',
        'Accept-Encoding' => 'gzip, deflate, br',
    ], ])
    ->setCrawlObserver($ob)
    ->startCrawling('https://www.phila.gov/CityPlanning/meetingsandevents/Pages/commissionmeetings.aspx');

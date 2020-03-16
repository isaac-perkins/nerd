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

use Psr\Http\Message\UriInterface;
use Spatie\Crawler\CrawlProfile as CrawlProfile;

final class Profile extends Crawl implements CrawlProfile
{
    public function shouldCrawl(UriInterface $url): Bool
    {
        return $this->passes($this->job->getBase(), (string) $url) || $this->passes($this->job->getTarget(), (string) $url);
    }
}

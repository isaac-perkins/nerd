# ![Logo](https://raw.githubusercontent.com/webanet-au/nerd/master/logo.png) Named Entity Recognition Dashboard
![!Scrutinizer](https://scrutinizer-ci.com/g/Webanet-Australia/nerd/badges/quality-score.png?b=master)
![Coverage](https://scrutinizer-ci.com/g/Webanet-Australia/nerd/badges/coverage.png?b=master)
![Build](https://scrutinizer-ci.com/g/Webanet-Australia/nerd/badges/build.png?b=master)
![License: MIT](https://img.shields.io/github/license/mashape/apistatus.svg)

The `NERD` dashboard is used for training [Apache OpenNLP](https://opennlp.apache.org/) models, crawling websites and processing results to turn web content into data for export to database or [Apache Solr](http://lucene.apache.org/solr/).

- Train models on sample documents and teach the system the data your interested in.
- Crawl websites and process results to database table.
- Filter and export to Apache Solr for easy searching.

![Screenshot](https://raw.githubusercontent.com/isaac-perkins/nerd/master/screenshot.jpg)

## Status / Support
Beta version and demo coming soon.
[Github Issues Tracking](https://github.com/isaac-perkins/nerd/issues) | [Trello](https://trello.com/b/UgDofsbl/nerd)

## Requirements
    - Apache (with mod_rewrite + mod_ssl)
    - Apache OpenNLP
    - Apache Solr
    - Oracle Java 8
    - PHP 7.2+ (php-curl php-xml php-mbstring php-pgsql php-tidy php-intl)
    - PostgreSQL
    - PHP Composer

## Setup
1. Clone repo
``` bash
$ git clone https://github.com/isaac-perkins/nerd
```
2. Set write permissions on /data and /cache directories
``` bash
$ chmod -R 755 data
$ chmod -R 755 cache
```
3. Create a new PostgreSQL database.
4. Import nerd database from script: /bootstrap/create.sql
``` bash
$ psql -U postgres nerd < bootstrap/database/create.sql
```
5. Create database details, copy /bootstrap/parameters.yml.dist to /bootstrap/parameters.yml
``` bash
$ cp bootstrap/parameters.yml.dist bootstrap/parameters.yml
```
6. Edit bootstrap/parameters.yml and add your database details.
7. Create default settings, copy /bootstrap/settings.yml.dist to /bootstrap/settings.php
8. Get dependencies - composer update.
``` bash
$ composer update
$ cd console
$ composer update
```
9. Add admin user.
``` bash
$ console/nerd user add
```
10. Start server
``` bash
$ cd public
$ php -S localhost:8000
```
11. Open dashboard in web browser: http://localhost:8000/

#### Apache OpenNLP
Apache OpenNLP core is still used for building models from the dashboard. All other OpenNLP functionality is performed using the compiled jar (console/nerd.jar) included in the repo.

1. Download latest [OpenNLP](https://opennlp.apache.org/download.html) version.
2. Move to directory accessible to nerd [bin/apache/opennlp]
3. Configure location in nerd bootstrap/settings.php
``` php
  'opennlp' => [
    'path' => __DIR__ . '/../bin/apache/opennlp/bin/',
  ],
```

#### Settings

Edit [settings](https://github.com/isaac-perkins/nerd/blob/master/wiki/en_US/1.Setup/1.Nerd.md) for full operation.

Settings [file](https://github.com/isaac-perkins/nerd/blob/master/bootstrap/settings.php.dist).


## Internationalization

Languages can be [added]('https://github.com/isaac-perkins/nerd/blob/master/wiki/en_US/1.Setup/1.Nerd.md').

## Contributing
Please! Contributions are very welcome. Submit pull request.


![Apache OpenNLP](https://cwiki.apache.org/confluence/download/thumbnails/74691846/opennlp-poweredby.png?version=1&modificationDate=1514406818000&api=v2)

# ![Logo](https://raw.githubusercontent.com/webanet-au/nerd/master/logo.png) Named Entity Recognition Dashboard
![!Scrutinizer](https://scrutinizer-ci.com/g/Webanet-Australia/nerd/badges/quality-score.png?b=master)
![Coverage](https://scrutinizer-ci.com/g/Webanet-Australia/nerd/badges/coverage.png?b=master)
![Build](https://scrutinizer-ci.com/g/Webanet-Australia/nerd/badges/build.png?b=master)
![License: MIT](https://img.shields.io/github/license/mashape/apistatus.svg)

The `NERD` dashboard is used for training [Apache OpenNLP](https://opennlp.apache.org/) models, crawling websites and processing results to turn web content into data for export to database or [Apache Solr](http://lucene.apache.org/solr/).

- Create a job, set data source.
- Train on sample documents, teach the system the data your interested in.
- Crawl and process results to database table.
- Filter and export to Apache Solr for easy searching.

![Screenshot](https://raw.githubusercontent.com/webanet-au/nerd/master/screenshot.jpg)

## Support
A beta version and demo coming soon.
[Github Issues Tracking](https://github.com/webanet-au/nerd/issues) | [Trello](https://trello.com/b/UgDofsbl/nerd) | [Email](zak@webanet.com.au)


## Requirements
    - Apache (with mod_rewrite + mod_ssl)
    - Apache OpenNLP
    - Apache Solr
    - Oracle Java 8
    - PHP 7.2+ (php-curl php-xml php-mbstring php-pgsql php-tidy php-intl)
    - PostgreSQL
    - PHP Composer

## Setup
Download the repo and start setup.
``` bash
git clone https://github.com/webanet-au/nerd
cd nerd
bin/setup
```

#### Create database

Add database credentials, login Postgres

``` bash
nano bootstrap/parameters.yml
psql -U postgres
```

Add new database

``` SQL
create database nerd;
````

Import nerd database, add admin user

``` bash
psql -U postgres nerd < bootstrap/database/create.sql
console/nerd user -a admin
```

#### Apache OpenNLP
OpenNLP core is still used by nerd for building models.


1. Download latest [OpenNLP](https://opennlp.apache.org/download.html) version.
2. Move to directory accessible to nerd [bin/apache/opennlp]
3. Configure location in nerd bootstrap/settings.php

``` bash
mkdir bin/apache
mv ~/Downloads/apache-opennlp-1.9.2 bin/apache/opennlp
chmod -R +x bin/apache/opennlp/bin/*
nano bootstrap/settings.php
```

``` php
  'opennlp' => [
    'path' => __DIR__ . '/../bin/apache/opennlp/bin/',
  ],
```

#### Settings

Edit (settings)[bootstrap/settings.php], required for full operation.

See [Wiki settings](https://github.com/webanet-au/nerd/blob/master/wiki/en_US/1.%20Setup/1.%20Nerd.md)


## Internationalization

Languages can be [added]('https://github.com/webanet-au/nerd/blob/master/wiki/en_US/1.%20Setup/1.%20Nerd.md').

## Contributing
Please! Contributions are very welcome. Submit pull request.


![Apache OpenNLP](https://cwiki.apache.org/confluence/download/thumbnails/74691846/opennlp-poweredby.png?version=1&modificationDate=1514406818000&api=v2)

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

use Monolog\Handler\StreamHandler;
use Monolog\Logger as Logger;
use Nerd\Model\Locate;

final class Solr
{
    private $log;

    private $settings;

    public function __construct(String $file, Bool $echo)
    {
        self::createLog($file);

        $this->file = $file;

        $this->echo = $echo;

        $settings = include(__DIR__ . '/../../bootstrap/settings.php');

        $this->settings = $settings['settings'];
    }

    public function validateDate($date)
    {
        $dt = \DateTime::createFromFormat('m/d/y', $date);

        $rv = ($dt !== false && !\array_sum($dt->getLastErrors()));

        if (!$rv) {
            $this->log->error('Skip row: Invalid date value: ' . $date);

            if ($this->echo == true) {
                print \PHP_EOL . 'Skip row: Invalid date value: ' . $date;
            }
        }

        return $rv;
    }

    public function validateYear($date)
    {
        $dtime = \DateTime::createFromFormat('m/d/y', $date);

        if ($dtime->format('Y') < 2017) {
            $this->log->error('Skip row. Old year:' . $dtime->format('Y'));

            if ($this->echo == true) {
                print \PHP_EOL . 'Skip row - Old year: ' . $dtime->format('Y');
            }

            return false;
        }

        return $dtime;
    }

    public function import()
    {
        $this->log->info('Started Solr import for file: ' . \basename($this->file));

        if ($this->echo == true) {
            print \PHP_EOL . 'Started Solr import for file: ' . \basename($this->file);
        }

        $locate = new Locate($this->settings['google']['maps']);

        $grp = 0;
        $n   = 0;
        $xml = '<add>';

        $dc = $this->getDocCount();

        if ($dc == false || \is_array($dc)) {
            $this->log->error('Terminal error: Could not get document count from solr server.');

            if ($this->echo == true) {
                print \PHP_EOL . 'Terminal error: Could not get document count from solr server.';
            }

            if (\is_array($dc)) {
                $this->log->error(\print_r($dc, true));
                \print_r($dc);
            }

            exit;
        }

        if (($handle = \fopen($this->file, 'r')) !== false) {
            $headers = \fgetcsv($handle);

            while (($data = \fgetcsv($handle, 0, ',')) !== false) {
                if (\strlen($data[1]) > 3) {
                    if (!$this->validateDate($data[8])) {
                        continue;
                    }

                    $dtime = $this->validateYear($data[8]);

                    if (!$dtime) {
                        continue;
                    }

                    $loc = $locate->getAddress($data[1] . ' ' . $data['6']);

                    if (!\array_key_exists('lat', $loc)) {
                        $this->log->error("Error getting lat/lng for row: $n. Status: " . $loc['status'] . ' ' . $loc['msg']);

                        if ($this->echo == true) {
                            print \PHP_EOL . "Error getting lat/lng for row: $n. Status: " . $loc['status'] . ' ' . $loc['msg'];
                        }

                        continue;
                    }

                    $grp++;
                    $n++;

                    $lat = $loc['lat'];
                    $lng = $loc['lng'];

                    $xml .= '
                      <doc>
                        <field name="id">' . ($n + $dc) . '</field>
                        <field name="source_id">' . $data[0] . '</field>
                        <field name="address"><![CDATA[ ' . $data[1] . ' ]]></field>
                        <field name="description"><![CDATA[ ' . \substr($data[9], 0, 254) . ' ]]></field>
                        <field name="outcome"><![CDATA[ ' . $data[5] . ' ]]></field>
                        <field name="permit"><![CDATA[ ' . $data[2] . ' ]]></field>
                        <field name="owner"><![CDATA[ ' . $data[3] . ' ]]></field>
                        <field name="city-status"><![CDATA[ ' . $data[4] . ' ]]></field>
                        <field name="document-city"><![CDATA[ ' . $data[6] . ']]></field>
                        <field name="document-source"><![CDATA[ ' . $data[7] . ']]></field>
                        <field name="document-date">' . $dtime->format('Y-m-d') . 'T08:00:00.000Z' . '</field>
                        <field name="lat">' . $lat . '</field>
                        <field name="lng">' . $lng . '</field>
                        <field name="latlong">' . $lat . ',' . $lng . '</field>
                      </doc>';

                    $this->log->info('Adding row ' . $n . '.' . $data[1]);

                    if ($this->echo == true) {
                        print \PHP_EOL . 'Adding row ' . $n . '.' . $data[1];
                    }

                    if ($grp == 10) {
                        $this->send($xml . '</add>', ($n / 10));
                        $xml = '<add>';
                        $grp = 0;
                    }
                }
            }
        } else {
            $error = 'Can not read uploaded CSV.';

            $this->log->error($error);

            if ($this->echo == true) {
                print \PHP_EOL . $error;
            }

            throw new \Exception($error);
        }

        //if there wasn't exactly 10 in last group...
        if ($xml !== '<add>') {
            $this->send($xml . '</add>', 'last');
        }

        $this->log->info($this->file . ' upload completed successfully!');

        if ($this->echo == true) {
            print \PHP_EOL . $this->file . ' upload completed successfully!';
        }
    }

    public function send($xml, $group)
    {
        $this->log->info('Sending data for group: ' . $group);

        if ($this->echo == true) {
            print \PHP_EOL . 'Sending data for group:' . $group;
        }

        $url = $this->settings['solr']['url'] . $this->settings['solr']['core'] . '/update?commit=true';

        if ($this->echo == true) {
            print \PHP_EOL . 'Sending URL:' . $url;
        }

        $client = $this->getClient();

        try {
            $rv = $client->request('POST', $url, [
                'headers' => [
                    'Content-Type' => 'text/xml',
                    'Accept'       => 'text/xml',
                ],
                'body' => \utf8_encode($xml),
            ]);
        } catch (\Exception $e) {
            if ($e->hasResponse()) {
                $exception = (string) $e->getResponse()->getBody(true);
                //$exception = json_decode($exception);
                $this->log->error($e->getCode() . ' : ' . $exception);

                if ($this->echo == true) {
                    print \PHP_EOL . 'Error:' . $e->getCode() . ' : ' . $exception;
                }
            } else {
                $this->log->error('503:' . $e->getMessage());

                if ($this->echo == true) {
                    print \PHP_EOL . 'Error:' . $e->getMessage();
                }
            }

            if ($this->echo == true) {
                print \PHP_EOL . 'Error sending XML:' . $xml;
            }

            return;
        }

        $dom = new \DOMDocument;
        $dom->loadXML($rv->getBody());
        $xpath = new \DOMXPath($dom);

        $val = $xpath->query('//int[@name="status"]')->item(0)->nodeValue;

        $this->log->info('Upload: ' . $rv->getReasonPhrase());

        if ($val !== '0') {
            $this->log->error($rv->getBody());
        }
    }

    public function getDocCount()
    {
        $url = $this->settings['solr']['url'] . $this->settings['solr']['core'] . '/select?q=*:*';

        $client = $this->getClient();

        try {
            $response = $client->request('GET', $url);
        } catch (\Exception $e) {
            return [
                'status' => 'error',
                'msg'    => 'Can not connect to Solr Server',
            ];
        }

        $response = \json_decode($response->getBody()->getContents(), true);
        //var_dump($response['response']);
        //exit;
        if (\is_array($response)) {
            return $response['response']['numFound'];
        }

        return false;
    }

    public function getClient()
    {
        $auth = [];

        if ($this->settings['solr']['usr']) {
            $auth = [
                'auth' => [
                    $this->settings['solr']['usr'],
                    $this->settings['solr']['pwd'],
                ],
            ];
        }

        return new \GuzzleHttp\Client($auth);
    }

    public function createLog($file)
    {
        $this->log = new Logger('Solr');

        $pi = \pathinfo($file);

        $log = \realpath(__DIR__ . '/../../cache/import/log') . '/' . $pi['filename'] . '.log';

        if (\file_exists($log)) {
            \unlink($log);
        }

        $this->log->pushHandler(new StreamHandler($log, Logger::DEBUG));
    }
}

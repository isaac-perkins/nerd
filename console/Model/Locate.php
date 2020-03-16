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

use Illuminate\Database\Capsule\Manager as DB;
use Illuminate\Database\Schema\Blueprint;

use Nerd\Model\Code;
use Nerd\Model\Locate as MainLocate;

final class Locate
{
    private $job;

    private $log;

    private $settings;

    public function __construct(Job $job, \Monolog\Logger $log)
    {
        $this->job = $job;
        $this->log = $log;

        $tbl = $job->table();

        if (!DB::Schema()->hasColumn($tbl, 'lat')) {

            $this->log->info("Creating Fields: $tbl.");

            DB::schema()->table($tbl, function (Blueprint $table) {
                $table->decimal('lat', 10, 7)->default(0);
                $table->decimal('lng', 10, 7)->default(0);
            });

            $this->log->info("Created table: $tbl.");

        } else {

            print \PHP_EOL;
            \PHP_EOL . 'columns exist';
        }

        $settings       = include(__DIR__ . '/../../bootstrap/settings.php');

        $this->settings = $settings['settings'];
    }

    //populate job result table with lat/lng's
    public function go(String $code)
    {
        $code = new Code($code);

        $recs = DB::select($code->select($this->job->getID()));

        $locate = new MainLocate($this->settings['google']['maps']);

        foreach ($recs as $rec) {

            $fa = '';

            foreach ($rec as $key => $value) {
                if ($key !== 'item_id') {
                    $fa .= $value . ' ';
                }
            }

            print \PHP_EOL . 'Geo address: ' . $fa;

            $fa = \preg_replace('/\s+/', ' ', \str_replace(',', ' ', $fa));

            $this->log->info('Geo address: ' . $fa);

            if (\strlen($fa) > 8) {

                $loc = $locate->getAddress($fa);

                if (isset($loc['status'])) {

                    echo PHP_EOL . $loc['status'];

                    $this->log->info('Not Found: ' . $loc['status']);

                    continue;

                }

                if(isset($loc['lat']) && isset($loc['lng'])) {

                   $sql = $code->update($loc, $rec->item_id);

                   $upd = DB::statement($sql);

                }

            } else {

                print \PHP_EOL . 'Not enough data to get address: ' . $fa . \PHP_EOL;

                $this->log->info('Not enough data to get address: ' . $fa);

            }
        }
    }
}

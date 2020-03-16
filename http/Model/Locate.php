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

use Alexpechkarev\GoogleGeocoder\GoogleGeocoder;

class Locate
{
    public $mapsSettings = [];

    public function __construct(array $mapsSettings)
    {
        $this->mapsSettings = $mapsSettings;
    }

    public function getAddress(string $address) : array
    {
        $gc = new GoogleGeocoder([
            'applicationKey' => $this->mapsSettings['ip_restricted'],
            'requestUrl'     => $this->mapsSettings['requestUrl'],
        ]);

        $location = $gc->geocode('json', [
            'address' => $address,
        ]);

        $loc = \json_decode($location, true);

        if ($loc) {

          if (isset($loc['results'][0])) {

              $rv = $loc['results'][0];

              $lat = $rv['geometry']['location']['lat'];
              $lng = $rv['geometry']['location']['lng'];

              return [
                  'lat' => $lat,
                  'lng' => $lng,
              ];

          }
        }
  
        return [
            'status' => $loc['status'],
            'msg'    => $loc,
        ];


    }
}

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

use Illuminate\Filesystem\Filesystem;
use Illuminate\Translation\FileLoader;
use Illuminate\Translation\Translator;

class Message
{
    public static function translate($msg) : string
    {
        $trans = self::getTranslator();

        return $trans->get($msg);
    }

    public static function format(int $code, string $message, array $meta = []) : array
    {
        $trans = self::getTranslator();

        return \array_merge([
            'code'        => $code,
            'status'      => ($code == 200) ? $trans->get('json.+1') : $trans->get('json.-1'),
            'msg'         => $trans->get('json.' . $message),
        ], $meta);
    }

    public function getTranslator()
    {
        $loader = new FileLoader(new Filesystem(), __DIR__ . '/../Resources/lang');

        //$settings = $container->get('settings');

        return new Translator($loader, 'en_US');
    }
}

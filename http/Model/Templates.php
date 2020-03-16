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

class Templates
{
    public static function list()
    {
        return [
            'templates' => [
                1 => [
                    'name'  => 'invite',
                    'title' => 'Invite',
                ],
            ],
        ];
    }

    public static function item(string $name) : array
    {
        $templates = self::list()['templates'];

        foreach ($templates as $template) {
            if ($template['name'] == $name) {
                return $template;
            }
        }
    }

    public static function getPath(string $name, string $locale) : string
    {
        return __DIR__ . "/../Resources/views/Emails/$locale/$name.twig";
    }

    public static function edit(string $name, string $content, string $locale) : array
    {
        try {
            \file_put_contents(self::getPath($name, $locale), $content);

            $rv  = [
                'status' => 'success',
                'msg'    => 'Template saved',
            ];
        } catch (\Exception $e) {
            $rv  = [
                'status'    => 'danger',
                'msg'       => 'Could not save template file',
                'exception' => $e->getMessage(),
            ];
        }

        return $rv;
    }
}

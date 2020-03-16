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

use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Model;

class Annotation extends Model
{
    public $timestamps = false;

    protected $table = 'annotations';

    protected $fillable = [
        'name',
        'title',
        'multi',
        'data_type',
        'order'
    ];

    public static function list()
    {
        return self::orderBy('order', 'ASC')->get();
    }

    public static function new(string $title, int $multi, int $type, int $order) : array
    {
        try {
            $annot        = new self;
            $annot->name  = \strtolower(\str_replace(' ', '_', \trim($title)));
            $annot->title = $title;
            $annot->multi = $multi;
            $annot->type = $type;
            $annot->order = $order;
            
            $annot->save();

            $rv = Message::format(200, 'annotation_added', [
                'annotation' => $annot->toArray()
            ]);
        } catch (\Exception $e) {
            $rv = Message::format(500, 'annotation_add_error', ['exception' => $e->getMessage()]);
        }

        return $rv;
    }

    public static function remove(int $id) : array
    {
        try {
            self::destroy($id);

            $rv = Message::format(200, 'annotation_del');

        } catch (\Exception $e) {

            $rv = Message::format(500, 'annotation_del_error', ['exception' => $e->getMessage()]);
        }

        return $rv;
    }

    //Count annotations
    public static function totals(Collection $training) : array
    {
        $rv = [];

        foreach ($training as $item) {

            $dom = Training::getXML($item->file);

            foreach ($dom->getElementsByTagName('entity') as $entity) {
                $type = $entity->getAttribute('type');

                if (!\array_key_exists($type, $rv)) {
                    $rv[$type] = [];
                }

                if (!\in_array($entity->nodeValue, $rv[$type])) {
                    $rv[$type][] = $entity->nodeValue;
                }
            }
        }

        return $rv;
    }
}

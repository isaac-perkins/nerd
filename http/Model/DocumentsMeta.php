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

class DocumentsMeta extends Model
{
    protected $table = 'documents_meta';

    protected $fillable = [
        'document_id',
        'name',
        'value',
        'value_number',
        'value_date'
    ];

    public $timestamps = false;
}

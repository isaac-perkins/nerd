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

use Illuminate\Database\Eloquent\Model;

class Document extends Model
{
    protected $table = 'documents';

    protected $primaryKey = 'id';

    protected $fillable;

    public static function clear($id)
    {
        return self::where('job_id', '=', $id)->delete();
    }

    public function meta()
    {
        return  $this->hasMany('Nerd\Model\DocumentsMeta', 'document_id');
    }
}

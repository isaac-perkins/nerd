<?php
/*
 * This file is part of Nerd (Named Entity Recognition Dashboard).
 *
 * (c) Boulevard Software (hello@blvd.ai)
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */
namespace Nerd\Model\Export;

use Illuminate\Database\Capsule\Manager as DB;
use Interop\Container\ContainerInterface;

class CSV extends Export
{
    public function __construct(ContainerInterface $container)
    {
        parent::__construct($container);
    }

    public function export(int $jobID, bool $remove = false) : array
    {
        return [
            'status' => 200,
            'msg'    => 'export',
        ];
    }
}

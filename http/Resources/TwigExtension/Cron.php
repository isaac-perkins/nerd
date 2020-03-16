<?php
/*
 * This file is part of Nerd (Named Entity Recognition Dashboard).
 *
 * (c) Boulevard Software (hello@blvd.ai)
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */
namespace Nerd\Resources\TwigExtension;

use Cron\CronExpression;
use Twig\Extension\AbstractExtension;
use Twig\TwigFilter;

class Cron extends AbstractExtension
{
    private $cron;

    public function getFilters()
    {
        return [
            new TwigFilter('cronNext', [$this, 'cronNext']),
        ];
    }

    public function cronNext($cron)
    {
        $rv = null;

        if ($cron) {
            try {
                $cron = CronExpression::factory($cron);

                $rv = $cron->getNextRunDate()->format('d M H:i');
            } catch (\Exception $e) {
                $rv = 'Invalid expression';
            }
        }

        return $rv;
    }
}

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

use Nerd\Model\CommandType;
use Twig\Extension\AbstractExtension;
use Twig\TwigFilter;

class Commands extends AbstractExtension
{
    private $cron;

    public function getFilters(): array
    {
        return [
            new TwigFilter('commandsText', [$this, 'commandsText']),
        ];
    }

    public function commandsText(string $command): string
    {
        $rv = null;

        if ($command) {
            try {
                $rv = CommandType::search($command);
            } catch (\Exception $e) {
                $rv = 'Invalid command index: ' . $command;
            }
        }

        return $rv;
    }
}

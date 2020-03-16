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

use Illuminate\Database\Capsule\Manager;
use Symfony\Component\Yaml\Yaml;

class Process
{
    private $manager;

    public function __construct(Job $job)
    {
        $parameters = Yaml::parse(\file_get_contents($job->getDir() . '/parameters.yaml'))['parameters'];

        $manager = new Manager();
        $manager->addConnection($parameters);
        $manager->setAsGlobal();
        $manager->bootEloquent();

        $this->$manager = $manager;
        $this->job      = $job;
    }

    public function start(Int $task)
    {
        return $task;
    }
}

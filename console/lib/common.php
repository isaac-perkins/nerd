<?php
/*
 * This file is part of Nerd.
 *
 * (c) Boulevard Software (hello@blvd.ai)
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */
namespace Console;

use Commando\Command as Command;
use Illuminate\Database\Capsule\Manager;
use Monolog\Handler\StreamHandler;
use Monolog\Logger as Logger;
use Nerd\Model\Command as NerdCommand;
use Symfony\Component\Yaml\Yaml;

use Console\Model\Job;

$cmd = new Command();

$cmd->option('v')
->aka('verbose')
->describedAs('Echo process messages to shell window.')
->require(false)
->default(false)
->boolean();

$cmd->option('j')
->aka('job')
->describedAs('Job ID')
->require(true)
->must(function ($jobID) {
    return \is_numeric($jobID);
});

if (isset($addressCode)) {
    $cmd->option('c')
    ->aka('code')
    ->describedAs('Formular for selecting address')
    ->require(true);
}

$job = new Job($cmd['job']);

$jobDir = $job->getDir();
$jobID  = $job->getID();

$parameters = Yaml::parse(\file_get_contents($jobDir . '/parameters.yaml'))['parameters'];

$capsule = new Manager();
$capsule->addConnection($parameters);
$capsule->setAsGlobal();
$capsule->bootEloquent();

$settings = include(__DIR__ . '/../../bootstrap/settings.php');
$settings = $settings['settings'];

$echo = false;

if (!$cmd['verbose']) {
    $echo = true;
}

function log_job_start(String $action, String $jobID, String $jobDir, Bool $echo)
{
    if ($echo == true) {
        print "Starting job $action: $jobID";
    }

    $log = new_log($action, $jobDir . "/$action.log");

    $log->info('Created log file: ' . $jobDir . "/$action.log");

    if ($echo == true) {
        print \PHP_EOL . 'Created log file: ' . $jobDir . "/$action.log";
    }

    return $log;
}

function log_job_end($log, String $action, String $jobID, Bool $echo)
{
    //NerdCommand::stop($jobID);

    if ($echo == true) {
        print \PHP_EOL . "Finished $action job: " . $jobID . \PHP_EOL;
    }
    $log->info("Finished $action. job: " . $jobID);
}

function new_log($name, $path)
{
    $log = new Logger($name);

    if (\file_exists($path)) {
        \unlink($path);
    }
    $log->pushHandler(new StreamHandler($path, Logger::DEBUG));

    return $log;
}

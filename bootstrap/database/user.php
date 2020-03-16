<?php
use Illuminate\Database\Capsule\Manager as DB;
use Illuminate\Database\Schema\Blueprint;
use Cartalyst\Sentinel\Native\Facades\Sentinel;
use Cartalyst\Sentinel\Native\SentinelBootstrapper;
use Commando\Command;

//$sentinel = (new Sentinel(new SentinelBootstrapper(__DIR__ . '/../sentinel.php')))->getSentinel();


if ($cmd['add']) {
  echo "\n" . "Adding User: " . $cmd['add'] , "\n";
}

echo "Create User";

function createGroups()
{
    $sentinel->getRoleRepository()->createModel()->create(array(
        'name' => 'Admin',
        'slug' => 'admin',
        'permissions' => array(
            'users.create' => true,
            'users.update' => true,
            'users.delete' => true
        )
    ));

    $sentinel->getRoleRepository()->createModel()->create(array(
        'name' => 'User',
        'slug' => 'user',
        'permissions' => array(
            'users.update' => true
        )
    ));
}

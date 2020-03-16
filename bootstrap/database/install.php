<?php
/*TODO Update to current db
use Symfony\Component\Yaml\Yaml;

$create = __DIR__ . '/create.sql';

if(!file_exists($create)) {
  echo PHP_EOL . 'Error. Create script file not found.' . PHP_EOL;
}

$parameters = Yaml::parse(\file_get_contents(__DIR__ . '/../parameters.yml'))['parameters'];

$db = new \PDO($parameters['driver'] . ':' .'host=' . $parameters['host'], $parameters['username'], $parameters['password']);

$db->exec('CREATE DATABASE ' . $parameters['database']);

$db = new \PDO($parameters['driver'] . ':' .'host=' . $parameters['host'] . ';dbname=' . $parameters['database'], $parameters['username'], $parameters['password']);

$db->exec(file_get_contents($create));


use Illuminate\Database\Capsule\Manager as DB;
use Illuminate\Database\Schema\Blueprint;

AUTH.php
use Illuminate\Database\Capsule\Manager as DB;
use Illuminate\Database\Schema\Blueprint;
//use Cartalyst\Sentinel\Native\Facades\Sentinel;
//use Cartalyst\Sentinel\Native\SentinelBootstrapper;

//$sentinel = (new Sentinel(new SentinelBootstrapper(__DIR__ . '/../sentinel.php')))->getSentinel();

DB::schema()->create('users', function (Blueprint $table) {
    $table->increments('id');
    $table->string('username')->unique();
    $table->string('email')->unique();
    $table->string('password');
    $table->string('last_name')->nullable();
    $table->string('first_name')->nullable();
    $table->timestamp('last_login')->nullable();
    $table->timestamps();
});

DB::schema()->create('activations', function (Blueprint $table) {
    $table->increments('id');
    $table->unsignedInteger('user_id');
    $table->string('code');
    $table->boolean('completed')->default(0);
    $table->timestamp('completed_at')->nullable();
    $table->timestamps();
    $table->foreign('user_id')->references('id')->on('users');
});

DB::schema()->create('persistences', function (Blueprint $table) {
    $table->increments('id');
    $table->unsignedInteger('user_id');
    $table->string('code')->unique();
    $table->timestamps();
    $table->foreign('user_id')->references('id')->on('users');
});



DB::schema()->create('throttle', function (Blueprint $table) {
    $table->increments('id');
    $table->integer('user_id')->unsigned()->nullable();
    $table->string('type');
    $table->string('ip')->nullable();
    $table->timestamps();
    $table->foreign('user_id')->references('id')->on('users');
});


DB::schema()->create('roles', function (Blueprint $table) {
    $table->increments('id');
    $table->string('slug')->unique();
    $table->string('name');
    $table->text('permissions');
    $table->timestamps();
});

DB::schema()->create('role_users', function (Blueprint $table) {
    $table->unsignedInteger('user_id');
    $table->unsignedInteger('role_id');
    $table->timestamps();
    $table->primary(['user_id', 'role_id']);
    $table->foreign('user_id')->references('id')->on('users');
    $table->foreign('role_id')->references('id')->on('roles');
});
/*
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

//NERD

DB::schema()->create('jobs', function (Blueprint $table) {
    $table->increments('id');
    $table->unsignedInteger('owner_id');
    $table->unsignedInteger('type_id')->default(1);
    $table->string('title');
    $table->string('description')->nullable();
    $table->timestamp('started')->nullable();
    $table->timestamp('ended')->nullable();
    $table->string('url')->nullable();
    $table->boolean('follow')->default(0);
    $table->text('locate')->nullable();
    $table->string('cron')->nullable();
    $table->boolean('visibility')->nullable()->default(TRUE);
    $table->unsignedInteger('status')->nullable();
    $table->timestamps();
    $table->foreign('owner_id')->references('id')->on('users');
});

DB::schema()->create('links', function (Blueprint $table) {
    $table->increments('id');
    $table->unsignedInteger('job_id');
    $table->string('url');
    $table->string('file');
    $table->integer('labels')->unsigned()->default(0);
    $table->timestamp('updated_at')->nullable();
    $table->foreign('job_id')->references('id')->on('jobs')->onDelete('cascade');
});

DB::schema()->create('targets', function (Blueprint $table) {
    $table->bigIncrements('id');
    $table->smallInteger('code_index');
    $table->string('title');
    $table->integer('count')->unsigned()->default(1);
});

DB::schema()->create('documents', function (Blueprint $table) {
    $table->increments('id');
    $table->unsignedInteger('job_id');
    $table->string('url');
    $table->timestamp('created_at')->default(DB::raw('CURRENT_TIMESTAMP'));
    $table->foreign('job_id')->references('id')->on('jobs');
});

DB::schema()->create('documents_meta', function (Blueprint $table) {
    $table->increments('id');
    $table->unsignedInteger('document_id');
    $table->string('name');
    $table->string('value');
    $table->foreign('document_id')->references('id')->on('documents')->onDelete('cascade');;
});

DB::Schema()->create('commands', function (Blueprint $table) {
    $table->increments('id');
    $table->integer('user_id')->unsigned();
    $table->integer('job_id')->unsigned();
    $table->integer('process_id')->unsigned();
    $table->integer('command_type')->unsigned();
    $table->text('command');
    $table->text('output');
    $table->timestamp('created_at')->default(DB::raw('NOW()'));
    $table->timestamp('completed_at')->nullable();
    $table->foreign('user_id')
            ->references('id')
            ->on('users')
            ->onDelete('cascade')
            ->onUpdate('cascade');
    $table->foreign('job_id')
            ->references('id')
            ->on('jobs')
            ->onDelete('cascade')
            ->onUpdate('cascade');
});

echo PHP_EOL . "Database Created" . PHP_EOL;
*/

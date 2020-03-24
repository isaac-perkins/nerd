#!/bin/bash

setup_msys () {
  echo "No script for Windows yet unfortunatly, please follow ReadMe.md file to setup your Windows machine."
  exit 1
}

setup_win32 () {
  setup_msys
}

setup_cygwin () {
  setup_linux-gnu
}

setup_darwin () {
  echo "Warning! untested setup."
  setup_linux-gnu
}

setup_freebad () {
  echo "Warning! untested setup."
  setup_linux_gnu
}

setup_linux_gnu () {

    #composer update
    #cd console
    #composer update
    #cd ..
    chmod -R 755 *
    chmod -R 775 ./cache
    chmod -R 775 ./data
    chmod -R +x ./console/bin/*
    chmod -R +x ./console/nerd
    chmod -R 775 ./http/Resources/views/Emails

    echo "finished linux setup"
}

create_yaml () {
  #Ask user db dets
  read -p 'Postgres host name[localhost]: ' pg_host
  read -p 'Database name [nerd]: ' pg_db
  read -p 'Postgres user name (requires permission to create databases) [postgres]: ' pg_user
  read -sp 'Postgres Password[Z1ggy1]: ' pg_pwd

  #write out database yml file: ./bootstrap/parameters.yml
  {
      echo "parameters:"
      echo "  driver: pgsql"
      echo "  host: $pg_host"
      echo "  database: $pg_db"
      echo "  username: $pg_user"
      echo "  password: $pg_pwd"
      echo "  charset: utf8"
      echo "  collation: utf8_general_ci"
  } > ./bootstrap/parameters.yml
}

create_setting () {

  cp ./bootstrap/settings.php.dist ./bootstrap/settings.php

}

create_user () {

  # Ask user for database details
  echo "Nerd admin user"
  read -p 'Nerd admin user name[admin]: ' user_name
  read -p 'Nerd admin email[admin.local]: ' user_email
  read -sp 'Nerd admin password[password]: ' user_pwd

}

echo "Starting nerd setup"

#OS Type - Replace - with _
setup_os=${OSTYPE//[-]/_}

#Formulate setup function name for os type
setup_os="setup_$setup_os"

#If function exists
if type $setup_os | grep -i function > /dev/null; then

    #create database yml: bootstrap/parameters.yml
    create_yaml

    #create settings: bootstrap/settings.php
    create_settings

    #Call setup function for this os
    $setup_os

    #create admin user
    create_user $user_name $user_email $user_pwd

fi

echo "Complete"

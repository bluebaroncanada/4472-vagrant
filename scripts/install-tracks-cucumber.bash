#!/bin/bash

mysql -u root -ppassword -e 'create database tracks_test'

sed -i '/test:.*/a \ \ password: password' /var/www/tracks/config/database.yml
sed -i '/group \:test do/a \ \ gem "cucumber-rails", \:require => false' /var/www/tracks/Gemfile

cd /var/www/tracks
bundle install --with test --without sqlite
bundle exec rake db:migrate RAILS_ENV=test
bundle exec rake assets:precompile RAILS_ENV=test


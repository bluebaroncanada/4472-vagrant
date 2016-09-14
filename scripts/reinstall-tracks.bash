#!/bin/bash

cd /var/www/tracks
rm -rf *
echo Cloning tracks ...
git clone -q https://github.com/TracksApp/tracks.git /var/www/tracks


cp /var/www/tracks/config/site.yml.tmpl /var/www/tracks/config/site.yml
cp /var/www/tracks/config/database.yml.tmpl /var/www/tracks/config/database.yml
sed --in-place 's/  password.*/  password: password/' /var/www/tracks/config/database.yml
sed --in-place 's/time_zone.*/time_zone\: \"Eastern Time \(US \& Canada\)\"/' /var/www/tracks/config/site.yml
sed --in-place 's/secret_token.*/secret_token\: \"itsasecret\"/' /var/www/tracks/config/site.yml
sed --in-place 's/# serve_static_assets.*/serve_static_assets: true/' config/site.yml

bundle install --without development test sqlite
bundle exec rake db:migrate RAILS_ENV=production

bundle exec rake assets:precompile RAILS_ENV=production

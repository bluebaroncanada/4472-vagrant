#!/bin/bash

sudo -s

#Makes it so you don't have to type in your password when running sudo
sed --in-place 's/%sudo.*/%sudo ALL=(ALL:ALL) NOPASSWD:ALL/' /etc/sudoers
timedatectl set-timezone EST5EDT

apt-add-repository -y ppa:brightbox/ruby-ng

apt-get update

#Installs mysql-server with the password set to "password"
debconf-set-selections <<< 'mysql-server mysql-server/root_password password password'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password password'
apt-get -y install mysql-server

apt-get -y install git
apt-get -y install build-essential
apt-get -y install libmysqlclient-dev

su vagrant

cd ~
wget -O ruby-install-0.6.0.tar.gz https://github.com/postmodern/ruby-install/archive/v0.6.0.tar.gz
tar -xzvf ruby-install-0.6.0.tar.gz
cd ruby-install-0.6.0/
make install

#This takes a long time
ruby-install --system ruby 2.3.1 -- --disable-install-doc

cd ~
wget -O chruby-0.3.9.tar.gz https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz
tar -xzvf chruby-0.3.9.tar.gz
cd chruby-0.3.9/
make install


echo source /usr/local/share/chruby/chruby.sh >> /home/vagrant/.bashrc
echo source /usr/local/share/chruby/auto.sh >> /home/vagrant/.bashrc

chmod a+xr /usr/local/share/chruby/chruby.sh
chmod a+xr /usr/local/share/chruby/auto.sh

gem install rails -v 4.2.5 --no-rdoc --no-ri

gem install bundler

mysql -u root -ppassword -e 'CREATE DATABASE tracks;'

gem install RedCloth -v '4.2.9'
gem install nokogiri -v '1.6.7.2'

mkdir -p /var/www/tracks
chown vagrant:vagrant /var/www/tracks
chown root:vagrant /var/www
chmod 770 /var/www/tracks
chmod 770 /var/www

cd /var/www/tracks
echo Cloning tracks ...
git --quiet clone https://github.com/TracksApp/tracks.git /var/www/tracks





cp /var/www/tracks/config/site.yml.tmpl /var/www/tracks/config/site.yml
cp /var/www/tracks/config/database.yml.tmpl /var/www/tracks/config/database.yml
sed --in-place 's/  password.*/  password: password/' /var/www/tracks/config/database.yml
sed --in-place 's/time_zone.*/time_zone\: \"Eastern Time \(US \& Canada\)\"/' /var/www/tracks/config/site.yml
sed --in-place 's/secret_token.*/secret_token\: \"itsasecret\"/' /var/www/tracks/config/site.yml

bundle install --without development test sqlite
bundle exec rake db:migrate RAILS_ENV=production

bundle exec rake assets:precompile RAILS_ENV=production



exit 0

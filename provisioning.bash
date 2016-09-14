#!/bin/bash

ssh_public_key="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDDZC0wINCffUgIYbD7RznR1dMV4bTbkzW5JWp7bsTNWZNTUGiXt9nKl7Q+fE8ChpnqsLfQg4NtzxkMxFEOZI3qa/6dLlqlIq5UwdB/lF0YO7FMgn5sfJs2+/pvs2Ytx6niH4coLB8NZW5SiV9MWj3ECOOVWTtVyrU37/ANzCr+i+tU8g7H2+DxADXUcYWxwbv2tL1TF89BEaRaVQlz1oJNi54i+E/aggyw65WfoVDWQEXWO+SjiTm9Ide1RxHE0pDUKLoxTvsUZpR2PWRq0LCrzljfzfYl3RloCIelwy+pFgO8KlDgPvgnJs8iP6wmsMw5RyF5y3fhYWdET/h377jl"

if [ -n "$ssh_public_key" ]; then
	cat >> /home/vagrant/.ssh/authorized_keys2 << EOF
	$ssh_public_key
EOF
	 
	chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys2
	chmod 700 /home/vagrant/.ssh/authorized_keys2
fi

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

mkdir -p /var/www/tracks
chown vagrant:vagrant /var/www/tracks
chown root:vagrant /var/www
chmod 770 /var/www/tracks
chmod 770 /var/www

exec sudo -i -u vagrant /bin/bash - << EOF


cd ~
git clone -q https://github.com/bluebaroncanada/4472-vagrant.git

cd ~/4472-vagrant/scripts
chmod +x *.bash
~/4472-vagrant/scripts/updates.bash


cd ~
wget -O ruby-install-0.6.0.tar.gz https://github.com/postmodern/ruby-install/archive/v0.6.0.tar.gz
tar -xzvf ruby-install-0.6.0.tar.gz
cd ruby-install-0.6.0/
sudo make install

#This takes a long time
sudo ruby-install ruby 2.3.1 -- --disable-install-doc

cd ~
wget -O chruby-0.3.9.tar.gz https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz
tar -xzvf chruby-0.3.9.tar.gz
cd chruby-0.3.9/
sudo make install


echo source /usr/local/share/chruby/chruby.sh >> /home/vagrant/.bashrc
echo source /usr/local/share/chruby/auto.sh >> /home/vagrant/.bashrc
echo chruby 2.3.1 >> /home/vagrant/.bashrc

sudo chmod a+xr /usr/local/share/chruby/chruby.sh
sudo chmod a+xr /usr/local/share/chruby/auto.sh

source /usr/local/share/chruby/chruby.sh
source /usr/local/share/chruby/auto.sh

chruby 2.3.1

gem install rails -v 4.2.5 --no-rdoc --no-ri

gem install bundler

mysql -u root -ppassword -e 'CREATE DATABASE tracks;'

gem install RedCloth -v '4.2.9'
gem install nokogiri -v '1.6.7.2'

cd /var/www/tracks
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


EOF


exit 0

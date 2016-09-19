#!/bin/bash

cd /var/www/tracks
bundle exec rails server -b 192.168.34.10 -e production

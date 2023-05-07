#!/usr/bin/env bash
# sets up the web servers for the deployment of web_static

# update the package lists
sudo apt-get -y update

# install nginx
sudo apt-get -y install nginx

# make directories for the deployment using -p to create all parent directories if not existing
sudo mkdir -p /data/web_static/releases/test 
sudo mkdir -p /data/web_static/shared

# give ownership of the /data/ directory to the ubuntu user 
sudo chown -R ubuntu /data/

# give group ownership of the /data/ directory to the ubuntu user
sudo chgrp -R ubuntu /data/

# create a test HTML file
echo "HBNB Static Testing" > /data/web_static/releases/test/index.html

# create a symbolic link to the test HTML file
#---'ln -s' creates a symbolic link
#---'f' forces the symbolic link to be created if the target already exists, hence overwriting whenever target file is updated
sudo ln -sf /data/web_static/releases/test/ /data/web_static/current

printf %s "server {
    listen 80 default_server;
    listen [::]:80 default_server;
    add_header X-Served-By $HOSTNAME;
    root   /var/www/html;
    index  index.html index.htm index.nginx-debian.html;

    location /hbnb_static {
        alias /data/web_static/current;
        index index.html index.htm index.nginx-debian.html;
    }

    location /redirect_me {
        return 301 https://twitter.com/ai_optimizer;
    }

    error_page 404 /error_404.html;
    location /404 {
      root /var/www/html;
      internal;
    }
}" > /etc/nginx/sites-available/default

sudo service nginx restart

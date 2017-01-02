# vmin-nginx

Fronting Virtualmin's Apache with Nginx automatically.

Steps involved:
- Set Apache to listen on ports 1080 for HTTP and 1443 for HTTPS
- Install Nginx and set it to include .conf files from /etc/nginx/vhosts/*.conf (and create that dir)
- Set Virtualmin to run this script as Pre/Post command: /usr/local/bin/vmin-nginx.sh
- Download the script:

`wget https://raw.githubusercontent.com/NuxRo/vmin-nginx/master/vmin-nginx.sh -O /usr/local/bin/vmin-nginx.sh
chmod +x /usr/local/bin/vmin-nginx.sh`

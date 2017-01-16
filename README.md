# vmin-nginx

Fronting Virtualmin's Apache with Nginx automatically.

HOW TO (tested on CentOS 7)

- Install Virtualmin as usual
- Tell Virtualmin to use Apache ports 1080 for HTTP and 1443 for HTTPS in vhosts, do this from Virtualmin > System Settings > Server Templates > Apache Website > Port number for virtual and SSL hosts.
![Screenshot2] (http://img.nux.ro/3Tq-Selection_189.png)

- You may need to edit your existing configuration and change the port accordingly

`sed -i.bak80 s/:80/:1080/g /etc/httpd/conf/httpd.conf`

`sed -i.bak443 s/:443/:1443/g /etc/httpd/conf/httpd.conf /etc/httpd/conf.d/ssl.conf`

`service httpd restart`

- Install Nginx and set it to include .conf files from /etc/nginx/vhosts/*.conf (and create that dir)
`mkdir /etc/nginx/vhosts
echo "include /etc/nginx/vhosts/*.conf;" > /etc/nginx/default.d/vmin-nginx.conf
service nginx start
systemctl enable nginx`


- Set Virtualmin to run this script as Pre/Post command: /usr/local/bin/vmin-nginx.sh


- Download the script and make it executable:

`wget https://raw.githubusercontent.com/NuxRo/vmin-nginx/master/vmin-nginx.sh -O /usr/local/bin/vmin-nginx.sh`

`chmod +x /usr/local/bin/vmin-nginx.sh`

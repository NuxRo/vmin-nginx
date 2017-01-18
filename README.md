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

- Install Nginx and set it to include .conf files from /etc/nginx/vhosts/*.conf (and create that dir); it also needs to run as user/group Apache

`mkdir /etc/nginx/vhosts`

`echo "include /etc/nginx/vhosts/*.conf;" > /etc/nginx/conf.d/vmin-nginx.conf`
`sed -i s/"user nginx;"/"user apache apache;"/g /etc/nginx/nginx.conf`

`service nginx restart`

`systemctl enable nginx`


- Set Virtualmin to run this script as Pre/Post command: /usr/local/bin/vmin-nginx.sh
![Screenshot3](http://img.nux.ro/J9b-Selection_190.png)


- Download the script and make it executable:

`wget https://raw.githubusercontent.com/NuxRo/vmin-nginx/master/vmin-nginx.sh -O /usr/local/bin/vmin-nginx.sh`

`chmod +x /usr/local/bin/vmin-nginx.sh`

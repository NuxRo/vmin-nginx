#!/bin/bash

# https://virtualmin.com/node/45023

#!/bin/bash

# if the action is positive (ie not deletion); then we need to do virtualhost stuff

if [[ "$VIRTUALSERVER_ACTION" = "MODIFY_DOMAIN" || "$VIRTUALSERVER_ACTION" = "CREATE_DOMAIN" || "$VIRTUALSERVER_ACTION" = "RESTORE_DOMAIN" ]]; then

# if it's just an alias, we simply add it to a separate aliases file we include in the main vhost
if [ -n "$VIRTUALSERVER_ALIAS" ]; then
echo "server_name $VIRTUALSERVER_DOM www.$VIRTUALSERVER_DOM;" >> /etc/nginx/vhosts/"$ALIAS_VIRTUALSERVER_DOM".aliases
service nginx reload

else

# IF NOT ALIAS THEN ADD PROPER VHOST

# prepare aliases file for any eventual aliases
touch /etc/nginx/vhosts/"$VIRTUALSERVER_DOM".aliases

# actual vhost config
echo "
server {
        server_name $VIRTUALSERVER_DOM www.$VIRTUALSERVER_DOM;
        include /etc/nginx/vhosts/$VIRTUALSERVER_DOM.aliases;
        listen  $VIRTUALSERVER_IP;
        root $VIRTUALSERVER_PUBLIC_HTML_PATH;
        access_log /var/log/virtualmin/"$VIRTUALSERVER_DOM"_nginx_access_log;
        error_log /var/log/virtualmin/"$VIRTUALSERVER_DOM"_nginx_error_log;
"       > /etc/nginx/vhosts/$VIRTUALSERVER_DOM.conf

# PROXY PHP to Apache and protect htaccess and htpassword
echo " 
        location ~ \.php$ {
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_pass http://$VIRTUALSERVER_IP:1080;
        }

        location ~ /\.ht {
                deny all;
        } " >> /etc/nginx/vhosts/$VIRTUALSERVER_DOM.conf

# END PROXY PHP

# SSL section
        if [[ $VIRTUALSERVER_SSL == 1 ]]; then
        echo "
        listen $VIRTUALSERVER_IP:443 ssl;
        ssl_certificate $VIRTUALSERVER_SSL_CERT;
        ssl_certificate_key $VIRTUALSERVER_SSL_KEY;" >> /etc/nginx/vhosts/$VIRTUALSERVER_DOM.conf
                if [ -n "$VIRTUALSERVER_SSL_CHAIN" ]; then
        echo "\
        ssl_client_certificate $VIRTUALSERVER_SSL_CHAIN;" >> /etc/nginx/vhosts/$VIRTUALSERVER_DOM.conf
                fi
        fi
# END SSL

echo "}" >> /etc/nginx/vhosts/$VIRTUALSERVER_DOM.conf
# END VHOST
service nginx reload
fi

# if the action is to delete a domain, we need to remove the vhost or the alias
elif [[ "$VIRTUALSERVER_ACTION" = "DELETE_DOMAIN" ]] || [[ "$VIRTUALSERVER_ACTION" = "MODIFY_DOMAIN" && "$VIRTUALSERVER_WEB" = "0" ]] || [ "$VIRTUALSERVER_ACTION" = "DISABLE_DOMAIN" ]; then

if [ -n "$VIRTUALSERVER_ALIAS" ]; then
        sed -i "/^server_name "$VIRTUALSERVER_DOM" www."$VIRTUALSERVER_DOM";/d" /etc/nginx/vhosts/"$ALIAS_VIRTUALSERVER_DOM".aliases
        service nginx reload
else
        rm -fv /etc/nginx/vhosts/"$VIRTUALSERVER_DOM".conf /etc/nginx/vhosts/"$VIRTUALSERVER_DOM".aliases
        service nginx reload
fi
fi

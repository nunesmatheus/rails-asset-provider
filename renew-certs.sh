#!/bin/bash

letsencrypt-auto --no-self-upgrade --post-hook 'service nginx reload' renew >> /etc/letsencrypt/certbot-renew.log

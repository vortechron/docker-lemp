#!/usr/bin/env bash

set -e

role=${CONTAINER_ROLE:-php}
env=${APP_ENV:-production}

if [ "$role" = "php" ]; then
    exec "php-fpm"
elif [ "$role" = "websocket" ]; then
    echo "Running the websocket..."
    php /var/www/html/artisan websocket:serve
elif [ "$role" = "queue" ]; then
    echo "Running the queue..."
    php /var/www/html/artisan queue:work --verbose --tries=3 --timeout=90
elif [ "$role" = "scheduler" ]; then
    while [ true ]
    do
      php /var/www/html/artisan schedule:run --verbose --no-interaction &
      sleep 60
    done
else
    echo "Could not match the container role \"$role\""
    exit 1
fi
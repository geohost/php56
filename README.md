# php56
Dockerfile for DockerHub: geohost/php56
Container based on Ubuntu 18.04 with php5.6-fpm with PHP ionCube module or corn
If the container was started with the env IS_CRON=1 make it only run the cron daemon
or with env IS_SUPERVISOR=1 will start the supervisord.

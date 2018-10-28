# cron

Docker image with cron running in foreground. On startup all environment variables will be put into `/project_env.sh` so you can pass e.g. mysql passwords to your cronjobs and scripts.

A sample cron might look like this:
```
0 0 * * * root . /project_env.sh; /root/scripts/run_backups.sh > /proc/1/fd/1 2>/proc/1/fd/2
```

A stack service might look like this:
```
  cron:
    image: shyd/cron
    deploy:
      replicas: 1
      placement:
        constraints: [node.role == manager]
    volumes:
      - ./cronjobs:/etc/cron.d
      - ./scripts:/root/scripts
      - ./backups:/backups
    env_file:
      - mysecrets.env
    [...]
```

In order to have proper log output redirect `stdout` and `stderr` like so: `myfancycmd > /proc/1/fd/1 2>/proc/1/fd/2`.

If you want to trigger ownClouds cron with system cron use the tag `owncloud` like so:

```
  cron:
    image: shyd/cron:owncloud
    deploy:
      replicas: 1
      placement:
        constraints: [node.role == manager]
    volumes:
      - ./oc_cron/cronjobs:/etc/cron.d
      - html:/var/www/html
      - data:/var/www/data
    [...]
```

Then create a cronjob `/oc_cron/cronjobs/oc`:

```
*/15 * * * * root . /project_env.sh; root su www-data -c '/usr/local/bin/php -f /var/www/html/cron.php; echo "fired"' -s "/bin/bash" > /proc/1/fd/1 2>/proc/1/fd/2
```

to run the cron every 15 minutes.

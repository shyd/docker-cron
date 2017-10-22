# cron

Docker image with cron running in foreground. On startup all environment variables will be put into `/root/project_env.sh` so you can pass e.g. mysql passwords to your cronjobs and scripts.

A sample cron might look like this:
```
0 0 * * * root . /root/project_env.sh; /root/scripts/run_backups.sh > /proc/1/fd/1 2>/proc/1/fd/2
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

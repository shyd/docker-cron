#!/usr/bin/env bash

printenv | sed 's/^\(.*\)$/export \1/g' > /root/project_env.sh

exec cron -f

#!/usr/bin/env bash

printenv | sed 's/^\(.*\)$/export \1/g' > /project_env.sh
printenv | sed 's/^\(.*\)$/export \1/g' > /root/project_env.sh

exec cron -f

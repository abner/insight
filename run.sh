#!/bin/bash
cd /opt/feedback-server/
source  ../feedback-shared/secret_export
bundle exec puma -b tcp://127.0.0.1 -e production -p 3232 -d  --pidfile /var/run/feedback-web/feedback-web.pid

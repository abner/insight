#!/bin/bash
export SECRET_KEY_BASE=7351707e8086f732bc3c2661b162c68589ce2194ec94fd08565946f2a1ee2df8aa66b94c9452777829114d4bc7ec114acd7c55a45aa5b1326acf649c648dfe28
cd /opt/feedback-server/
bundle exec puma -b tcp://127.0.0.1 -e production -p 3232 -d  --pidfile /var/run/feedback-web/feedback-web.pid

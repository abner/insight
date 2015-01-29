web: bundle exec thin start -C thin.yaml
node: node websocket-server/server.js
mongodb: $MONGODB_HOME/bin/mongod --dbpath=$MONGODB_DBPATH --setParameter textSearchEnabled=true
mongodb_repair: $MONGODB_HOME/bin/mongod --dbpath=$MONGODB_DBPATH --setParameter textSearchEnabled=true --repair

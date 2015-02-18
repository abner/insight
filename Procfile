web: ./run.sh
#node: node websocket-server/server.js
mongodb: $MONGODB_HOME/bin/mongod --dbpath=$MONGODB_DBPATH --setParameter textSearchEnabled=true --fork --logpath=log/mongodb.log
mongodb_repair: $MONGODB_HOME/bin/mongod --dbpath=$MONGODB_DBPATH --setParameter textSearchEnabled=true --repair

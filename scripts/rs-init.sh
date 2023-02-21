#!/bin/bash

DELAY=25

mongosh -u "$MONGO_INITDB_ROOT_USERNAME" -p "$MONGO_INITDB_ROOT_PASSWORD" <<EOF
var config = {
  "_id" : "replica-set",
  "members" : [
    {
      "_id" : 0,
      "host" : "mongo-primary:27017"
    },
    {
      "_id" : 1,
      "host" : "mongo-worker-1:27017"
    }
  ]};
rs.initiate(config, { force: true });

var conf = rs.config();
conf.members[0].priority = 2;
rs.reconfig(conf);

use admin;
db.createUser(
  {
    user: "$MONGO_CLUSTER_USERNAME",
    pwd: "$MONGO_CLUSTER_PASSWORD",
    roles: [ { role: "userAdminAnyDatabase", db: "admin" },  { "role" : "clusterAdmin", "db" : "admin" } ]
  });
db.auth("$MONGO_CLUSTER_USERNAME", "$MONGO_CLUSTER_PASSWORD");

use $MONGO_DB_NAME;
db.createUser(
  {
    user: "$MONGO_DB_USERNAME",
    pwd: "$MONGO_DB_PASSWORD",
    roles: [ { role: "readWrite", db: "$MONGO_DB_NAME" } ]
  });
EOF

mongosh -u "$MONGO_INITDB_ROOT_USERNAME" -p "$MONGO_INITDB_ROOT_PASSWORD" <<EOF
use $MONGO_DB_NAME;
db.createCollection("collection_name");
EOF

mongoimport --db sa_dev -u $MONGO_DB_USERNAME -p $MONGO_DB_PASSWORD --collection collection_name --file /datadump/collection_name.json --jsonArray --mode=upsert

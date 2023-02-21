# MongoDB replicaset with authentication using-docker compose boilerplate

## To run the cluster:
```shell
docker-compose up -d
```

## Instantiate the replica set and other things
```shell
docker exec -it mongo-primary bash

# once inside the mongo-primary container
bash /scripts/rs-init.sh
```


## Destory the cluster:
```shell
docker-compose down
```

## Connection String for MongoDB Compass
```shell
# for MONGO_INITDB_ROOT_USERNAME and MONGO_INITDB_ROOT_PASSWORD refer mongod.env file. 
# Note mongod.env is just a sample.
mongodb://<MONGO_INITDB_ROOT_USERNAME>:<MONGO_INITDB_ROOT_PASSWORD>@localhost:27017/?readPreference=primary&directConnection=true&authMechanism=DEFAULT
```

## Note
This replica set is for educational and demonstration purposes ONLY.
Running multiple nodes of a Replica Set within a single machine is an anti-pattern, and MUST BE AVOIDED in Production.
Using this setup for local development though, is perfectly fine.
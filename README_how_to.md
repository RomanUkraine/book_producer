#### LOCAL DEVELOPMENT
#### set up token into Gemfile for gem 'erp-data-sync'!!! and after that run: ```bundle install```

```sh
  rails s -p 3001 / 3002
  sidekiq
  rake data_sync:client
```

```sh
  postgresql      service on port 5432
  redis           service on port 6379
```

```sh
  brew services stop postgresql
  brew services start postgresql

  brew services stop redis
  brew services start redis
```

#### LOCAL PRODUCTION
```sh
  export EDITOR=vim
  bundle exec rails credentials:edit

  RAILS_ENV=production rake db:create
  RAILS_ENV=production rake db:migrate

  RAILS_ENV=production bundle exec rake assets:precompile
  RAILS_ENV=production bundle exec rails db
  RAILS_ENV=production rake data_sync:client

  RAILS_ENV=production rails s -p 3001
  RAILS_ENV=production rails s -p 3002
```

#### LOCAL Minikube 

```sh
  0. /book_producer 
  1. create image               ->  book_producer.image
  2. book_producer.image        -> minikube (docker)
    3. book_producer container 
  4. pod    <-    deployment    <-    service (name | ip | hostname)    <-    ingress
```

```sh
  http://hello-world.info/ -> 192.168.64.4 (of minikube)
                              ingress
                               service
                                 deployment
                                   pod
                                     /book_producer 
```

```sh
  redis (deployment)          <- service
  postgres (deployment)       <- PV + PVC     <- service
```

##### install locally Minikube
  https://kubernetes.io/ru/docs/tasks/tools/install-minikube/

##### start up Minikube
```sh
  minikube start --extra-config=apiserver.service-node-port-range=3000-32767 --ports=127.0.0.1:3000-32767:3000-32767
```

##### delete all container and images
```sh
  docker rm -vf $(docker ps -aq)
  docker rmi -f $(docker images -aq)
```

##### enable 
```sh
  eval $(minikube docker-env)
```

#### build image for book_producer sources 
```sh
  docker build -t book-producer --progress plain --no-cache --build-arg GITHUB_TOKEN=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 .
```

##### login to minikube ssh and check if book-producer created
```sh
✗ minikube ssh
  docker images |  grep book-producer
```

cd k8s
#### apply postgresql
```sh
  kubectl apply -f pg
```

#### start minikube dashboard and go to brawser
```
   minikube dashboard
```

#### over minikube dashboard manually connect into POD of postgresql and create two databases for two projects 
```sh
  psql -h localhost -p 5432 -U admin -W postgresdb
    and type password - adminS3cret

  create database book_producer_production;
  create database book_consumer_production;
```

#### apply redis
```sh
  kubectl apply -f redis
```

#### apply k8s config files for book_producer project
```sh
  cd k8s
  kubectl apply -f deployment.yaml
  kubectl apply -f service.yaml
  kubectl apply -f ingress.yaml
```

#### over minikube hhtp browser connect To POD "book-producer..." , go to inside (over Exec) 
and run migration 
```sh
  rake db:migrate
```

#### go to hosts file and provide changes
```sh
  sudo su
  cd /etc/
  manually edit hosts
  add this rows at the end of hosts file

  192.168.64.4  hello-world.info
  192.168.64.4  hello-world2.info

  and save changes
```

#### test if two hosts correct resolved
```sh
  ping hello-world.info
  ping hello-world2.info
```

#### for book_producer do the same
1. bundle install in development mode
2. compile assets
3. change Gemnfile with correct generated token
4. build image by CLI with command
```sh
  docker build -t book-consumer --progress plain --no-cache --build-arg GITHUB_TOKEN=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 .
```
5. apply k8s config files for book_consumer project
```sh
  cd k8s
  kubectl apply -f deployment.yaml
  kubectl apply -f service.yaml
  kubectl apply -f ingress.yaml
```

#### over minikube hhtp browser connect To POD "book-consumer..." , go to inside (over Exec) 
and run migration 
```sh
  rake db:migrate
```

#### go to POD of "book-producer..." over Exec inside and run
```sh
  rake data_sync:client
```

#### go to POD of "book-consumer..." over Exec inside and run
```sh
  rake data_sync:client
```

#### go to POD of redis (redis-...) over Exec and monitor if traffic exists 
```sh
  redis-cli monitor | grep 'set\|publish\|get'
```

go to browser http://hello-world.info/, create new Book 
and go to http://hello-world2.info/ and check if sync working correct

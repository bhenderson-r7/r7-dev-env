# K8s Development Environment

This is a simple chart that deploys a development environment to a local K8s cluster. 
The intended use is with Docker Desktop

This environment consists of:

* A MYSQL 8.0 database
* A Redis database (latest)

## Prerequisites

* Install Docker Desktop
* Enable Kubernetes
* Install Helm

### Installing Helm

```bash
brew install helm
```

## Getting started

If you've used `kubectl` for K8s clusters other than the local Docker Desktop cluster, run

```bash
kubectl config use-context docker-desktop
```

The following command will install or upgrade MySQL 8.1 and Redis into your local Docker Desktop K8s cluster
```bash
make install
```

## Uninstall everything

The following command will uninstall everything from your local Docker Desktop K8s cluster but leave the data directories intact

```bash
make uninstall
```

## Create a snapshot of the mysql database

The following command will create a snapshot of the current mysql state

```bash
make snapshot
```

## Restore the most recent mysql snapshot

The following command will restore the most recent mysql snapshot

```bash
make restore
```

## Resoure a specific mysql snapshot

```bash
make restore MYSQLSNAPSHOT=mysql-20240627T151112.tar.gz
```

## Health check the deployment

The following command will check the health of the deployment

```bash
make status 
```

A healthy state should look something like:

```bash
kubectl get all -n r7-dev-env
NAME                                  READY   STATUS    RESTARTS   AGE
pod/r7-dev-env-mysql-stateful-set-0   1/1     Running   0          2m25s
pod/r7-dev-env-redis-stateful-set-0   1/1     Running   0          2m25s

NAME                                  TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
service/r7-dev-env-mysql-db-service   LoadBalancer   10.106.1.77     localhost     3306:30778/TCP   2m25s
service/r7-dev-env-redis-db-service   LoadBalancer   10.101.34.138   localhost     6379:31483/TCP   2m25s

NAME                                             READY   AGE
statefulset.apps/r7-dev-env-mysql-stateful-set   1/1     2m25s
statefulset.apps/r7-dev-env-redis-stateful-set   1/1     2m25s
```

## Troubleshooting

If your pods are not running check:

```bash
kubectl describe node docker-desktop
```

If you see an event like `Warning  EvictionThresholdMet  ...  Attempting to reclaim ephemeral-storage` you may not have your Virtual disk limit set high enough

In Docker Desk top increase `Settings -> Resources -> Advanced -> Virtual disk limit` to 128 GB

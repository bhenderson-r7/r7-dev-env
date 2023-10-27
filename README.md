# K8s Development Databases

This is a simple chart that deploys development databases to a local K8s cluster. 
The intended use is with Docker Desktop

## Prerequisites

* Install Docker Desktop
* Enable Kubernetes
* Install Helm

### Installing Helm

```
brew install helm
```

## Getting started

If you've used `kubectl` for K8s clusters other than the local Docker Desktop cluster, run
```
kubectl config use-context docker-desktop
```

The following command will install or upgrade MySQL 8.1 and Redis into your local Docker Desktop K8s cluster
```
make install
```

## Uninstall everything

The following command will uninstall everything from your local Docker Desktop K8s cluster but leave the data directories intact
```
make uninstall
```

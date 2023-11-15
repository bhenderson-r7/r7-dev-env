NAMESPACE ?= k8s-development-databases
MYSQLVOLUMEHOSTPATH ?= $(shell pwd)/_data/mysql
REDISVOLUMEHOSTPATH ?= $(shell pwd)/_data/redis
TIMESTAMP ?= $(shell date +"%Y%m%dT%H%M%S")
MYSQLLATESTSNAPSHOT ?= $(shell ls -t _data/_snapshot | grep -m 1 mysql)

.PHONY: help
help:
	@echo "============================================================"
	@echo "  install                   install or upgrade the helmchart"
	@echo "  uninstall                 uninstall the helmchart"
	@echo "  snapshot                  create a snapshot mysql"
	@echo "  restore                   restore most recent mysql snapshot"
	@echo "------------------------------------------------------------"

.PHONY: install
install:
	helm upgrade --install ${NAMESPACE} ./ \
		--namespace ${NAMESPACE} --create-namespace \
		--set-string db.mysql.persistentVolumeHostPath=${MYSQLVOLUMEHOSTPATH} \
		--set-string db.redis.persistentVolumeHostPath=${REDISVOLUMEHOSTPATH}

.PHONY: uninstall
uninstall:
	helm uninstall ${NAMESPACE} --namespace ${NAMESPACE}

.PHONY: snapshot
snapshot: create-snapshot-dir
	tar czf _data/_snapshot/mysql-${TIMESTAMP}.tar.gz _data/mysql

create-snapshot-dir:
	mkdir -p _data/_snapshot

.PHONY: restore
restore: scale-down-mysql replace scale-up-mysql
	@echo "------------------------------------------------------------"
	@echo "  Snapshot restored from ${MYSQLLATESTSNAPSHOT}"
	@echo "------------------------------------------------------------"

replace:
	rm -rf _data/mysql
	tar xzf _data/_snapshot/${MYSQLLATESTSNAPSHOT}

scale-down-mysql:
	kubectl scale statefulset -n ${NAMESPACE} --replicas=0 ${NAMESPACE}-mysql-stateful-set

scale-up-mysql:
	kubectl scale statefulset -n ${NAMESPACE} --replicas=1 ${NAMESPACE}-mysql-stateful-set

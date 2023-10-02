NAMESPACE ?= k8s-development-databases
MYSQLVOLUMEHOSTPATH ?= $(shell pwd)/_data/mysql
REDISVOLUMEHOSTPATH ?= $(shell pwd)/_data/redis

.PHONY: help
help:
	@echo "============================================================"
	@echo "  install                   install or upgrade the helmchart"
	@echo "  uninstall                 uninstall the helmchart"
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

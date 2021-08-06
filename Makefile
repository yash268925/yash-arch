LANG  := C
IMAGE := yash268925/yash-arch
TAG   := latest

# http://postd.cc/auto-documented-makefile/
.DEFAULT_GOAL := help
.PHONY: help
help: ## Show this help
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "${CYAN}%-30s${RESET} %s\n", $$1, $$2}'

.PHONY: image
image: ## Build a docker image
	@cp /etc/pacman.d/mirrorlist ./mirrorlist
	@docker build -t ${IMAGE}:${TAG} .

.PHONY: pull
pull: ## Pull a docker image
	@docker pull ${IMAGE}:${TAG}

.PHONY: push
push: ## Push a docker image
	@docker push ${IMAGE}:${TAG}


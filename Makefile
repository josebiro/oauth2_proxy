# oauth2_proxy docker image makefile

APP_NAME = oauth2_proxy
VERSION = master
DOCKER_REPO = josebiro
DOCKER = docker
DATE := $(shell date --iso-8601)

# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help


# DOCKER TASKS
clean:
	docker image prune -a -f

rmdi: ## Removes dangling images.
	-docker images -a --filter=dangling=true -q | xargs docker rmi

# Build the container
build: ## Build the container
	docker build -t $(APP_NAME) .

build-nc: ## Build the container without caching
	docker build --no-cache -t $(APP_NAME) .

run: ## Run container on port configured in `config.env`
	docker run -i -t --rm -p=4180:4180 --name="$(APP_NAME)" $(APP_NAME) --version --help

up: build run ## Run container on port configured in `config.env` (Alias to run)

stop: ## Stop and remove a running container
	docker stop $(APP_NAME); docker rm $(APP_NAME)

release: build-nc publish ## Make a release by building and publishing the `{version}` ans `latest` tagged containers

# Docker publish
publish: repo-login publish-latest publish-version publish-date ## Publish the `{version}` ans `latest` tagged containers

publish-latest: tag-latest ## Publish the `latest` tagged container
	@echo 'publish latest to $(DOCKER_REPO)'
	docker push $(DOCKER_REPO)/$(APP_NAME):latest

publish-version: tag-version ## Publish the `{version}` tagged container
	@echo 'publish $(VERSION) to $(DOCKER_REPO)'
	docker push $(DOCKER_REPO)/$(APP_NAME):$(VERSION)

publish-date: tag-date ## Publish the `{date}` tagged container
	@echo 'publish $(DATE) to $(DOCKER_REPO)'
	docker push $(DOCKER_REPO)/$(APP_NAME):$(DATE)

# Docker tagging
tag: tag-latest tag-version tag-date ## Generate container tags for the `{version}` ans `latest` tags

tag-latest: ## Generate container `latest` tag
	@echo 'create tag latest'
	docker tag $(APP_NAME) $(DOCKER_REPO)/$(APP_NAME):latest

tag-version: ## Generate container `version` tag
	@echo 'create tag $(VERSION)'
	docker tag $(APP_NAME) $(DOCKER_REPO)/$(APP_NAME):$(VERSION)

tag-date: ## Generate container `date --iso-8601` tag due to no git repo context
	@echo 'create tag $(DATE)'
	docker tag $(APP_NAME) $(DOCKER_REPO)/$(APP_NAME):$(DATE)

# HELPERS

# generate script to login to aws docker repo
CMD_REPOLOGIN := "docker login"

# login to docker
repo-login: ## Auto login to docker
	@eval $(CMD_REPOLOGIN)

version: ## Output the current version
	@echo $(VERSION)


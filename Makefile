.PHONY: default
default: help;

STACK_SLUG := matchilling/hmrc-exchange-rates
STACK_VERSION := latest

help:  ## Show this help
	@echo '----------------------------------------------------------------------'
	@echo $(STACK_SLUG)
	@echo '----------------------------------------------------------------------'
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'
	@echo '----------------------------------------------------------------------'

build: ## Build the container
	@docker build \
		--file Dockerfile \
		--tag "${STACK_SLUG}:${STACK_VERSION}" .

run:   ## Run the container in an interactive shell
	@docker run \
		--rm \
		-it \
		--volume ${PWD}:/home/circleci/project \
		"${STACK_SLUG}:${STACK_VERSION}" bash

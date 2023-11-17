APP_DIR:=$(CURDIR)

default: help

.PHONY: help
help: ## Show this help message
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf " \033[36m%-20s\033[0m  %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: install
install: ## Install bctl on your system
	$(APP_DIR)/scripts/install.sh

.PHONY: docs
docs: ## Run the documentation website locally
	hugo server --source website/ --disableFastRender

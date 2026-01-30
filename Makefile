.DEFAULT_GOAL := help

DOCKER ?= docker
PLATFORM ?= linux/amd64,linux/arm64
IMAGE_NAME ?= dotfiles
IMAGE_TAG ?= latest
DOCKER_TAG := $(IMAGE_NAME):$(IMAGE_TAG)

.PHONY: build
build: build-ubuntu build-amazon

.PHONY: build-ubuntu
build-ubuntu: ## Build the Ubuntu Docker image
	$(DOCKER) buildx build --platform $(PLATFORM) -f ./build/Dockerfile.ubuntu -t ubuntu-$(DOCKER_TAG) .

.PHONY: build-amazon
build-amazon: ## Build the Amazon Linux Docker image
	$(DOCKER) buildx build --platform $(PLATFORM) -f ./build/Dockerfile.amazon -t amazon-$(DOCKER_TAG) .

.PHONY: build-manual
build-manual: ## Build the manual testing Docker image
	$(DOCKER) build -f ./build/Dockerfile.manual -t manual-$(DOCKER_TAG) .

.PHONY: test
test: test-ubuntu test-amazon ## Run chezmoi tests on all containers

.PHONY: test-ubuntu
test-ubuntu: ## Run chezmoi test on the Ubuntu container
	$(DOCKER) run --rm \
		-v "$$(pwd):/dotfiles:ro" \
		ubuntu-$(DOCKER_TAG) \
		bash -c "cd /dotfiles && ./test/chezmoi-test.sh"

.PHONY: test-amazon
test-amazon: ## Run chezmoi test on the Amazon Linux container
	$(DOCKER) run --rm \
		-v "$$(pwd):/dotfiles:ro" \
		amazon-$(DOCKER_TAG) \
		bash -c "cd /dotfiles && ./test/chezmoi-test.sh"

.PHONY: manual-test
manual-test: ## Launch manual test container with zsh for interactive chezmoi testing
	@echo ""
	@echo "==== Manual Chezmoi Testing ===="
	@echo ""
	@echo "To test chezmoi installation, run one of the following inside the container:"
	@echo ""
	@echo "  # Initialize from your GitHub dotfiles repo:"
	@echo "  chezmoi init --apply <github-username>"
	@echo ""
	@echo "  # Or initialize from local dotfiles (mounted at /dotfiles):"
	@echo "  chezmoi init --source /dotfiles --apply"
	@echo ""
	@echo "  # Switch to bash if needed:"
	@echo "  bash"
	@echo ""
	@echo "================================"
	@echo ""
	$(DOCKER) run -it --rm \
		-v "$$(pwd):/dotfiles:ro" \
		manual-$(DOCKER_TAG) \
		zsh

.PHONY: clean
clean: ## Remove the built image
	-$(DOCKER) rmi $$($(DOCKER) images --format '{{.Repository}}:{{.Tag}}' | grep '$(DOCKER_TAG)')

.PHONY: help
help: ## Show this help
	@echo "Targets:"
	@echo "  build                  Build all Docker images"
	@echo "  build-ubuntu           Build the Ubuntu Docker image (multi-arch)"
	@echo "  build-amazon           Build the Amazon Linux Docker image (multi-arch)"
	@echo "  build-manual           Build the manual testing Docker image"
	@echo "  test                   Run chezmoi tests on all containers"
	@echo "  test-ubuntu            Run chezmoi test on the Ubuntu container"
	@echo "  test-amazon            Run chezmoi test on the Amazon Linux container"
	@echo "  manual-test            Launch manual test container with zsh"
	@echo "  clean                  Remove the built image"
	@echo ""
	@echo "Variables (override with VAR=value):"
	@echo "  IMAGE_NAME (default: $(IMAGE_NAME))"
	@echo "  IMAGE_TAG  (default: $(IMAGE_TAG))"
	@echo "  PLATFORM  (default: $(PLATFORM))"

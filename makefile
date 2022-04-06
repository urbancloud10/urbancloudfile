IMAGE_NAME=treewebpython
VERSION=1.2

removeall: ## Removes all created resources
	docker image rm $(IMAGE_NAME):$(VERSION) -f
	kubectl delete namespace treeweb

removek8s: ## Removes kubernetes resources
	kubectl delete namespace treeweb

build: ## Builds docker image
	docker build -t $(IMAGE_NAME):$(VERSION) .

sh: _build-if-not-exists ## Runs open shell on container of web server image
	docker run -it -v $(shell pwd):/app -p 80:5000 --entrypoint bash $(IMAGE_NAME):$(VERSION)

run: _build-if-not-exists ## Runs server on localhost:5000
	docker run -p 80:5000 $(IMAGE_NAME):$(VERSION)

test: _build-if-not-exists ## Runs tests
	docker run -v $(shell pwd):/app --entrypoint python $(IMAGE_NAME):$(VERSION) -m unittest

_build-if-not-exists: ## Builds docker image if not exists
	@if [ "$$(docker images -q $(IMAGE_NAME):$(VERSION) 2> /dev/null)" = "" ]; then \
		echo "Docker Image '$(IMAGE_NAME):$(VERSION)' not exist"; \
		make --no-print-directory build; \
	fi

deploy:  ## Deploys on minikube
	python3 -m unittest
	make build
	minikube image load $(IMAGE_NAME):$(VERSION)
	kubectl apply -f k8s/manifest.yml
	bash -c 'while [[ "$$(curl -s -o /dev/null -w ''%{http_code}'' local.ecosia.org/tree)" != "200" ]]; do sleep 5; done'
	echo "Done"

k8s-deploy:
	kubectl apply -f k8s/manifest.yml

check-if-works:
	bash -c 'while [[ "$$(curl -s -o /dev/null -w ''%{http_code}'' local.ecosia.org/tree)" != "200" ]]; do sleep 5; done'
	echo "Done"

load-image:
	minikube image load $(IMAGE_NAME):$(VERSION)
	
local-test:
	python3 -m unittest

all:
	make local-test
	make build
	make load-image
	make k8s-deploy
	make check-if-works
	








##########################################################
## Auto Help Command (do not change)
##########################################################
help:
	@grep -E '^(##-).*$$' $(MAKEFILE_LIST) | cut -c 5- | \
	awk 'function color(c,s) {printf("\033[%dm%s\033[0m\n",30+c,s)} \
	/@param/ {color(7,$$0);next} \
	/\t/ {print;next} \
	{color(6,$$0)}'; \
	echo "============ Quick view ============"; \
	grep -E '^[a-zA-Z_0-9-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

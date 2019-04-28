QUAY_USERNAME ?=
QUAY_PASSWORD ?=

IMAGE_REGISTRY ?= docker.io
IMAGE_TAG ?= latest
OPERATOR_IMAGE ?= rthallisey/hyperconverged-cluster-operator

start:
	./hack/deploy.sh

clean:
	./hack/clean.sh

docker-build: docker-build-operator

docker-build-operator:
	docker build -f build/Dockerfile -t $(IMAGE_REGISTRY)/$(OPERATOR_IMAGE):$(IMAGE_TAG) .

docker-push: docker-push-operator

docker-push-operator:
	docker push $(IMAGE_REGISTRY)/$(OPERATOR_IMAGE):$(IMAGE_TAG)

cluster-up:
	./cluster/up.sh

cluster-down:
	./cluster/down.sh

cluster-sync:
	./cluster/sync.sh

cluster-clean:
	CMD="./cluster/kubectl.sh" ./hack/clean.sh

stageRegistry:
	@REGISTRY_NAMESPACE=redhat-operators-stage ./hack/quay-registry.sh $(QUAY_USERNAME) $(QUAY_PASSWORD)

.PHONY: start \
		clean \
		docker-build \
		docker-build-operator \
		docker-push \
		docker-push-operator \
		cluster-up \
		cluster-down \
		cluster-sync \
		cluster-clean \
		stageRegistry

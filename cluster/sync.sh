#!/bin/bash -e

registry_port=$(./cluster/cli.sh ports registry | tr -d '\r')
registry=localhost:$registry_port

# Cleanup previously generated manifests
#rm -rf _out/

# Copy release manifests as a base for generated ones, this should make it possible to upgrade
#cp -r deploy/converged _out/

# Sed from docker.io to registry:5000
#sed -i 's/image: docker\.io\/rthallisey\/hyperconverged-cluster-operator:latest/image: registry:5000\/rthallisey\/hyperconverged-cluster-operator:latest/g' _out/operator.yaml

make cluster-clean

IMAGE_REGISTRY=$registry make docker-build-operator docker-push-operator

for i in $(seq 1 ${CLUSTER_NUM_NODES}); do
    ./cluster/cli.sh ssh "node$(printf "%02d" ${i})" 'sudo docker pull rthallisey/hyperconverged-cluster-operator'
    # Temporary until image is updated with provisioner that sets this field
    # This field is required by buildah tool
    ./cluster/cli.sh ssh "node$(printf "%02d" ${i})" 'sudo sysctl -w user.max_user_namespaces=1024'
done

CMD="./cluster/kubectl.sh" ./hack/deploy.sh

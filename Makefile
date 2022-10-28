# updates in git
download-argocd-image-updater:
	mkdir -p ./resources/argocd-image-updater
	mkdir -p ./resources/argocd-image-updater/overlays
	curl -L https://raw.githubusercontent.com/argoproj-labs/argocd-image-updater/stable/manifests/install.yaml \
		> resources/argocd-image-updater/install.yaml

download-knative: download-knative-operator download-knative-serving download-knative-eventing

download-knative-operator:
	mkdir -p resources/knative-operator
	- rm resources/knative-operator/operator.yaml
	curl -L https://github.com/knative/operator/releases/download/knative-v1.7.1/operator.yaml \
		| sed 's/namespace: default/namespace: knative-operator/' \
		> resources/knative-operator/operator.yaml

download-knative-serving:
	mkdir -p resources/knative-serving-default-domain
	- rm resources/knative-serving-default-domain/serving-default-domain.yaml
	curl -L https://github.com/knative/serving/releases/download/knative-v1.7.2/serving-default-domain.yaml > resources/knative-serving-default-domain/serving-default-domain.yaml

download-knative-eventing:
	mkdir -p resources/knative-eventing-kafka
	- rm resources/knative-eventing-kafka/eventing-kafka-controller.yaml
	- rm resources/knative-eventing-kafka/eventing-kafka-broker.yaml
	curl -L https://github.com/knative-sandbox/eventing-kafka-broker/releases/download/knative-v1.7.2/eventing-kafka-controller.yaml > resources/knative-eventing-kafka/eventing-kafka-controller.yaml
	curl -L https://github.com/knative-sandbox/eventing-kafka-broker/releases/download/knative-v1.7.2/eventing-kafka-broker.yaml > resources/knative-eventing-kafka/eventing-kafka-broker.yaml

download-olm:
	mkdir -p resources/olm/charts/olm
	mkdir -p .tmp && cd .tmp && curl -L https://github.com/operator-framework/operator-lifecycle-manager/archive/v0.21.2.tar.gz | tar zx
	mv .tmp/operator-lifecycle-manager-0.21.2/deploy/chart/* resources/olm/charts/olm
	rm -rf .tmp/operator-lifecycle-manager-0.21.2

download-schemahero:
	mkdir -p resources/schemahero
	kubectl schemahero install --yaml > ./resources/schemahero/schemahero.yaml

onboard:
	kubectl ctx rancher-desktop
	@echo "Before this command will work, you must generate and set the environment variable 'GH_TOKEN'. Click the following link to generate a new token: https://github.com/settings/tokens/new?scopes=repo"
	GIT_REPO=https://github.com/CloudNativeEntrepreneur/argocd-gitops-local-dev argocd-autopilot repo bootstrap --recover
	@echo "✅ Configured"
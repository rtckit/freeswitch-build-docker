# Recipes for facilitating image building/publishing
REPOSITORY=rtckit/freeswitch-build

.PHONY: all
all: image

.PHONY: image
image:
	docker build -t ${REPOSITORY} .

.PHONY: run-mount
run-mount:
	docker run --rm -it -v ${DIR}:/usr/src/freeswitch:rw --name fsbuild ${REPOSITORY}

.PHONY: run-mount-host
run-mount-host:
	docker run --rm --network=host -it -v ${DIR}:/usr/src/freeswitch:rw --name fsbuild ${REPOSITORY}

.PHONY: tag
tag: HASH=$(shell docker run --rm ${REPOSITORY}:latest git -C /usr/src/freeswitch rev-parse --short HEAD)
tag:
	docker tag ${REPOSITORY}:latest ${REPOSITORY}:${HASH}

.PHONY: push
push: image tag
	docker push ${REPOSITORY}

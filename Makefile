PROJECT_ID?=ethjar-store

all: docker
.PHONY: all

bootstrap:
	docker build -t iso_bootstrap .
.PHONY: bootstrap

docker: bootstrap
	docker run --name iso_bootstrap \
		--privileged iso_bootstrap chroot /srv/fai/nfsroot /build.sh
	docker commit \
		--change='CMD ["fai-cd", "-fMJd", "", "-g", "/etc/fai/grub.cfg", "/workspace/ethjar.iso"]' \
		-m 'chroot customization' \
		iso_bootstrap eu.gcr.io/$(PROJECT_ID)/ethjar:live
.PHONY: docker

console:
	docker run --rm -ti -v $(CURDIR):/workspace --privileged eu.gcr.io/$(PROJECT_ID)/ethjar:live /bin/bash
.PHONY: console

clean:
	-docker rm -f iso_bootstrap
.PHONY: clean

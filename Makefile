# Default target
all: iso

containers/ethjar-debian:
	docker build -t ethjar/debian:bootstrap .
	docker run --name ethjar_bootstrap --privileged -ti ethjar/debian:bootstrap
	docker commit -m 'chroot init' ethjar_bootstrap ethjar/debian:chroot
	mkdir -p containers
	touch containers/ethjar-debian

iso: containers/ethjar-debian
	docker run -v $(CURDIR):/workspace --rm --privileged -ti --entrypoint /workspace/mkusb.sh ethjar/debian:chroot

console:
	docker run -v $(CURDIR):/workspace --rm --privileged -ti --entrypoint /bin/bash ethjar/debian:chroot

.PHONY: iso console

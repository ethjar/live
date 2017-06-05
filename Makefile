# Default target
all: iso

ethjar/kali:
	docker build -t ethjar/kali .

iso: ethjar/kali
	docker run -v $(CURDIR)/images:/live-build-config/images --rm --privileged -ti ethjar/kali

.PHONY: iso ethjar/kali

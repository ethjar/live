FROM eu.gcr.io/ethjar-store/ethjar:fai

RUN mkdir -p /srv/fai/config
RUN cp -a /usr/share/doc/fai-doc/examples/simple/* /srv/fai/config/
RUN cp /etc/resolv.conf /srv/fai/nfsroot/etc/resolv.conf

ADD grub.cfg /etc/fai/grub.cfg
ADD build.sh /srv/fai/nfsroot/build.sh

VOLUME "/workspace"
WORKDIR "/workspace"

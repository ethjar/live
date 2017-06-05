FROM kalilinux/kali-linux-docker

RUN apt-get update # 20170605
RUN apt-get install -y git live-build cdebootstrap debootstrap curl
ADD live-build-config /live-build-config

VOLUME "/live-build-config/images"
WORKDIR "/live-build-config"
ENTRYPOINT ["/live-build-config/build.sh"]
CMD ["--distribution", "kali-rolling", "--variant", "ethjar", "--verbose"]
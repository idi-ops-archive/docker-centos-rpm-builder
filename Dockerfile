FROM inclusivedesign/centos-devel:7

COPY build.sh /root/build.sh

RUN chmod 755 /root/build.sh

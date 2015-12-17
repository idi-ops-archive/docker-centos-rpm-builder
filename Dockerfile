FROM centos:7

RUN yum -y install epel-release sudo git rpmdevtools rpm-build && \
    yum clean all

COPY build.sh /root/build.sh

RUN chmod 755 /root/build.sh

RUN sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

CMD /root/build.sh

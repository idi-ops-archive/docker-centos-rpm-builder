FROM inclusivedesign/centos-devel:7

COPY build.sh /root/build.sh

RUN chmod 755 /root/build.sh

# Environment variables will need to be set when running the container - see README.md for examples
CMD /root/build.sh $PACKAGE_NAME $PACKAGE_REPO $OUTPUT_DIR $DEPS_DIR

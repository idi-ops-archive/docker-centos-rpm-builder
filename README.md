# docker-centos-rpm-builder
Container images that includes support tools to builds RPMs for CentOS

## Examples

Build mochiweb package:

    docker run --rm -v $PWD/output:/pkgs:Z -t -i inclusivedesign/centos-rpm-builder /root/build.sh erlang-mochiweb https://github.com/gtirloni/rpm-centos-mochiweb /pkgs /pkgs_deps

To build CouchDB, you'll need to provide the mochiweb RPM as a dependency that is not available in a public repo:

    docker run --rm -v $PWD/output:/pkgs:Z -v $PWD/input:/pkgs_deps:Z -t -i inclusivedesign/centos-rpm-builder /root/build.sh couchdb https://github.com/gtirloni/rpm-centos-couchdb /pkgs /pkgs_deps

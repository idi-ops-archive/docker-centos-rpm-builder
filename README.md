# docker-centos-rpm-builder
Container images that includes support tools to builds RPMs for CentOS

## Build the container

`docker build -t idi-ops/centos-rpm-builder .`

## Build packages in a container, dispose of the container, and keep the packages locally

 Environment variables must be specified at run time for the container to function:

 - `PACKAGE_NAME`: *required*: name of the package to build (should match specfile for the package repo)
 - `PACKAGE_REPO`: *required*: URL of GitHub repo to pull the package from
 - `OUTPUT_DIR`: *required*: output directory on Docker container to store packages
 - `DEPS_DIR`: *optional*: directory of dependency local packages to install before building the package (this can use packages from the host system with volume binding, as shown below)

### Example - building couchdb

#### Make a directory to store the packages

mkdir output

#### Build erlang-mochiweb dependency

```
docker run --rm -v $PWD/output:/pkgs -it \
-e PACKAGE_NAME=erlang-mochiweb \
-e PACKAGE_REPO=https://github.com/gtirloni/rpm-centos-mochiweb \
-e OUTPUT_DIR=/pkgs \
idi-ops/centos-rpm-builder
```

#### Build couchdb

```
docker run --rm -v $PWD/output:/pkgs -it \
-e PACKAGE_NAME=couchdb \
-e PACKAGE_REPO=https://github.com/gtirloni/rpm-centos-couchdb \
-e OUTPUT_DIR=/pkgs \
-e DEPS_DIR=/pkgs \
idi-ops/centos-rpm-builder
```

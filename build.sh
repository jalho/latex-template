#!/bin/bash

set -xe

BUILDER_IMAGE="docker.io/texlive/texlive@sha256:7e91f1cc80c471707291548282d1f87ea01c5d21ef525a4c7173b3c6a9b52efa"
BUILDER_CONTAINER="temp-tex-builder"

podman container kill $BUILDER_CONTAINER || true
podman container run --rm --name $BUILDER_CONTAINER -d $BUILDER_IMAGE sleep 1m

podman cp src/main.tex $BUILDER_CONTAINER:/workdir/main.tex
podman cp src/references.bib $BUILDER_CONTAINER:/workdir/references.bib
podman cp graphics/coat-of-arms.png $BUILDER_CONTAINER:/workdir/coat-of-arms.png

podman exec $BUILDER_CONTAINER sh -c "latexmk -pdf /workdir/main.tex"
podman cp $BUILDER_CONTAINER:/workdir/main.pdf ./main.pdf

podman container kill $BUILDER_CONTAINER

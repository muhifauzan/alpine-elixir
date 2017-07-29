#!/bin/sh
set -e

REPO=muhifauzan/alpine-elixir
REFRESHED_AT=$(cat REFRESHED_AT)
ERLANG_VERSION=$(cat ERLANG_VERSION)
ELIXIR_VERSION=$(cat ELIXIR_VERSION)
ELIXIR_REF=$(cat ELIXIR_REF)

docker build \
       --force-rm \
       --build-arg REFRESHED_AT=$REFRESHED_AT \
       --build-arg ERLANG_VERSION=$ERLANG_VERSION \
       --build-arg ELIXIR_VERSION=$ELIXIR_VERSION \
       --build-arg ELIXIR_REF=$ELIXIR_REF \
       -t ${REPO}:${ELIXIR_VERSION} \
       -t ${REPO}:latest \
       .

docker push ${REPO}:${ELIXIR_VERSION}
docker push ${REPO}:latest

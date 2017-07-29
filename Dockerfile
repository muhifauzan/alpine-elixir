ARG ERLANG_VERSION

FROM muhifauzan/alpine-erlang:${ERLANG_VERSION}

ARG REFRESHED_AT
ARG ELIXIR_VERSION
ARG ELIXIR_REF

# Important!  Update this no-op ENV variable when this Dockerfile
# is updated with the current date. It will force refresh of all
# of the base images and things like `apt-get update` won't be using
# old cached versions when the Dockerfile is built.
ENV REFRESHED_AT=$REFRESHED_AT \
    ELIXIR_VERSION=$ELIXIR_VERSION \
    DIALYXIR_PLT_CORE_PATH=${HOME}/.dialyxir_plt_core
ENV DIALYZER_PLT=${DIALYXIR_PLT_CORE_PATH}/dialyxir_erlang-${ERLANG_VERSION}.plt \
    ELIXIR_PLT=${DIALYXIR_PLT_CORE_PATH}/dialyxir_erlang-${ERLANG_VERSION}_elixir-${ELIXIR_VERSION}.plt

WORKDIR /tmp/elixir-build

RUN apk --update upgrade --no-cache && \
    echo "/////////////// Installing Elixir build deps /////" && \
    apk add --no-cache --virtual .elixir-build \
      git \
      make && \
    echo "///////////////////// Shallow cloning Elixir /////" && \
    if [ -z $ELIXIR_REF ]; then \
      git clone -b v${ELIXIR_VERSION} --single-branch --depth 1 https://github.com/elixir-lang/elixir.git .; \
    else \
      git clone -b master --single-branch --depth 1 https://github.com/elixir-lang/elixir.git . && git checkout $ELIXIR_REF; \
    fi && \
    echo "/////////////////////////// Compiling Elixir /////" && \
    make && make install && \
    mix local.hex --force && \
    mix local.rebar --force && \
    echo "////////////////////// Building dialyzer PLT /////" && \
    mkdir -p $DIALYXIR_PLT_CORE_PATH && \
    dialyzer --build_plt --apps erts kernel stdlib crypto mnesia && \
    dialyzer -pa lib/elixir/ebin --build_plt --output_plt $ELIXIR_PLT --apps lib/elixir/ebin/elixir.beam lib/elixir/ebin/Elixir.Kernel.beam && \
    echo "//////////////////////////////// Cleaning up /////" && \
    cd $HOME && \
    rm -rf /tmp/elixir-build && \
    apk del --force .elixir-build

WORKDIR $HOME

CMD ["/bin/sh"]

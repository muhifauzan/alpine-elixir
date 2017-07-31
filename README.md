# Elixir on Alpine Linux

[![Docker Automated build](https://img.shields.io/docker/automated/muhifauzan/alpine-elixir.svg)](https://hub.docker.com/r/muhifauzan/alpine-elixir/)
[![Docker Build Status](https://img.shields.io/docker/build/muhifauzan/alpine-elixir.svg)](https://hub.docker.com/r/muhifauzan/alpine-elixir/builds/)

This Dockerfile provides a full installation of Elixir on Alpine, intended for
running on CI with minimum dependency and it has no build tools installed. This
Dockerfile is almost identical with bitwalker/alpine-elixir with additional
Dialyzer. The caveat of course is if one has NIFs which require a native
compilation toolchain, but that is left as an exercise for the reader.

# Dialyzer PLT

This image provide PLT that built against current Erlang/OTP and Elixir
version. The Erlang apps that were included are `erts`, `kernel`, `stdlib`, and
`crypto`. The Erlang output file is `dialyxir_erlang-20.0.1.plt` and the Elixir
output file is `dialyxir_erlang-20.0.1_elixir-1.4.5.plt`. All is stored in
`DIALYZER_PLT_PATH` directory. This is useful when you're working with
Dialyxir. Add dialyzer:
`[plt_core_path: System.get_env("DIALYZER_PLT_PATH")]` to your `mix.exs`:

```shell
def project do
  [
    app: :my_app,
    version: "0.0.1",
    elixir: "~> 1.4",
    build_embedded: Mix.env == :prod,
    start_permanent: Mix.env == :prod,
    deps: deps(),
    dialyzer: [plt_core_path: System.get_env("DIALYZER_PLT_PATH")],
  ]
end
```

# Usage

To boot straight to a prompt in the image:

```shell
$ docker run --rm -it muhifauzan/alpine-elixir iex
Erlang/OTP 20 [erts-9.0.1] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads
:10] [hipe] [kernel-poll:false]

Interactive Elixir (1.4.5) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)>
User switch command
 --> q
```

<!--  LocalWords:  bitwalker
 -->

FROM elixir:1.19-otp-28-slim AS build

RUN apt-get update && apt-get install -y git make gcc libc6-dev && rm -rf /var/lib/apt/lists/*

WORKDIR /app

ENV MIX_ENV=prod

COPY mix.exs mix.lock ./
RUN mix local.hex --force && mix local.rebar --force
RUN mix deps.get --only prod
RUN mix deps.compile

COPY config/config.exs config/prod.exs config/runtime.exs config/
COPY lib lib

RUN mix compile
RUN mix release

# --- Runtime ---
FROM debian:trixie-slim

RUN apt-get update && apt-get install -y libstdc++6 openssl libncurses6 locales curl \
    && rm -rf /var/lib/apt/lists/* \
    && sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

WORKDIR /app

COPY --from=build /app/_build/prod/rel/passeur_demo ./

COPY entrypoint.sh ./
RUN chmod +x entrypoint.sh

RUN mkdir -p /data/vault

ENV PORT=4000
EXPOSE 4000

ENTRYPOINT ["./entrypoint.sh"]

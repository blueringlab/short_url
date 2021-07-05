# ---- Base Stage ---------------------------------------------------------------------------------
FROM hexpm/elixir:1.11.2-erlang-23.1.3-debian-buster-20201012 AS base

# install build dependencies
RUN apt-get -qq update && \
   apt-get -qq -y install build-essential npm git python --fix-missing --no-install-recommends

# prepare build dir
WORKDIR /app

ARG MIX_ENV
ARG RELEASE_ENV
ARG DATABASE_URL
ARG SECRET_KEY_BASE

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# Update timezone
ENV TZ=America/Denver

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=${MIX_ENV}
ENV RELEASE_ENV=${RELEASE_ENV}
ENV DATABASE_URL=${DATABASE_URL}
ENV SECRET_KEY_BASE=${SECRET_KEY_BASE}

COPY mix.exs mix.lock ./
COPY config config

# install mix dependencies
RUN mix deps.get --only ${MIX_ENV}
RUN mix deps.compile

COPY lib ./lib
COPY priv ./priv

# ---- Test Stage ---------------------------------------------------------------------------------
FROM base as tester
WORKDIR /app
COPY test test

# ---- Build Phoenix Assets Stage -----------------------------------------------------------------
FROM node:14.15.3-stretch AS assets
WORKDIR /app

COPY --from=base /app/deps /app/deps/
COPY assets/package.json ./assets/
RUN npm --prefix ./assets install
RUN npm --prefix ./assets install react react-dom --save
RUN npm --prefix ./assets install @babel/preset-env @babel/preset-react --save-dev

COPY lib ./lib
COPY priv ./priv
COPY assets/ ./assets/

RUN npm run --prefix ./assets deploy

# ---- Build Release Stage -----------------------------------------------------------------
FROM base AS release
WORKDIR /app

# set build ENV
ARG MIX_ENV
ARG RELEASE_ENV
ENV MIX_ENV=${MIX_ENV}
ENV RELEASE_ENV=${RELEASE_ENV}

COPY --from=assets /app/priv ./priv
RUN mix phx.digest
RUN mix do compile, release

# ---- Build Deploy Image Stage -------------------------------------------------------------------
FROM debian:buster-slim AS deploy

# Install stable dependencies that don't change often
RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  apt-utils \
  openssl \
  procps \
  curl \
  inotify-tools \
  wget && \
  rm -rf /var/lib/apt/lists/*

# Set WORKDIR after setting user to nobody so it automatically gets the right permissions
# When the app starts it will need to be able to create a tmp directory in /app
WORKDIR /app

ARG MIX_ENV
ARG RELEASE_ENV

ENV MIX_ENV=${MIX_ENV}
ENV RELEASE_ENV=${RELEASE_ENV}

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# Update timezone
ENV TZ=America/Denver

COPY --from=release /app/_build/${MIX_ENV}/rel/short_url ./

ENV HOME=/app
# Exposes port to the host machine
EXPOSE 4000

CMD ["bin/short_url", "start"]

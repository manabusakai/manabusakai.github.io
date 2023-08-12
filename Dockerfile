ARG RUBY_VERSION

FROM ruby:${RUBY_VERSION}-slim AS builder
WORKDIR /usr/src/resume
COPY Gemfile Gemfile.lock ./
RUN apt-get update && apt-get install -y --no-install-recommends make gcc g++
RUN bundle install && rm -r ${GEM_HOME}/cache/* && find ${GEM_HOME}/gems -name "*.[c,o]" -delete

FROM ruby:${RUBY_VERSION}-slim
RUN apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/*
WORKDIR /usr/src/resume
RUN useradd -m -s /bin/bash jekyll
USER jekyll
COPY --from=builder ${GEM_HOME} ${GEM_HOME}
COPY Gemfile Gemfile.lock ./
RUN bundle check

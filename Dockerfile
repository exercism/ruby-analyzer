FROM ruby:4.0.4-alpine3.23@sha256:ac9c68cd41d6a49a9138fca74aa344968e8ddb5e20d8a3b1f455b97c7148f8da AS build

RUN apk update && apk upgrade && \
    apk add --no-cache git openssh build-base gcc wget git

COPY Gemfile Gemfile.lock ./

RUN gem install bundler:4.0.11 && \
    bundle config set without 'development test' && \
    bundle install

FROM ruby:4.0.4-alpine3.23@sha256:ac9c68cd41d6a49a9138fca74aa344968e8ddb5e20d8a3b1f455b97c7148f8da AS runtime

RUN apk add --no-cache bash

COPY --from=build /usr/local/bundle /usr/local/bundle

WORKDIR /opt/analyzer

COPY . .

ENTRYPOINT ["sh", "/opt/analyzer/bin/run.sh"]

FROM ruby:3.2.2-alpine3.18 AS build

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh && \
    apk add build-base gcc wget git

COPY Gemfile Gemfile.lock .

RUN gem install bundler:2.4.18 && \
    bundle config set without 'development test' && \
    bundle install

FROM ruby:3.2.2-alpine3.18 AS runtime

RUN apk add --no-cache bash

WORKDIR /opt/analyzer

COPY --from=build /usr/local/bundle /usr/local/bundle

COPY . .

ENTRYPOINT ["sh", "/opt/analyzer/bin/run.sh"]

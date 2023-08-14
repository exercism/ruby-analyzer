FROM ruby:3.2.2-alpine3.18 AS build

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh && \
    apk add build-base gcc wget git

RUN gem install bundler -v 2.4.18

WORKDIR /opt/analyzer

COPY . .

RUN bundle install

ENTRYPOINT ["sh", "/opt/analyzer/bin/run.sh"]

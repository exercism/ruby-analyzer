FROM ruby:2.5-alpine

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh && \
    apk add build-base gcc wget git

RUN mkdir /opt/analyzer
COPY . /opt/analyzer
WORKDIR /opt/analyzer
RUN bundle install

FROM ruby:2.5-alpine

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh && \
    apk add build-base gcc wget git

RUN mkdir /opt/analyzer
COPY -r . /opt/analyzer
WORKDIR /opt/analyzer

RUN git clone https://github.com/exercism/ruby-analyzer.git .

RUN git checkout b42a07d9417e058557bff3039547f57fb87ce56e && bundle install >aa

RUN bundle exec ruby manual_test.rb >bb

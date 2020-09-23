FROM ruby:2.5-alpine

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh && \
    apk add build-base gcc wget git

RUN gem install bundler -v 2.1.4

RUN wget -P /usr/local/bin https://github.com/exercism/tooling-webserver/releases/download/0.10.0/tooling_webserver && \
    chmod +x /usr/local/bin/tooling_webserver

WORKDIR /opt/analyzer

COPY . .

RUN bundle install

ENTRYPOINT ["sh", "/opt/analyzer/bin/run.sh"]

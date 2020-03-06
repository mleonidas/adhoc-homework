FROM ruby:2.7.0

WORKDIR /app
ADD . /app


RUN gem install bundler \
      && bundle install

ENTRYPOINT [ "./bin/entrypoint.sh" ]



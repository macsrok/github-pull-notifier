FROM ruby:3.1-alpine
WORKDIR /app
COPY ./* .
RUN gem install bundler && bundle install
COPY crontab /etc/crontabs/root
CMD ["crond", "-f", "-l", "2"]

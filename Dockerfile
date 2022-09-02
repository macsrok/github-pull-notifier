FROM ruby:3.1-alpine
WORKDIR /app
COPY ./* .
RUN gem install bundler && bundle install
CMD [ "ruby" , "github-pull-notifier.rb" ]

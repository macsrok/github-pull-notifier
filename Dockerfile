FROM ruby:3.1-alpine
WORKDIR /app
COPY ./* .
RUN gem install bundler && bundle install
ENTRYPOINT ["sh", "/app/entrypoint.sh"]
CMD [""]

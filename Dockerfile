FROM ruby:3.1-alpine
WORKDIR /app
COPY ./* ./
RUN apk add --no-cache alpine-conf && setup-timezone -z America/Chicago
RUN gem install bundler && bundle install
ENTRYPOINT ["sh", "/app/entrypoint.sh"]
CMD [""]

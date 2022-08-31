FROM ruby:2.7.3
RUN apt-get update -qq && apt-get install -y postgresql-client



WORKDIR /app
# COPY . /app/

# RUN mkdir -p /app/vendor
# COPY /vendor/erp-data-sync-0.1.4.gem /app/vendor

ENV RAILS_ENV=production

# COPY erp-data-sync-0.1.4.gem /app

ARG GITHUB_TOKEN

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN git clone https://volo-h:"${GITHUB_TOKEN}"@github.com/volo-h/erp-data-sync.git


RUN bundle install

# RUN bundle config set without development test
# RUN bundle config set rubygems.pkg.github.com volo-h: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

COPY . /app

EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]

# Add a script to be executed every time the container starts.
# COPY entrypoint.sh /usr/bin/
# RUN chmod +x /usr/bin/entrypoint.sh
# ENTRYPOINT ["entrypoint.sh"]
# EXPOSE 3000

# # Start the main process.
# CMD ["rails", "server", "-b", "0.0.0.0"]


# FROM ruby:2.7.3-alpine AS gems_installer

# RUN apk add --update --no-cache \
#     build-base \
#     postgresql-dev \
#     git \
#     nodejs \
#     imagemagick \
#     tzdata \
#     shared-mime-info

# ARG RAILS_ENV=production
# ENV RAILS_ENV $RAILS_ENV
# RUN gem update bundler

# ARG GITHUB_USER
# ARG GITHUB_SECRET_TOKEN

# RUN bundle config set without development test
# RUN bundle config set rubygems.pkg.github.com $GITHUB_USER:$GITHUB_SECRET_TOKEN

# WORKDIR /app

# # Install gems
# ADD Gemfile* /app/
# RUN bundle config --global frozen 1  --development \
#  && bundle install -j4 --retry 3 \
#  # Remove unneeded files (cached *.gem, *.o, *.c)
#  && rm -rf /usr/local/bundle/cache/*.gem \
#  && find /usr/local/bundle/gems/ -name "*.c" -delete \
#  && find /usr/local/bundle/gems/ -name "*.o" -delete

# FROM gems_installer AS main_application

# ADD . /app
# RUN mkdir -p tmp/pids tmp/sockets tmp/sessions

# EXPOSE 3000

# ENTRYPOINT ["bundle", "exec", "rails"]

# CMD ["server"]




# bundle config
# bundle config unset path

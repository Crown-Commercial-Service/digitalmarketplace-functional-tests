# docker run --rm \
#    -v $(pwd):/app \
#    -e DM_API_DOMAIN \
#    -e ...
#    -e ...
#    digitalmarketplace/functional-tests make smoke-tests
FROM ruby:2.6-stretch

WORKDIR /app

# Install Chromium
RUN apt-get -y update \
    && apt-get -y install chromium \
	&& apt-get -y clean \
	&& rm -rf /var/lib/apt/lists/*

# Update bundler
RUN gem install bundler

# Install functional tests requirements
COPY Gemfile Gemfile.lock ./
RUN bundle install --deployment --path $BUNDLE_PATH

CMD ["make", "run"]

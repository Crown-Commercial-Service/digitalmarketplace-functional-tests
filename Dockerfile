# docker run --rm \
#    -v $(pwd):/app \
#    -e DM_API_DOMAIN \
#    -e ...
#    -e ...
#    digitalmarketplace/functional-tests make smoke-tests
FROM ruby:2.6

WORKDIR /app

# Tell the webdrivers gem to install webdrivers somewhere global
ENV WD_INSTALL_DIR /webdrivers
RUN mkdir -p /webdrivers && chmod 777 /webdrivers

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

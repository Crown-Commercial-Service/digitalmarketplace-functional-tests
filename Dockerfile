FROM ruby:2.6-stretch

# Install Chromium
RUN apt-get -y update && apt-get -y install \
		chromium \
	&& apt-get -y clean \
	&& rm -rf /var/lib/apt/lists/*

# Add a user for running our functional tests
RUN groupadd --gid 1001 functional-tests \
	&& useradd --uid 998 --gid functional-tests --groups audio,video --create-home functional-tests

USER functional-tests
WORKDIR /usr/src/app

# Update bundler
RUN gem install bundler

# Install functional tests requirements
COPY Gemfile Gemfile.lock ./
RUN bundle install --deployment --path $BUNDLE_PATH

CMD ["make", "run"]

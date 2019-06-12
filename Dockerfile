FROM ruby:2.6-stretch

# Install Chromium and ChromeDriver
RUN apt-get -y update && apt-get -y install \
		chromium \
		chromium-driver \
	&& apt-get -y clean \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

# Install functional tests requirements
COPY Gemfile Gemfile.lock Makefile ./
RUN make install

CMD ["make", "run"]

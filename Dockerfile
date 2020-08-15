# This Ruby is based on the Debian distrubution.
FROM ruby:2.6

LABEL maintainer="jianmin.xu@usingnow.com"

# Update packages and install necessary packages for Rails
RUN sed -i 's#http://deb.debian.org#http://mirrors.aliyun.com#g;s#http://security.debian.org#http://mirrors.aliyun.com#g' /etc/apt/sources.list
RUN apt-get update -yqq && apt-get upgrade -yqq
RUN apt-get install -yqq --no-install-recommends \
      apt-transport-https \
      build-essential \
      curl \
      gawk \
      autoconf \
      automake \
      bison \
      libffi-dev \
      libgdbm-dev \
      libncurses5-dev \
      libsqlite3-dev \
      libtool \
      libyaml-dev \
      pkg-config \
      zlib1g-dev \
      libgmp-dev \
      libreadline-dev \
      libssl-dev

# Install node.js and Yarn for webpacker.
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
  nodejs \
  yarn

COPY Gemfile* /usr/src/app/
WORKDIR /usr/src/app
RUN bundle config mirror.https://rubygems.org https://gems.ruby-china.com && bundle install

COPY . /usr/src/app/

CMD ["bin/rails", "s", "-b", "0.0.0.0"]
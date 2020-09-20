FROM ruby:2.7.0

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN gem install bundler --version 2.1.4
RUN npm install -g yarn

WORKDIR /economias
COPY . /economias/

RUN bundle update
RUN bundle install
RUN yarn install --check-files

COPY Gemfile.lock package.json yarn.lock /economias/

COPY . /economias

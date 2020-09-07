FROM ruby:2.7.0

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN gem install bundler --version 2.1.4
RUN npm install -g yarn
# RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
# RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

WORKDIR /economias
COPY e /economias/

RUN bundle update
RUN bundle install
RUN yarn install --check-files

# COPY Gemfile.lock /economias
# COPY package.json /economias
# COPY yarn.lock /economias

COPY Gemfile.lock package.json /economias/

COPY . /economias

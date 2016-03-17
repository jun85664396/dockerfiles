FROM seapy/ruby:2.2.0
MAINTAINER SangPil Jun <jun85664396@gmail.com>

RUN apt-get update

# Install nodejs
RUN apt-get install -qq -y nodejs

# Intall software-properties-common for add-apt-repository
RUN apt-get install -qq -y software-properties-common

# Install Nginx.
RUN add-apt-repository -y ppa:nginx/stable
RUN apt-get update
RUN apt-get install -qq -y nginx
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf
RUN chown -R www-data:www-data /var/lib/nginx

# Install Mysql (for mysql)
RUN apt-get install -qq -y libmysqlclient-dev

# Install Jdk (for rjb)
RUN apt-get install -qq -y openjdk-7-jdk
ENV JAVA_HOME "/usr/lib/jvm/java-7-openjdk-amd64"

# Add default nginx config
ADD nginx-sites.conf /etc/nginx/sites-enabled/default

# Rails
WORKDIR /app
ONBUILD ADD Gemfile /app/Gemfile
ONBUILD ADD Gemfile.lock /app/Gemfile.lock
ONBUILD RUN bundle install --without development test
ONBUILD ADD . /app
ONBUILD RUN bundle exec rake assets:precompile RDB_URL="mysql://buildtest:buildtest@localhost/buildtest" RAILS_ENV=production

# Add default unicorn config
ADD unicorn.rb /app/config/unicorn.rb

ENV RAILS_ENV production

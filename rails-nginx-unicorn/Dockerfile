FROM node:8.9.4 AS nodejs
FROM openjdk:9-jdk AS openjdk
FROM ruby:2.5.0
MAINTAINER SangPil Jun <jun85664396@gmail.com>

RUN apt-get update

# Install nodejs
COPY --from=nodejs /usr/local/bin/node /bin/

# Install Nginx.
RUN apt-get update
RUN apt-get install -qq -y nginx
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf
RUN chown -R www-data:www-data /var/lib/nginx

# Install Mysql (for mysql)
#RUN apt-get install -qq -y libmysqlclient-dev

# Install Jdk (for rjb)
COPY --from=openjdk /docker-java-home /docker-java-home
ENV JAVA_HOME "/docker-java-home"

# Add default nginx config
ADD nginx-sites.conf /etc/nginx/sites-enabled/default

#RUN locale-gen en_US.UTF-8
RUN echo 'LC_ALL=en_US.UTF-8' > /etc/default/locale
RUN echo 'LANG=en_US.UTF-8' >> /etc/default/locale

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

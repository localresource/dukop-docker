FROM ruby
RUN apt-get update && \
    apt-get install -y locales && \
    locale-gen C.UTF-8 && \
    /usr/sbin/update-locale LANG=C.UTF-8 && \
    apt-get remove -y locales
ENV LANG C.UTF-8
# simple-captcha2 depends on ghostscript
RUN apt-get install -y ghostscript
RUN apt-get install -y postgresql-client
WORKDIR /myapp
COPY conf/Gemfile /myapp/Gemfile
COPY conf/Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
COPY my-entrypoint.sh /my-entrypoint.sh
CMD ["/my-entrypoint.sh"]

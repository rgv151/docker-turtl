## -*- docker-image-name: "clma/docker-turtl" -*-
#
# turtl.it unofficial API Dockerfile
#

FROM alpine:edge
MAINTAINER Huy Doan <me@huy.im>

RUN mkdir /quicklisp /data

RUN apk add --update --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted sbcl libuv git && rm -rf /var/cache/apk/*

RUN wget -qO/tmp/quicklisp.lisp http://beta.quicklisp.org/quicklisp.lisp
RUN echo "(quicklisp-quickstart:install :path \"/quicklisp/\")" | sbcl --load /tmp/quicklisp.lisp
RUN rm /tmp/quicklisp.lisp

RUN git clone --depth=1 https://github.com/turtl/api.git /turtl

RUN echo '(load "/quicklisp/setup.lisp")\n(push #p"/turtl/" asdf:*central-registry*)\n(load "start")' > /turtl/cmd.args
RUN echo '/usr/bin/sbcl < /turtl/cmd.args' > /turtl/run.sh

VOLUME ["/turtl/config", "/data"]

WORKDIR /turtl

EXPOSE 8181

CMD ["/bin/ash" , "/turtl/run.sh"]

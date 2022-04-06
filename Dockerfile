FROM alpine

RUN apk add --update --no-cache git dcron rsyslog netcat-openbsd curl python2 gnupg
RUN python -m ensurepip --upgrade

RUN curl http://cgit.legato/external/repo.git/plain/repo > repo
RUN chmod +x repo
RUN mv repo /usr/local/bin/

ADD entrypoint.sh /
ADD update.sh /

ENV VOLUME_PATH /repo
VOLUME ["/repo"]

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 10000

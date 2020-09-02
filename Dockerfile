FROM alpine:3.12.0

RUN apk add --no-cache bash git python3 py3-sphinx make

WORKDIR /app

CMD tail -f /dev/null
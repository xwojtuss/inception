FROM alpine:3.21.2

RUN apk update && apk add netdata

EXPOSE 19999

CMD ["netdata", "-D"]
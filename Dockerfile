FROM alpine:3.11 AS builder

RUN apk --no-cache add python3
RUN python3 -m venv /app

COPY requirements.txt /requirements.txt
RUN /app/bin/pip install -r requirements.txt aionotify

COPY setup.py /src/setup.py
COPY hpfeeds /src/hpfeeds
RUN /app/bin/pip install /src


FROM alpine:3.11

RUN apk --no-cache add sqlite python3

COPY --from=builder /app /app

RUN mkdir /app/var
WORKDIR /app/var
VOLUME /app/var

EXPOSE 10000/tcp
EXPOSE 9431/tcp

CMD "/app/run/entrypoint.sh"

FROM alpine:latest AS novnc-assets
RUN apk add --no-cache novnc

FROM python:alpine
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1
RUN apk upgrade --no-cache \
    && apk add --no-cache \
        chromium \
        xvfb \
        openbox \
        x11vnc \
        xdotool \
        tzdata
COPY --from=novnc-assets /usr/share/novnc/ /usr/share/novnc/
RUN addgroup -g 10001 -S tdm-browser \
    && adduser -u 10001 -S -D -H -h /nonexistent -s /sbin/nologin -G tdm-browser tdm-browser
FROM python:3-alpine AS build
RUN apk update && apk add --no-cache rust cargo alpine-sdk
WORKDIR /build
RUN pip wheel uvloop watchfiles httptools --wheel-dir /wheels

FROM python:3-alpine
COPY --from=build /wheels/*.whl /tmp/wheels/
RUN pip install --no-cache-dir /tmp/wheels/*.whl
RUN rm -rf /tmp/wheels/

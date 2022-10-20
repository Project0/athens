# Use by goreleaser
ARG GOLANG_VERSION=1.18
ARG ALPINE_VERSION=3.15

FROM golang:${GOLANG_VERSION}-alpine AS builder

FROM alpine:${ALPINE_VERSION}

ENV GO111MODULE=on
COPY --from=builder /usr/local/go/bin/go /bin/go

COPY athens /bin/athens-proxy
COPY config.dev.toml /config/config.toml

RUN apk add --no-cache --update git git-lfs mercurial openssh-client subversion procps fossil tini && \
		mkdir -p /usr/local/go && \
		chmod 644 /config/config.toml

# Add tini, see https://github.com/gomods/athens/issues/1155 for details.
EXPOSE 3000

ENTRYPOINT [ "/sbin/tini", "--" ]

CMD ["athens-proxy", "-config_file=/config/config.toml"]

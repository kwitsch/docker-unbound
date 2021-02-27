FROM alpine:3.13.2 AS install
RUN apk add --no-cache unbound drill

FROM install AS copy
WORKDIR /app
COPY . .
ADD https://www.internic.net/domain/named.root ./data/root.hints

FROM copy
LABEL org.label-schema.name="unbound"
LABEL org.label-schema.vendor="Kwitsch"
LABEL org.label-schema.vcs-url="https://github.com/kwitsch/docker-unbound"
LABEL org.label-schema.rkt.params="HEALTHCHECK_PORT=integer portnumber for healthcheck(Default: 53),HEALTHCHECK_URL=string url for healtcheck(Default: docker.com)"

EXPOSE 53/TCP
EXPOSE 53/UDP

ENV HEALTHCHECK_PORT=53
ENV HEALTHCHECK_URL="docker.com"

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD [ "./healthcheck.sh" ]
ENTRYPOINT ["./entrypoint.sh"]
CMD ["unbound", "-v"]
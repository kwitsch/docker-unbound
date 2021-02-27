FROM alpine:3.13.2 AS install
WORKDIR /app
RUN apk add --no-cache unbound drill ; \
    mkdir config ; \
    mkdir data ; \
    rm /etc/unbound/root.hints ; \
    rm /etc/unbound/unbound.conf
ADD https://www.internic.net/domain/named.root ./data/root.hints

FROM install AS copy
WORKDIR /app
COPY entrypoint.sh .
COPY healthcheck.sh .
COPY unbound.conf ./config/
RUN chmod +x ./entrypoint.sh ; \
    chmod +x ./healthcheck.sh ; \
    chown unbound ./data/root.hints ; \
    ln ./data/root.hints /etc/unbound/root.hints ; \
    ln ./config/unbound.conf /etc/unbound/unbound.conf

FROM copy
LABEL org.label-schema.name="unbound"
LABEL org.label-schema.vendor="Kwitsch"
LABEL org.label-schema.vcs-url="https://github.com/kwitsch/docker-unbound"
LABEL org.label-schema.rkt.params="HEALTHCHECK_PORT=integer portnumber for healthcheck(Default: 53),HEALTHCHECK_URL=string url for healtcheck(Default: docker.com)"

EXPOSE 53/TCP
EXPOSE 53/UDP

ENV HEALTHCHECK_PORT=53
ENV HEALTHCHECK_URL="docker.com"
ENV HEALTHCHECK_ENABLED=False

# HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD [ "./healthcheck.sh" ]
ENTRYPOINT ["./entrypoint.sh"]
CMD ["unbound"]
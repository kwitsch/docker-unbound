FROM alpine:3.13.2 AS build
WORKDIR /app
RUN apk add --no-cache unbound drill ; \
    mkdir config ; \
    mkdir data ; \
    rm /etc/unbound/root.hints ; \
    rm /etc/unbound/unbound.conf ; \
    cp /usr/share/dnssec-root/trusted-key.key ./data/root.key
COPY *.sh .
COPY unbound.conf ./config/
RUN chmod +x ./entrypoint.sh ; \
    chmod +x ./healthcheck.sh ; \
    ln ./config/unbound.conf /etc/unbound/unbound.conf

FROM build
LABEL org.label-schema.name="unbound"
LABEL org.label-schema.vendor="kwitsch"
LABEL org.label-schema.vcs-url="https://github.com/kwitsch/docker-unbound"
LABEL org.label-schema.rkt.params="HEALTHCHECK_PORT=integer portnumber for healthcheck(Default: 53), \
                                   HEALTHCHECK_URL=string url for healtcheck(Default: docker.com), \
                                   BOOTSTRAP_DNS=string dns server for root.hints download(Default: 208.67.222.222)"

EXPOSE 53/TCP
EXPOSE 53/UDP

ENV HEALTHCHECK_PORT=53
ENV HEALTHCHECK_URL="docker.com"
ENV BOOTSTRAP_DNS="208.67.222.222"

HEALTHCHECK --interval=30s --timeout=30s --start-period=30s --retries=3 CMD [ "sh", "./healthcheck.sh" ]
ENTRYPOINT ["./entrypoint.sh"]
CMD ["unbound"]
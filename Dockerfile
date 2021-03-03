FROM alpine:3.12.4 AS prepare
WORKDIR /app
RUN apk add --no-cache unbound drill ; \
    rm /etc/unbound/unbound.conf ; \
    mkdir data ; \
    mkdir config ; \
    mkdir config/conf.d ; \
    mv /etc/unbound/root.hints ./data/bootstrap.hints; \
    mv /usr/share/dnssec-root/trusted-key.key ./data/root.key

FROM prepare AS copy
COPY . .
RUN chmod +x entrypoint.sh ; \
    chmod +x healthcheck.sh ; \
    mv *.conf config/

FROM copy
LABEL org.label-schema.name="unbound"
LABEL org.label-schema.vendor="kwitsch"
LABEL org.label-schema.vcs-url="https://github.com/kwitsch/docker-unbound"
LABEL org.label-schema.rkt.params="HEALTHCHECK_URL=string url for healtcheck(Default: internic.net)"

EXPOSE 53/TCP
EXPOSE 53/UDP

ENV HEALTHCHECK_URL="internic.net"

HEALTHCHECK --interval=30s --timeout=30s --start-period=30s --retries=3 CMD [ "sh", "./healthcheck.sh" ]
ENTRYPOINT ["./entrypoint.sh"]
CMD ["unbound"]
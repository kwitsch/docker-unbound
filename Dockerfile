FROM alpine:3.12.4 AS prepare
WORKDIR /app
RUN apk add --no-cache unbound drill ; \
    rm /etc/unbound/unbound.conf ; \
    mkdir data ; \
    mkdir config ; \
    mkdir config/conf.d ; \
    mv /usr/share/dnssec-root/trusted-key.key ./data/root.key ; \
    unbound-anchor -4 -v -a ./data/root.key

FROM prepare AS copy
COPY *.conf ./config/
COPY *.sh .
ADD https://www.internic.net/domain/named.root ./data/root.hints
RUN chmod +x entrypoint.sh ; \
    chmod +x healthcheck.sh ; \
    ln ./config/unbound.conf /etc/unbound/unbound.conf ; \
    chown unbound ./data -R ; \
    chgrp unbound ./data -R

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
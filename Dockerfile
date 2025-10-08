FROM debian:bookworm-slim
ARG SIPP_VERSION=3.7.5
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
	&& apt-get install -y --no-install-recommends ca-certificates wget sox \
	&& wget https://github.com/SIPp/sipp/releases/download/v${SIPP_VERSION}/sipp -O /usr/bin/sipp \
    && chmod 755 /usr/bin/sipp \
    && mkdir /opt/sipp

WORKDIR /opt/sipp

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

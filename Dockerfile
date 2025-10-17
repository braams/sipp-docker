FROM alpine:3.22 AS build

#ARG SIPP_REPO=https://github.com/SIPp/sipp.git
#ARG SIPP_VERSION=v3.7.5

ARG SIPP_REPO=https://github.com/braams/sipp.git
ARG SIPP_VERSION=rand-call-id

ARG FULL=''
ARG DEBUG=''

RUN apk add --no-cache \
  binutils \
  cmake \
  g++ \
  gcc \
  git \
  gsl-dev \
  gsl-static \
  help2man \
  libpcap-dev \
  make \
  ncurses-dev \
  ncurses-static \
  ninja \
  ${FULL:+linux-headers lksctp-tools-dev lksctp-tools-static openssl-dev openssl-libs-static}

RUN git clone --branch ${SIPP_VERSION} --depth 1 ${SIPP_REPO} \
  && cd sipp \
  && git submodule update --init

RUN cd sipp \
  && cmake . -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_STATIC=1 \
    -DUSE_PCAP=1 \
    -DUSE_GSL=1 \
    ${DEBUG:+-DDEBUG=1} \
    ${FULL:+-DUSE_SSL=1 -DUSE_SCTP=1} \
  && ninja \
  && help2man --output=sipp.1 -v -v --no-info \
         --name='SIP testing tool and traffic generator' ./sipp

FROM alpine:3.22 AS final

COPY --from=build /sipp/sipp /

RUN apk add ncurses

ENTRYPOINT ["/sipp", "-cid_str", "%r-%u-%p@%s"]

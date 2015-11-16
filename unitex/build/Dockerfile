FROM ubuntu:14.04
MAINTAINER John DOE "nospam@noway.nowhere"

ENV REFRESHED_AT 2015-02-12

RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl

RUN mkdir /soft

ADD builddir /soft

WORKDIR /soft

VOLUME /soft
VOLUME /corpus

ENTRYPOINT ["/soft/unitex.sh"]

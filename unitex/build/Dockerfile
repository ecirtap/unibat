FROM ubuntu:14.04
MAINTAINER John DOE "nospam@noway.nowhere"

ENV REFRESHED_AT 2015-02-12

RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl

RUN apt-get -qqy update && apt-get install openjdk-7-jre -qqy

RUN mkdir /soft

ADD builddir /soft

WORKDIR /soft

ENTRYPOINT ["/soft/unitex.sh"]

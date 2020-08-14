FROM debian:buster

# Add prerequisites
RUN apt-get update && \
  apt-get install -y gnupg2 wget lsb-release git nano && \
  wget -O - https://files.freeswitch.org/repo/deb/debian-release/fsstretch-archive-keyring.asc | apt-key add - && \
  echo "deb http://files.freeswitch.org/repo/deb/debian-release/ buster main" > /etc/apt/sources.list.d/freeswitch.list && \
  echo "deb-src http://files.freeswitch.org/repo/deb/debian-release/ buster main" >> /etc/apt/sources.list.d/freeswitch.list && \
  apt-get update

# Install FreeSWITCH's build dependencies core
RUN apt-get build-dep -y freeswitch

# Pull latest master
RUN mkdir -p /usr/src && \
  cd /usr/src && \
  git clone https://github.com/signalwire/freeswitch.git

# Build and install FreeSWITCH!
RUN cd /usr/src/freeswitch && \
  ./bootstrap.sh -j && \
  ./configure && \
  make && \
  make install

WORKDIR /usr/src/freeswitch

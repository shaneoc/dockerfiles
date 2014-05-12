FROM ubuntu

# Install packages
RUN apt-get update
RUN apt-get -y dist-upgrade
RUN apt-get -y install git lighttpd build-essential libzip-dev libssl-dev

# Build cgit
RUN mkdir -p /opt/cgit/src
ADD cgit-0.10.1.tar.xz /opt/cgit/src/
ADD git-1.9.0.tar.gz /opt/cgit/src/
RUN rm -rf /opt/cgit/src/cgit-0.10.1/git
RUN mv /opt/cgit/src/git-1.9.0 /opt/cgit/src/cgit-0.10.1/git
RUN cd /opt/cgit/src/cgit-0.10.1 && make install
ADD cgitrc /etc/
RUN chmod 644 /etc/cgitrc

# Add git volume
RUN mkdir /git
#! run-arg: -v /home/shane/git:/git:ro

# Configure lighttpd
ADD lighttpd.conf /etc/lighttpd/
EXPOSE 80
CMD /usr/sbin/lighttpd -f /etc/lighttpd/lighttpd.conf -D

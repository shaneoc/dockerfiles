# This image expects the following volumes to be mounted:
#   /git: contains git repositories

FROM ubuntu

# Install packages
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install git lighttpd \
    build-essential libzip-dev libssl-dev

# Build cgit
RUN mkdir -p /opt/cgit/src
ADD cgit-0.10.1.tar.xz /opt/cgit/src/
ADD git-1.9.0.tar.gz /opt/cgit/src/
RUN rm -rf /opt/cgit/src/cgit-0.10.1/git
RUN mv /opt/cgit/src/git-1.9.0 /opt/cgit/src/cgit-0.10.1/git
RUN cd /opt/cgit/src/cgit-0.10.1 && make install
ADD cgitrc /etc/
RUN chmod 644 /etc/cgitrc

# Configure lighttpd
ADD lighttpd.conf /etc/lighttpd/

# Copy start script
ADD start.sh /
RUN chown root.root /start.sh
RUN chmod 700 /start.sh

EXPOSE 80
ENTRYPOINT ["/start.sh"]

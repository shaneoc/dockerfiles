FROM ubuntu

# Install packages
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install samba

# Copy start script
ADD start.sh /start.sh
RUN chown root.root /start.sh
RUN chmod 700 /start.sh

ENTRYPOINT ["/start.sh"]

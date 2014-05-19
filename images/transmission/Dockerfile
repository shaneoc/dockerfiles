FROM ubuntu

# Install packages
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install transmission-daemon

# Let transmission use port 80
# RUN setcap cap_net_bind_service+ep /usr/bin/transmission-daemon

# Copy settings file
ADD settings.json /settings.json

# Copy start script
ADD start.sh /start.sh
RUN chown root.root /start.sh
RUN chmod 700 /start.sh

EXPOSE 9091
EXPOSE 56841
ENTRYPOINT ["/start.sh"]

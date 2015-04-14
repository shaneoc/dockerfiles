# This image expects the following volumes to be mounted:
#   /cfg: contains stunnel config file and key

FROM ubuntu

# Install packages
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install stunnel4

# Copy start script
ADD start.sh /
RUN chown root.root /start.sh
RUN chmod 700 /start.sh

EXPOSE 443
ENTRYPOINT ["/start.sh"]

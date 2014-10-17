FROM ubuntu

# Install packages
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install python-pip
RUN pip install six>=1.7.0
RUN pip install flexget==1.2
RUN pip install transmissionrpc

# Create user
RUN useradd --create-home flexget

# Copy start script
ADD start.sh /start.sh
RUN chown root.root /start.sh
RUN chmod 700 /start.sh

ENTRYPOINT ["/start.sh"]

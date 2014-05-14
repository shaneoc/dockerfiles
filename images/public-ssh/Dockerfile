FROM ubuntu

# Install packages
RUN apt-get update
RUN apt-get -y dist-upgrade
RUN apt-get -y install ssh

# Copy SSH config
ADD ssh /etc/ssh
RUN chown -R root.root /etc/ssh
RUN chmod 755 /etc/ssh
RUN chmod 644 /etc/ssh/*

# Create directory that SSH needs
RUN mkdir /var/run/sshd

# Copy start script
ADD start.sh /
RUN chown root.root /start.sh
RUN chmod 700 /start.sh

EXPOSE 22
ENTRYPOINT ["/start.sh"]

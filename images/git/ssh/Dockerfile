# This image expects the following volumes to be mounted:
#   /cfg: contains host keys and user public key
#   /git: contains git repositories

FROM ubuntu

# Install packages
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install ssh git

# Copy SSH config
ADD ssh /etc/ssh
RUN chown -R root.root /etc/ssh
RUN chmod 755 /etc/ssh
RUN chmod 644 /etc/ssh/*

# Create directory that SSH needs
RUN mkdir /var/run/sshd

# Copy git shell commands
ADD git-shell-commands /git-shell-commands

# Copy start script
ADD start.sh /
RUN chown root.root /start.sh
RUN chmod 700 /start.sh

EXPOSE 22
ENTRYPOINT ["/start.sh"]

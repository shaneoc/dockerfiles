FROM ubuntu

# Install packages
RUN apt-get update
RUN apt-get -y dist-upgrade
RUN apt-get -y install ssh git

# Create user
RUN useradd --create-home --shell /usr/bin/git-shell shane

# Set up SSH
RUN mkdir /home/shane/.ssh
RUN chown shane.shane /home/shane/.ssh
RUN chmod 700 /home/shane/.ssh

#! cp-secret: ssh/id_rsa.pub
ADD id_rsa.pub /home/shane/.ssh/authorized_keys
RUN chown shane.shane /home/shane/.ssh/*
RUN chmod 600 /home/shane/.ssh/*

#! cp-secret: ssh/git-host-key/* ssh/
ADD ssh /etc/ssh
RUN chown -R root.root /etc/ssh
RUN chmod -R o-rwx /etc/ssh
RUN mkdir /var/run/sshd

# Set up git
#! run-arg: -v /home/shane/git:/git:rw
RUN mkdir /git
RUN chown shane.shane /git
RUN chmod 755 /git
ADD git-shell-commands /home/shane/git-shell-commands
RUN chown -R shane.shane /home/shane/git-shell-commands
RUN chmod 755 /home/shane/git-shell-commands/*

EXPOSE 22
CMD /usr/sbin/sshd -D

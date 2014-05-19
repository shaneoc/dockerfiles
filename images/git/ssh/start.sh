#!/bin/bash

host_keys="
        moduli
        ssh_host_dsa_key
        ssh_host_dsa_key.pub
        ssh_host_ecdsa_key
        ssh_host_ecdsa_key.pub
        ssh_host_ed25519_key
        ssh_host_ed25519_key.pub
        ssh_host_rsa_key
        ssh_host_rsa_key.pub
"

# Check for errors
if [ $# -ne 2 ]; then
    echo "Error: you need to specify the uid and gid for the git user"
    exit 1
fi


for file in authorized_keys $host_keys; do
    if ! [ -e "/cfg/$file" ]; then
        echo "Error: file /cfg/$file is missing"
        exit 1
    fi
done

if touch /cfg/test.file 2>/dev/null; then
    echo "Error: /cfg should be mounted read-only"
    exit 1
fi

if ! [ -d /git ]; then
    echo "Error: /git should be mounted as a volume"
    exit 1
fi

if ! [ -e "/config.done" ]; then
    # Add host keys
    # TODO: copying them like this leaves them readable in the /cfg location by
    # the unprivileged user. Do this better somehow (maybe load it from a URL?),
    # or even better, reference the /cfg location from sshd_config and require
    # the user to set the permissions properly
    for file in $host_keys; do
        install -o root -g root -m 600 /cfg/$file /etc/ssh/
    done

    # Create git user
    uid="$1"
    gid="$2"
    groupadd -g "$gid" --non-unique git
    useradd -u "$uid" -g "$gid" --non-unique --no-user-group \
        --create-home --shell /usr/bin/git-shell git
    inst="install -o git -g git"

    # Add user authorized_keys
    $inst -m 700 -d /home/git/.ssh
    $inst -m 600 /cfg/authorized_keys /home/git/.ssh/

    # Add git-shell commands
    $inst -m 755 -d /home/git/git-shell-commands
    $inst -m 755 /git-shell-commands/* /home/git/git-shell-commands/

    touch ~/config.done
fi

exec /usr/sbin/sshd -D

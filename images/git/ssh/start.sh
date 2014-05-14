#!/bin/bash

if ! [ -e "/config.done" ]; then
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
    if [ $# -ne 1 ]; then
        echo "Error: you need to specify the username"
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

    # Add host keys
    # TODO: copying them like this leaves them readable in the /cfg location by
    # the shane user. Do this better somehow (maybe load it from a URL?)
    for file in $host_keys; do
        install -o root -g root -m 600 /cfg/$file /etc/ssh/
    done

    # Create user (using git-shell as shell)
    username="$1"
    useradd --create-home --shell /usr/bin/git-shell "$username"
    inst="install -o $username -g $username"

    # Add user authorized_keys
    $inst -m 700 -d /home/$username/.ssh
    $inst -m 600 /cfg/authorized_keys /home/$username/.ssh/

    # Add git-shell commands
    $inst -m 755 -d /home/$username/git-shell-commands
    $inst -m 755 /git-shell-commands/* /home/$username/git-shell-commands/

    touch ~/config.done
fi

exec /usr/sbin/sshd -D

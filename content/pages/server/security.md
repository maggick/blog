Title: Security
Status: hidden

On a server security is really important.
Some simple change can make a great gain in security.

## ssh

I choose an other port than 22 standard port for my ssh server.
Moreover I just let one user log in with his sshkey (no root, no password
allowed).

And finaly I have improve the security of my ssh private key file by changing
the encryption of the passphrase to
[PKCS#8](http://en.wikipedia.org/wiki/PKCS#8) following [this
article](http://martin.kleppmann.com/2013/05/24/improving-security-of-ssh-private-keys.html)
in resume there is a few manipulation:

    mv ~/.ssh/id_rsa ~/.ssh/id_rsa.old
    openssl pkcs8 -topk8 -v2 des3 -in ~/.ssh/id_rsa.old -out ~/.ssh/id_rsa
    chmod 600 ~/.ssh/id_rsa
    # Check that the converted key works; if yes, delete the old one:
    rm ~/.ssh/id_rsa.old

## Ip Tables - Firewall

It is important to filtre what come in and come out of a server.
Here is an exemple of IPTables that allow only ssh input on port 222 and ssh
output on port 22:
BE CAREFUL do not use this script without modifing the ssh port otherwise you
may loose the control over you server.

    #!/bin/sh

    # drop actual table
    iptables -t filter -F

    # drop personnal table
    iptables -t filter -X

    # deny all access
    iptables -t filter -P INPUT DROP
    iptables -t filter -P FORWARD DROP
    iptables -t filter -P OUTPUT DROP

    # do not break established connexions
    iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
    iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

    # loopback
    iptables -t filter -A INPUT -i lo -j ACCEPT
    iptables -t filter -A OUTPUT -o lo -j ACCEPT

    # ICMP (Ping)
    iptables -t filter -A INPUT -p icmp -j ACCEPT
    iptables -t filter -A OUTPUT -p icmp -j ACCEPT

    # SSH In/out
    iptables -t filter -A INPUT -p tcp --dport 222 -j ACCEPT
    iptables -t filter -A OUTPUT -p tcp --dport 22 -j ACCEPT


[source](http://www.alsacreations.com/tuto/lire/622-Securite-firewall-iptables.html)
(in French)


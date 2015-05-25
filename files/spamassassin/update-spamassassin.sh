#!/bin/bash

#/usr/bin/sa-update --channelfile /etc/spamassassin/channels.text --gpgkey 856AA88
#/usr/bin/sa-update --channelfile /etc/spamassassin/channels.text --gpgkey D1C035168C1EBC08464946DA258CDB3ABDE9DC10
/usr/bin/sa-update --channelfile /etc/spamassassin/channels.text --gpgkeyfile /etc/spamassassin/keys.text -D
/etc/init.d/spamassassin reload

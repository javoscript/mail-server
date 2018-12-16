#!/bin/sh

# Configuration for the script
POSTFIX_CONFIG=/overrides/postfix.cf
POSTFIX_SASL=/etc/postfix/sasl_passwd

# Set a safe umask
umask 077

# Add the relay host params
cat >> $POSTFIX_CONFIG << EOF
smtp_tls_security_level = encrypt
smtp_sasl_auth_enable = yes
smtp_sasl_password_maps = hash:$POSTFIX_SASL
smtp_sasl_security_options = noanonymous
EOF

# Remove old
rm -f $POSTFIX_SASL

# Create new
cat > $POSTFIX_SASL << EOF
$RELAYHOST $RELAY_LOGIN:$RELAY_PASSWORD
EOF

chmod 600 $POSTFIX_SASL
postmap $POSTFIX_SASL

# Reload Postfix
postfix reload

#!/usr/bin/env sh

rippledconfig=`/bin/cat /config/rippled.cfg 2>/dev/null | wc -l`
validatorstxt=`/bin/cat /config/validators.txt 2>/dev/null | wc -l`

mkdir -p /config

if [[ "$rippledconfig" -gt "0" && "$validatorstxt" -gt "0" ]]; then

    echo "Existing rippled config at host /config/, using them."

    /bin/cat /config/rippled.cfg > /etc/opt/ripple/rippled.cfg
    /bin/cat /config/validators.txt > /etc/opt/ripple/validators.txt

fi

# Start rippled, Passthrough other arguments
exec /opt/ripple/bin/rippled --conf /etc/opt/ripple/rippled.cfg "$@"

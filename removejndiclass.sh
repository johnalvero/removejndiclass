#!/bin/bash

rm /tmp/remove
echo "Looking for vulnerable jars"

find / 2>/dev/null -regex ".*.jar" -type f | xargs -I{} grep -H JndiLookup.class "{}" | cut -d' ' -f3  > /tmp/remove


if [ -s /tmp/remove ]; then 
        cat /tmp/remove
        read -p "Remove JndiClass from above files? " -n 1 -r
        echo    # (optional) move to a new line
        if [[ ! $REPLY =~ ^[Yy]$ ]]
        then
                cat /tmp/remove | while read line
                do
                        zip -q -d  $line org/apache/logging/log4j/core/lookup/JndiLookup.class
                done
                [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
        fi

else
        echo "no vulnerable jars found"
fi

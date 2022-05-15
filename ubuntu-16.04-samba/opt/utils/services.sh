#!/bin/bash
/opt/utils/samba-include.sh
exec ionice -c 2 smbd -FS --no-process-group </dev/null
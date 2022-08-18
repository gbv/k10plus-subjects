#!/usr/bin/bash
pica print | awk '/^0/{n[$1]++} END{for(i in n) printf "%s\t%d\n", i, n[i]}'


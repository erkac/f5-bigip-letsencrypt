#!/bin/bash
for I in $( cat domains.txt | awk '{ print $1}' ); do
  # tmsh create ltm profile client-ssl auto_$I
  tmsh create ltm profile client-ssl auto_$I defaults-from letsencrypt
  echo "Created  auto_$I client-ssl profile"
done
#!/usr/bin/env bash

docker build \
  --platform linux/amd64 \
  -t nagios_test \
  --build-arg NAGIOS_VERSION="4.5.4" \
  --build-arg NAGIOS_PLUGINS_VERSION="2.4.11" \
  --build-arg NAGIOS_NRPE_VERSION="4.1.1" \
  .


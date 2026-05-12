#!/bin/bash

FAKEHOME=./test-home

bwrap \
  --unshare-all \
  --new-session \
  --die-with-parent \
  \
  --ro-bind /usr /usr \
  --ro-bind /bin /bin \
  --ro-bind /lib /lib \
  --ro-bind /lib64 /lib64 \
  --ro-bind /etc /etc \
  \
  --bind "$FAKEHOME" /home/user \
  \
  --dir /home/user \
  --dir /tmp \
  --tmpfs /tmp \
  \
  --setenv HOME /home/user \
  --setenv USER user \
  --setenv XDG_CONFIG_HOME /home/user/.config \
  --setenv XDG_DATA_HOME /home/user/.local/share \
  --setenv XDG_STATE_HOME /home/user/.local/state \
  \
  --proc /proc \
  --dev /dev \
  \
  --share-net \
  \
  nvim

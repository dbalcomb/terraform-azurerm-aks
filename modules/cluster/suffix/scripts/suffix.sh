#!/usr/bin/env bash

case "$OSTYPE" in
  linux*)
    mkdir -p ./.terraform
    cd ./.terraform

    curl -s https://api.github.com/repos/dbalcomb/aks-cluster-suffix/releases/latest \
    | grep "browser_download_url.*x86_64-unknown-linux-gnu.tar.gz\"" \
    | cut -d : -f 2,3 \
    | tr -d \" \
    | wget -q -i - -O - \
    | tar -xz

    exec ./aks-cluster-suffix
  ;;
  darwin*)
    mkdir -p ./.terraform
    cd ./.terraform

    curl -s https://api.github.com/repos/dbalcomb/aks-cluster-suffix/releases/latest \
    | grep "browser_download_url.*x86_64-apple-darwin.tar.gz\"" \
    | cut -d : -f 2,3 \
    | tr -d \" \
    | wget -q -i - -O - \
    | tar -xz

    exec ./aks-cluster-suffix
  ;;
  *)
    echo "unsupported operating system: $OSTYPE" 1>&2
    exit 1
  ;;
esac

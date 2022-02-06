#!/usr/bin/env bash

. ./env.sh;

PACKER_VERSION="1.7.8";

function ensure_packer() {
    local zip_file="packer_${PACKER_VERSION}_linux_amd64.zip";
    local url="https://releases.hashicorp.com/packer/$PACKER_VERSION/$zip_file";

    export PACKER="$REPO_DIR/local-resources/bin/packer";
    [[ -f "$PACKER" ]] && log_warn "$PACKER already exists. Using it instead of downloading a new binary." && return;

    log_info "Downloading $zip_file.";
    curl -sLo $zip_file $url;

    log_info "Extracting archive.";
    unzip $zip_file;
    mv packer $PACKER;
    rm -Rf $zip_file;

    log_info "Using Packer:";
    $PACKER --version;
}

ensure_packer;

#!/bin/bash
: ${ENV_SECRETS_DIR:=/run/secrets}
function env_secret_expand() {
    var="$1"
    eval val=\$$var
    if secret_name=$(expr match "$val" "DOCKER-SECRET->\([^}]\+\)$"); then
        secretpath="${ENV_SECRETS_DIR}/${secret_name}"
        if [ -f "$secretpath" ]; then
            val=$(cat "${secretpath}")
            export "$var"="$val"
        fi
    fi
}
function env_secrets_expand() {
    for env_var in $(env | cut -f1 -d"=")
    do
        env_secret_expand $env_var
    done
}
env_secrets_expand

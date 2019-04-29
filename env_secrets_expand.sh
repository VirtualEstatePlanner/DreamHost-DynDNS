#!/bin/sh

: ${ENV_SECRETS_DIR:=/run/secrets}

function env_secret_debug() {
    if [ ! -z "$ENV_SECRETS_DEBUG" ]; then
        echo -e "\033[1m$@\033[0m"
    fi
}

# usage: env_secret_expand VAR
#    ie: env_secret_expand 'XYZ_DB_PASSWORD'
# (will check for "$XYZ_DB_PASSWORD" variable value for a placeholder that defines the
#  name of the docker secret to use instead of the original value. For example:
# XYZ_DB_PASSWORD=DOCKER-SECRET->my-db.secret

function env_secret_expand() {
    var="$1"
    echo "beginning expansion of ${var}"
    eval val=\$$var
    if secret_name=$(expr match "$val" "DOCKER-SECRET->\([^}]\+\)$"); then
        echo "${ENV_SECRETS_DIR}/${secret_name}"
        secret="${ENV_SECRETS_DIR}/${secret_name}"
        env_secret_debug "Secret file for $var: $secret_name"
        echo "found secret file for ${secret_name}"
        if [ -f "$secret" ]; then
            val=$(cat "${secret_name}")
            export "$var"="$val"
            echo "exported ${secret_name}"
            env_secret_debug "Expanded variable: $var=$val"
        else
            env_secret_debug "Secret file does not exist! $secret"
        fi
    fi
}

function env_secrets_expand() {
    echo "expanding all secrets"
    for env_var in $(env | cut -f1 -d"=")
    do
        env_secret_expand $env_var
    done

    if [ ! -z "$ENV_SECRETS_DEBUG" ]; then
        echo -e "\n\033[1mExpanded environment variables\033[0m"
        env
    fi
}

env_secrets_expand
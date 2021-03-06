#!/usr/bin/env bash

# get_var improvements:
#   - Environment variables with an empty value are not detected so that the value is retrieved from the YAML-file.

function get_var_usage() {
  echo "Usage: get_var <environment variable name> <yaml file> <yq expression> [default value]"
  echo "Example: get_var TEST_VAR './env.yaml' '.test-parent .test-var' 'Not set'
  echo " This will set environment variable TEST_VAR to:"
  echo " - The current environment variable with name TEST_VAR if it exists."
  echo " - Otherwise the value of attribute 'test-var' under 'test-parent' in YAML-file './env.yaml'
  echo "    - If it's still empty, then the default value will be used (if not set, an empty string is used)."
}

function get_var() {
  local env_var_name="$1"
  local yaml_file="$2"
  local yq_command="$3"
  local default="${4- }"
  local fatal_if_not_found="${5-false}"

  [[ -z "$env_var_name" ]] && get_var_usage && log_fatal "First argument to get_var should be the environment variable name!"
  [[ -z "$yaml_file" ]] && get_var_usage && log_fatal "Second argument to get_var should be the yaml file path!"
  [[ -z "$yq_command" ]] && get_var_usage && log_fatal "Third argument to get_var should be the yaml command (ie: '.var-name' or '.var-parent .var-name'!"
  [[ ! -f "$yaml_file" ]] && log_fatal "Yaml file '$yaml_file' not found!"

  local env_var_value="${!env_var_name-}"

  [[ -n "$env_var_value" ]] && export "$env_var_name"="$env_var_value" && return

  log_debug "Value not found in environment, retrieving it from the YAML-file."

  local yaml_var_value="$(yq <"$yaml_file" "$yq_command")"

  [[ "$yaml_var_value" == "null" ]] && yaml_var_value=""
  [[ -n "$yaml_var_value" ]] && export "$env_var_name"="$yaml_var_value" && return

  if [ "$fatal_if_not_found" == "true" ]; then
    log_fatal "Variable '$env_var_name' not found in the environment and not under '$yq_command' in '$yaml_file'. Exiting."
  fi

  log_debug "Value not found in YAML file, setting the default"
  export "$env_var_name"="$default"
}

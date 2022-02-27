#!/usr/bin/env bash

# After sourcing this file, you can use the commands below.
#   The username from the first cluster in 010-kubernetes.local.yaml is used for the VM-connections

# conn_controller  # Connects the the kube-controller-1 instance with the user that w
# conn_worker_1  # Connects the the kube-controller-1 instance with the user that w
# conn_worker_2  # Connects the the kube-controller-1 instance with the user that w

this_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
current_dir="$(pwd)"
cd "$this_dir" || exit 1

REPO_DIR="$(git rev-parse --show-toplevel)"

. "$REPO_DIR/bash/source/logging.sh"
. "$REPO_DIR/bash/source/yaml.sh"

cd "$current_dir" || exit 1

get_var "KUBE_OS_USERNAME" "$SETTINGS_DIR/005-virtualbox.local.yaml" ".virtualbox .os-user .name" ""

. "$this_dir/env-shared.sh"

# Source this script from your ~/.bash_profile or ~/.bashrc
#   Add the OS-username for the Kubernetes VirtualBox nodes as an argument
#   Example: source ~/shared/kubernetes/utils/profile.sh jeroen

configure_kubernetes_cli

# TODO:
#function set_window () {
#  LINES=$(tput lines)
#  # Create a virtual window that is two lines smaller at the bottom.
#  tput csr 0 $(($LINES-2))
#}
#
#function print_status () {
#  LINES=$(tput lines)
#  # Move cursor to last line in your screen
#  tput cup $LINES 0
#
#  echo -n "--- Some info ---"
#
#  # Move cursor to home position, back in virtual window
#  tput cup 0 0
#}
#
#function configure_prompt() {
#  #export PS1="$(print_status2);\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\u@\h:\w\$"
#  CSI=$'\e'"["
#  PS1="\[${CSI}s${CSI}1;$((LINES-1))r${CSI}$LINES;1f\u@\h"
#  PS1="${PS1} - $(kubectl config current-context)"
#  PS1="${PS1} - \w${CSI}K${CSI}u\]\u \W $ "
#}
#configure_prompt

alias k=kubectl
export GOPATH=~/go
export GOBIN=/usr/local/go/bin
export GOBIN=/Users/jeroen_manders/go/bin


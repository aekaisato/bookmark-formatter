#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
chmod +x "$0"
CMD="zsh"
if [[ $1 ]]; then
  CMD="$1"
fi
PATH="$SCRIPT_DIR:$PATH" $CMD

#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
FILENAME="$2"

help() {
  echo "bm.sh fi [filename] -n [name] -s [shortname] -u [url] -d [description] -t [tags]"
  echo "bm.sh fo [filename] -n [name] -s [shortname] -d [description]"
}

replace_line () { # key, value, file
  sed -i "s~$1: \"\"~$1: \"$2\"~" "$3"
}

process_args () {
  # https://drewstokes.com/bash-argument-parsing
  PARAMS=""
  FILE="$1"
  shift
  while (( "$#" )); do
    case "$1" in
      -n|--name)
        if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
          replace_line "name" "$2" "$FILE"
          shift 2
        else
          echo "Error: Argument for $1 is missing" >&2
          exit 1
        fi
        ;;
      -s|--shortname)
        if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
          replace_line "name_short" "$2" "$FILE"
          shift 2
        else
          echo "Error: Argument for $1 is missing" >&2
          exit 1
        fi
        ;;
      -d|--description)
        if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
          replace_line "description" "$2" "$FILE"
          shift 2
        else
          echo "Error: Argument for $1 is missing" >&2
          exit 1
        fi
        ;;
      -u|--url)
        if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
          replace_line "url" "$2" "$FILE"
          shift 2
        else
          echo "Error: Argument for $1 is missing" >&2
          exit 1
        fi
        ;;
      -t|--tags)
        if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
          replace_line "tags" "$2" "$FILE"
          shift 2
        else
          echo "Error: Argument for $1 is missing" >&2
          exit 1
        fi
        ;;
      -*|--*=) # unsupported flags
        echo "Error: Unsupported flag $1" >&2
        exit 1
        ;;
      *) # preserve positional arguments
        PARAMS="$PARAMS $1"
        shift
        ;;
    esac
  done
  # set positional arguments in their proper place
  eval set -- "$PARAMS"
}

create_file () { # filename, args
  cp "$SCRIPT_DIR/template_bookmark.yaml" "$1.yaml"
  FILENAME="$1"
  shift
  process_args "$FILENAME.yaml" "$@"
}

create_folder () { # filename, args
  mkdir -p "$1/"
  cp "$SCRIPT_DIR/template_folder.yaml" "$1/__meta.yaml"
  FILENAME="$1"
  shift
  process_args "$FILENAME/__meta.yaml" "$@"
}

if [[ $1 == "fi" ]]; then
  shift
  create_file "$@"
elif [[ $1 == "fo" ]]; then
  shift
  create_folder "$@"
else
  help
fi

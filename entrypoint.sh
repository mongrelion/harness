#!/usr/bin/env bash
source /home/coder/.bashrc

case "$1" in
  omp)
    shift
    bun x omp --tools ask,bash,edit,find,grep,ast_grep,ast_edit,lsp,read,task,await,todo_write,fetch,web_search,write
    ;;
  pi)
    shift
    bun x pi "$@"
    ;;
  oc)
    shift
    bun x opencode "$@"
    ;;
  *)
    echo "Command not found: $1" >&2
    echo "Executing bash"
    exec bash
    ;;
esac

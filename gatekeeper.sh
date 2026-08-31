#!/usr/bin/env bash
set -euo pipefail

die() { echo >&2 "ERROR: $*"; exit 1; }
usage() { sed -n '1,240p' "$0"; exit 1; }

require_path_arg() {
  [[ -n "${1-}" ]] || die "Missing path argument"
  [[ -e "$1" ]] || die "Path not found: $1"
}

cmd_status() {
  if command -v spctl >/dev/null 2>&1; then
    spctl --status || true
  else
    die "spctl not found on this system"
  fi
}

cmd_enable() { echo "Enabling Gatekeeper (spctl --master-enable)..."; sudo spctl --master-enable; echo "Done."; }

cmd_disable() {
  local confirm="no"
  if [[ "${1-}" == "--yes" || "${1-}" == "-y" ]]; then
    confirm="yes"
  fi
  if [[ "$confirm" != "yes" ]]; then
    echo "WARNING: Disabling Gatekeeper reduces system security."
    read -r -p "Proceed to disable Gatekeeper? (y/N) " ans
    case "$ans" in [yY]|[yY][eE][sS]) ;; *) echo "Aborted."; exit 0 ;; esac
  fi
  echo "Disabling Gatekeeper (spctl --master-disable)..."
  sudo spctl --master-disable
  echo "Done."
}

cmd_assess() { local path="$1"; require_path_arg "$path"; echo "Running: spctl -a -t exec -vv \"$path\""; spctl -a -t exec -vv "$path" || true; echo "Exit code: $?"; }

cmd_allow() { local path="$1"; local label="${2-}"; require_path_arg "$path"; if [[ -n "$label" ]]; then sudo spctl --add --label "$label" "$path"; else sudo spctl --add "$path"; fi; echo "Done."; }

cmd_remove_label() { local label="$1"; [[ -n "$label" ]] || die "Missing label"; sudo spctl --remove --label "$label"; echo "Done."; }

cmd_remove_path() { local path="$1"; require_path_arg "$path"; sudo spctl --remove "$path"; echo "Done."; }

cmd_list() { echo "spctl --list output:"; spctl --list || true; echo; spctl --list | sed -n '1,200p' || true; }

cmd_quarantine_remove() {
  local path="$1"
  require_path_arg "$path"
  echo "Removing com.apple.quarantine xattr recursively from: $path"
  if command -v xattr >/dev/null 2>&1; then
    sudo xattr -r -d com.apple.quarantine "$path" || echo "xattr returned non-zero"
  else
    die "xattr not found on this system"
  fi
  echo "Done."
}

main() {
  if [[ "${#@}" -eq 0 ]]; then usage; fi
  cmd="$1"; shift || true
  case "$cmd" in
    status) cmd_status "$@" ;;
    enable) cmd_enable "$@" ;;
    disable) cmd_disable "$@" ;;
    assess) cmd_assess "$1" ;;
    allow) cmd_allow "$1" "${2-}" ;;
    remove-label) cmd_remove_label "$1" ;;
    remove-path) cmd_remove_path "$1" ;;
    list) cmd_list ;;
    quarantine-remove) cmd_quarantine_remove "$1" ;;
    help|--help|-h) usage ;;
    *) echo "Unknown command: $cmd"; usage ;;
  esac
}

main "$@"

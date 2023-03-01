#!/usr/bin/env bash

# Utils
################################################################3
function msg() {
  local text="$1"
  local div_width="80"
  printf "%${div_width}s\n" ' ' | tr ' ' -
  printf "%s\n\n" "$text"
}
################################################################3

# Node deps
################################################################3
declare -a __npm_deps=(
  "neovim"
)

# treesitter installed with brew causes conflicts #3738
if ! command -v tree-sitter &>/dev/null; then
  __npm_deps+=("tree-sitter-cli")
fi

function __install_nodejs_deps_pnpm() {
  echo "using pnpm to install dependencies.."
  pnpm install -g "${__npm_deps[@]}"
  printf "\n%s\n" "All NodeJS dependencies are successfully installed"
}

function __install_nodejs_deps_npm() {
  echo "using npm to install dependencies.."
  for dep in "${__npm_deps[@]}"; do
    if ! npm ls -g "$dep" &>/dev/null; then
      printf "installing %s .." "$dep"
      npm install -g "$dep"
    fi
  done

  printf "\n%s\n" "All NodeJS dependencies are successfully installed"
}

function __install_nodejs_deps_yarn() {
  echo "using yarn to install dependencies.."
  yarn global add "${__npm_deps[@]}"
  printf "\n%s\n" "All NodeJS dependencies are successfully installed"
}

function __validate_node_installation() {
  local pkg_manager="$1"
  local manager_home

  if ! command -v "$pkg_manager" &>/dev/null; then
    return 1
  fi

  if [ "$pkg_manager" == "npm" ]; then
    manager_home="$(npm config get prefix 2>/dev/null)"
  elif [ "$pkg_manager" == "pnpm" ]; then
    manager_home="$(pnpm config get prefix 2>/dev/null)"
  else
    manager_home="$(yarn global bin 2>/dev/null)"
  fi

  if [ ! -d "$manager_home" ] || [ ! -w "$manager_home" ]; then
    return 1
  fi

  return 0
}

function install_nodejs_deps() {
  local -a pkg_managers=("pnpm" "yarn" "npm")
  for pkg_manager in "${pkg_managers[@]}"; do
    if __validate_node_installation "$pkg_manager"; then
      eval "__install_nodejs_deps_$pkg_manager"
      return
    fi
  done
  echo "[WARN]: skipping installing optional nodejs dependencies due to insufficient permissions."
  echo "check how to solve it: https://docs.npmjs.com/resolving-eacces-permissions-errors-when-installing-packages-globally"
}
################################################################3

# Python deps
################################################################3
declare -a __pip_deps=(
  "pynvim"
)

function install_python_deps() {
  echo "Verifying that pip is available.."
  if ! python3 -m ensurepip >/dev/null; then
    if ! python3 -m pip --version &>/dev/null; then
      echo "[WARN]: skipping installing optional python dependencies"
      return 1
    fi
  fi
  echo "using pip to install dependencies.."
  for dep in "${__pip_deps[@]}"; do
    python3 -m pip install --user "$dep" || return 1
  done
  printf "\n%s\n" "All Python dependencies are successfully installed"
}
################################################################3

# Rust deps
################################################################3
declare -a __rust_deps=(
  "fd::fd-find"
  "rg::ripgrep"
)

function __attempt_to_install_with_cargo() {
  if command -v cargo &>/dev/null; then
  echo "using cargo to install dependencies.."
    cargo install "$1"
  else
    echo "[WARN]: Unable to find cargo. Make sure to install it to avoid any problems"
    exit 1
  fi
}

# we try to install the missing one with cargo even though it's unlikely to be found
function install_rust_deps() {
  for dep in "${__rust_deps[@]}"; do
    if ! command -v "${dep%%::*}" &>/dev/null; then
      __attempt_to_install_with_cargo "${dep##*::}"
    fi
  done
  printf "\n%s\n" "All Rust dependencies are successfully installed"
}
################################################################3

function main() {
  msg "Installing requirements Node JS dependencies"
  install_nodejs_deps
  msg "Installing requirements Python dependencies"
  install_python_deps
  msg "Installing requirements Rust dependencies"
  install_rust_deps
}

main "$@"

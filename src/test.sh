# Setup

sh_vcp=${PWD}/src/bin/sh-vcp
vcs_supported="bzr git hg svn"

# Helpers

check() {
  printf "Checking %s: " "$*"
}

build_git_test_repository() {
  local git=`command -v git`
  $git init --quiet
  touch .gitignore
  touch .gitmodules
  touch .gitkeep
  $git add .
  $git commit --quiet --message "Repository created"
}

# Asserts

assert() {
  eval "$@" && printf "." || printf "F"
}

assert_equal() {
  assert test "$1" = "$2"
}

assert_not_empty() {
  assert test "$1"
}

# Setup

build_test_directory() {
  : ${1:?test directory path}
  rm -rf $1
  mkdir -p $1
  cd $1 > /dev/null
}

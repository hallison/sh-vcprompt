# Helpers

info() {
  printf "%s\n" "-- $*"
}

testing() {
  cd "$1" > /dev/null
  printf "** Testing %s: " "$2"
}

end() {
  cd - > /dev/null
  echo
}

# Asserts

assert() {
  eval "$@" && {
    : success
    printf "."
  } || {
    : fail
    printf "F"
  }
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

build_test_repository_git() {
  info "Building test repository Git" && (
    local git=`command -v git`
    build_test_directory $1
    : $PWD
    $git init --quiet
    touch .gitignore  && $git add .gitignore
    touch .gitmodules && $git add .gitmodules
    touch .gitkeep    && $git add .gitkeep
    $git commit --quiet --message "Repository created"
  ) && return 0 || exit $?
}

build_test_repository_hg() {
  info "Building test repository Mercurial" && (
    local hg=`command -v hg`
    build_test_directory $1
    $hg init --quiet
    touch .hgignore
    touch .hgtags
    $hg commit --addremove --quiet --message "Repository created" --user "Test"
  ) && return 0 || exit $?
}




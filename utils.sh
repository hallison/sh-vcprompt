# Helpers

check() {
  cd "$1" > /dev/null
  printf "Checking %s: " "$2"
}

end() {
  cd - > /dev/null
  echo
}

build_bzr_test_reporitory() {
  local bzr=`command -v bzr`
  $bzr init --quiet
  $bzr whoami --quiet "Test <test@localhost.net>"
  touch .bzrignore
  $bzr add --quiet . 
  $bzr commit --quiet --message "Repository created"
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

build_hg_test_repository() {
  local hg=`command -v hg`
  $hg init --quiet
  touch .hgignore
  touch .hgtags
  $hg commit --addremove --quiet --message "Repository created" --user "Test"
}

build_svn_test_repository() {
  local svn=`command -v svn`
  local svnadmin=`command -v svnadmin`
  rm -rf /tmp/svn_test_remote
  $svnadmin create /tmp/svn_test_remote
  $svn checkout --quiet file:///tmp/svn_test_remote .
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

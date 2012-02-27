# Setup
prefix=$PWD/src
libdir=${prefix}/lib

. $prefix/test.sh

# Git tests
. $libdir/git.sh

build_test_directory "test/git_test"
build_git_test_repository

check "git repository"
  assert_equal      "master" "`branch`"
  hashkey=`hashkey`
  assert_not_empty  "$hashkey"
  assert_equal      "6"      "${#hashkey}"
  assert_equal      "1"      "`revision`"

echo

check "git status"
  assert_equal "-"      "`modified`"
  assert_equal "-"      "`untracked`"
  assert_equal "-"      "`staged`"

  echo "test.*" > .gitignore
  assert_equal "+"     "`modified`"

  touch README.md
  assert_equal "?"      "`untracked`"

  git add .gitignore
  assert_equal "*"      "`staged`"

echo

cd - > /dev/null

# Mercurial tests
. $libdir/hg.sh

build_test_directory "test/hg_test"
build_hg_test_repository

check "hg repository"
  assert_equal     "default" "`branch`"
  hashkey=`hashkey`
  assert_not_empty  $hashkey
  assert_equal      6 ${#hashkey}
  assert_equal     "0"       "`revision`"

echo

check "hg status when a new repository"
  assert_equal "-"      "`modified`"
  assert_equal "-"      "`untracked`"
  assert_equal "-"      "`staged`"

  echo "test.*" > .hgignore
  assert_equal "+"     "`modified`"

  touch README.md
  assert_equal "?"      `untracked`

  hg add .hgignore
  assert_equal "*"      `staged`

echo

cd - > /dev/null

# Prompt tests
. $libdir/vcprompt.sh

build_test_directory "test/git_test"
build_git_test_repository

check "git version control system"
  system # this must initialize the VCS
  assert_equal     "git" "`vcs`"
  assert_equal     "---" "`format "%m%u%a"`"
  assert_equal     "git:master" "`format "%s:%b"`"

echo

cd - > /dev/null


: $PWD
prefix=$PWD
libdir=$prefix

# Utilities
. $libdir/utils.sh

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

  unset hashkey

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

  unset hashkey

echo

cd - > /dev/null

# Prompt tests
. $libdir/vcs.sh

build_test_directory "test/git_test"
build_git_test_repository

check "git version control system"
  system
  assert_equal     "git" "`vcs`"
  assert_equal     "---" "`format "%m%a%u"`"
  assert_equal     "git:master" "`format "%s:%b"`"
  hashkey=`hashkey`
  assert_equal "1:$hashkey" "`format "%r:%h"`"
  assert_equal "git:master[1:$hashkey:---]" "`format "%s:%b[%r:%h:%m%a%u]"`"

  echo "test.*" > .gitignore
  assert_equal "git:master[1:$hashkey:+--]" "`format "%s:%b[%r:%h:%m%a%u]"`"

  touch README.md
  assert_equal "git:master[1:$hashkey:+-?]" "`format "%s:%b[%r:%h:%m%a%u]"`"

  git add .gitignore
  assert_equal "git:master[1:$hashkey:-*?]" "`format "%s:%b[%r:%h:%m%a%u]"`"

  git add README.md
  assert_equal "git:master[1:$hashkey:-*-]" "`format "%s:%b[%r:%h:%m%a%u]"`"

  unset hashkey

echo

cd - > /dev/null

build_test_directory "test/hg_test"
build_hg_test_repository

check "mercurial (hg) version control system"
  system
  assert_equal     "hg" "`vcs`"
  assert_equal     "---" "`format "%m%a%u"`"
  assert_equal     "hg:default" "`format "%s:%b"`"
  hashkey=`hashkey`
  assert_equal "0:$hashkey" "`format "%r:%h"`"
  assert_equal "hg:default[0:$hashkey:---]" "`format "%s:%b[%r:%h:%m%a%u]"`"

  echo "test.*" > .hgignore
  assert_equal "hg:default[0:$hashkey:+*-]" "`format "%s:%b[%r:%h:%m%a%u]"`"

  touch README.md
  assert_equal "hg:default[0:$hashkey:+*?]" "`format "%s:%b[%r:%h:%m%a%u]"`"

  hg add .hgignore
  assert_equal "hg:default[0:$hashkey:+*?]" "`format "%s:%b[%r:%h:%m%a%u]"`"

  hg add README.md
  assert_equal "hg:default[0:$hashkey:+*-]" "`format "%s:%b[%r:%h:%m%a%u]"`"

  unset hashkey

echo

cd - > /dev/null


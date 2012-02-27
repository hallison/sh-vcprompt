. src/test/setup.sh
. src/lib/git.sh

build_test_directory "test/git_test"
build_git_test_repository

check "git repository"
  assert_equal      "git"    "`system`"
  assert_equal      "master" "`branch`"
  assert_equal      "1"      "`revision`"
  assert_not_empty  "`hashkey`"

echo

check "git status"
  assert_equal ""      "`modified`"

  echo "test.*" > .gitignore
  assert_equal "+"     "`modified`"

  touch README.md
  assert_equal "?"      "`untracked`"

  git add .gitignore
  assert_equal "*"      "`staged`"

cd - > /dev/null

echo

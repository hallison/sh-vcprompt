: $PWD
prefix=$PWD
libdir=$prefix

# Utilities
. $libdir/utils.sh

# Git tests
. $libdir/git.sh

git_test="$PWD/test/git_test"

build_test_repository_git $git_test

testing $git_test "git repository"
  assert_equal      "master" "`branch`"
  hashkey=`hashkey`
  assert_not_empty  "$hashkey"
  assert_equal      "6"      "${#hashkey}"
  assert_equal      "1"      "`revision`"
end

testing $git_test "git status"
  : $PWD # test directory
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
end

# Mercurial tests
. $libdir/hg.sh

hg_test="$PWD/test/hg_test"

build_test_repository_hg $hg_test

testing $hg_test "hg repository"
  assert_equal     "default" "`branch`"
  hashkey=`hashkey`
  assert_not_empty  $hashkey
  assert_equal     "6"       "${#hashkey}"
  assert_equal     "0"       "`revision`"
end

testing $hg_test "hg status when a new repository"
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
end

# Prompt tests
. $libdir/vcs.sh

build_test_repository_git $git_test

testing $git_test "git version control system"
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
end

testing $git_test "git has many hashes when it has have remotes"
  cp -r ".git" "../git_remote_test.git" > /dev/null

  git remote add origin "../git_remote_test.git"

  git remote update > /dev/null

  git commit --quiet --allow-empty --message "commit 2"
  git commit --quiet --allow-empty --message "commit 3"

  hashkey=`hashkey`
  assert_equal "3:$hashkey" "`format "%r:%h"`"
end

build_test_repository_hg $hg_test

testing $hg_test "mercurial version control system"
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
end



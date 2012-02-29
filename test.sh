: $PWD
prefix=$PWD
libdir=$prefix

# Utilities
. $libdir/utils.sh

# Setup
git_test="$PWD/test/git_test"
hg_test="$PWD/test/hg_test"
common_dir_test="$PWD/test/common_dir_test"

test_all() {
  for vcs in git hg invalid; do
    type test_$vcs     > /dev/null && test_$vcs
    type test_vcs_$vcs > /dev/null && test_vcs_$vcs
  done
}

# Git tests
test_git() {
  . $libdir/git.sh

  build_test_repository_git $git_test

  testing $git_test "git repository"
    assert_equal      "git"    "`sh_vcp_system`"
    assert_equal      "master" "`sh_vcp_branch`"
    hashkey=`sh_vcp_hashkey`
    assert_not_empty  "$hashkey"
    assert_equal      "6"      "${#hashkey}"
    assert_equal      "1"      "`sh_vcp_revision`"
  end

  testing $git_test "git status"
    : $PWD # test directory
    assert_equal "-"      "`sh_vcp_modified`"
    assert_equal "-"      "`sh_vcp_untracked`"
    assert_equal "-"      "`sh_vcp_staged`"

    echo "test.*" > .gitignore
    assert_equal "+"     "`sh_vcp_modified`"

    touch README.md
    assert_equal "?"      "`sh_vcp_untracked`"

    git add .gitignore
    assert_equal "*"      "`sh_vcp_staged`"

    unset hashkey
  end
}

# Mercurial tests
test_hg() {
  . $libdir/hg.sh

  build_test_repository_hg $hg_test

  testing $hg_test "hg repository"
    assert_equal     "hg"      "`sh_vcp_system`"
    assert_equal     "default" "`sh_vcp_branch`"
    hashkey=`sh_vcp_hashkey`
    assert_not_empty  $hashkey
    assert_equal     "6"       "${#hashkey}"
    assert_equal     "0"       "`sh_vcp_revision`"
  end

  testing $hg_test "hg status when a new repository"
    assert_equal "-"      "`sh_vcp_modified`"
    assert_equal "-"      "`sh_vcp_untracked`"
    assert_equal "-"      "`sh_vcp_staged`"

    echo "test.*" > .hgignore
    assert_equal "+"     "`sh_vcp_modified`"

    touch README.md
    assert_equal "?"      `sh_vcp_untracked`

    hg add .hgignore
    assert_equal "*"      `sh_vcp_staged`

    unset hashkey
  end
}

# Prompt tests
test_vcs_git() {
  . $libdir/vcs.sh

  build_test_repository_git $git_test

  testing $git_test "git version control system"
    sh_vcp_system > /dev/null # bootstrap to VCS library
    assert_equal     "git" "`sh_vcp_system`"
    assert_equal     "---" "`sh_vcp_format "%m%a%u"`"
    assert_equal     "git:master" "`sh_vcp_format "%s:%b"`"
    hashkey=`sh_vcp_hashkey`
    assert_equal "1:$hashkey" "`sh_vcp_format "%r:%h"`"
    assert_equal "git:master[1:$hashkey:---]" "`sh_vcp_format "%s:%b[%r:%h:%m%a%u]"`"

    echo "test.*" > .gitignore
    assert_equal "git:master[1:$hashkey:+--]" "`sh_vcp_format "%s:%b[%r:%h:%m%a%u]"`"

    touch README.md
    assert_equal "git:master[1:$hashkey:+-?]" "`sh_vcp_format "%s:%b[%r:%h:%m%a%u]"`"

    git add .gitignore
    assert_equal "git:master[1:$hashkey:-*?]" "`sh_vcp_format "%s:%b[%r:%h:%m%a%u]"`"

    git add README.md
    assert_equal "git:master[1:$hashkey:-*-]" "`sh_vcp_format "%s:%b[%r:%h:%m%a%u]"`"

    unset hashkey
  end

  testing $git_test "git has many hashes when it has have remotes"
    cp -r ".git" "../git_remote_test.git" > /dev/null

    git remote add origin "../git_remote_test.git"

    git remote update > /dev/null

    git commit --quiet --allow-empty --message "commit 2"
    git commit --quiet --allow-empty --message "commit 3"

    git push origin master --quiet
    git remote update 2>&1 > /dev/null

    hashkey=`sh_vcp_hashkey`
    assert_equal "3:$hashkey" "`sh_vcp_format "%r:%h"`"
  end
}

test_vcs_hg() {
  . $libdir/vcs.sh

  build_test_repository_hg $hg_test

  testing $hg_test "mercurial version control system"
    sh_vcp_system > /dev/null # bootstrap to VCS library
    assert_equal     "hg"  "`sh_vcp_system`"
    assert_equal     "---" "`sh_vcp_format "%m%a%u"`"
    assert_equal     "hg:default" "`sh_vcp_format "%s:%b"`"
    hashkey=`sh_vcp_hashkey`
    assert_equal "0:$hashkey" "`sh_vcp_format "%r:%h"`"
    assert_equal "hg:default[0:$hashkey:---]" "`sh_vcp_format "%s:%b[%r:%h:%m%a%u]"`"

    echo "test.*" > .hgignore
    assert_equal "hg:default[0:$hashkey:+*-]" "`sh_vcp_format "%s:%b[%r:%h:%m%a%u]"`"

    touch README.md
    assert_equal "hg:default[0:$hashkey:+*?]" "`sh_vcp_format "%s:%b[%r:%h:%m%a%u]"`"

    hg add .hgignore
    assert_equal "hg:default[0:$hashkey:+*?]" "`sh_vcp_format "%s:%b[%r:%h:%m%a%u]"`"

    hg add README.md
    assert_equal "hg:default[0:$hashkey:+*-]" "`sh_vcp_format "%s:%b[%r:%h:%m%a%u]"`"

    unset hashkey
  end
}

test_vcs_invalid() {
  . $libdir/vcs.sh

  build_test_directory $common_dir_test

  testing $common_dir_test "common directory"
    assert_equal "" "`sh_vcp_system`"
    assert_equal "" "`sh_vcp_format "%s"`"
  end

  testing $common_dir_test "directory with VCS refs files like configs"
    touch .gitconfig
    touch .hgrc
    assert_equal "" "`sh_vcp_system`"
    assert_equal "" "`sh_vcp_format "%s"`"
  end
}

test -n $1 && type test_$1 > /dev/null && test_$1



VCS_SUPPORTED="bzr:git:hg:svn"
VCS_MODIFIED='+'
VCS_UNTRACKED='?'
VCS_STAGED='*'
VCS_NONE='-'

# Return the VCS in current directory
vcs() {
  # echo .* | awk '{ gsub(/[.]/, "", $3);  print $3 }'
  # echo .{bzr,git,hg,svn} | cut -d ' ' -f 3 | tr -d '.'
  echo .* | sed -n 's/.*\(bzr\|git\|hg\|svn\).*/\1/gp'
}

# Initialize VCS library
system() {
  local vcs=`vcs`
  test -f $libdir/$vcs.sh && . $libdir/$vcs.sh
}

format() {
  : ${1:?format %m=modified, %u=untracked, %a=staged/added}
  system
  echo "$1" | sed -n "
    s/%s/`vcs`/g;
    s/%b/`branch`/g;
    s/%m/`modified`/g;
    s/%u/`untracked`/g;
    s/%a/`staged`/g;
    p
  "
}

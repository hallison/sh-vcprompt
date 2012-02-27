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


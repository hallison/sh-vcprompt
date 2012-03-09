: ${SH_VCP_SUPPORTED:="bzr:git:hg:svn"}
: ${SH_VCP_MODIFIED:='+'}
: ${SH_VCP_STAGED:='*'}
: ${SH_VCP_UNTRACKED:='?'}
: ${SH_VCP_NONE:='-'}
: ${SH_VCP_FORMAT:=[%s:%b]}

# Template functions
sh_vcp_branch()    { echo -n; }
sh_vcp_hashkey()   { echo -n; }
sh_vcp_revision()  { echo -n; }
sh_vcp_modified()  { echo -n; }
sh_vcp_staged()    { echo -n; }
sh_vcp_untracked() { echo -n; }

# Initialize VCS library and echoes the VCS name
sh_vcp_system() {
  # echo .* | awk '{ gsub(/[.]/, "", $3);  print $3 }'
  # echo .{bzr,git,hg,svn} | cut -d ' ' -f 3 | tr -d '.'
  local vcs=`echo .* | sed -n 's/.*\(bzr\|git\|hg\|svn\)[ \n].*/\1/gp'`
  test -n "$vcs"          &&
  test -f $libdir/$vcs.sh &&
  . $libdir/$vcs.sh       &&
  echo -n $vcs            ||
  return 1
}

sh_vcp_format() {
  : ${1:?format %m=modified, %a=staged/added, %u=untracked}
  set -f
  echo -n "$1" | sed -n "
    s/%s/`sh_vcp_system`/g;
    s/%b/`sh_vcp_branch`/g;
    s/%r/`sh_vcp_revision`/g;
    s/%h/`sh_vcp_hashkey`/g;
    s/%m/`sh_vcp_modified`/g;
    s/%a/`sh_vcp_staged`/g;
    s/%u/`sh_vcp_untracked`/g;
    p
  "
}

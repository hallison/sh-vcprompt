#!/bin/sh
changecom()dnl
##_NAME _VERSION (_RELEASE)
##
##Usage:
##  _PROGRAM <OPTION>
##
##Options:
##  -f    Format output.
##  -h    Show this message.
##
##Formats:
##  %s    Show Version Control System - VCS.
##  %b    Show current branch.
##  %h    Show hash key of the latest commit.
##  %r    Show latest revision or the latest number of commit.
##  %m    Show status (+) to modified files.
##  %a    Show status (*) to added (staged) files.
##  %u    Show status (?) to untracked files.
##

: ${prefix:=_PREFIX} ${bindir:=_BINDIR} ${libdir:=_LIBDIR}

. ${libdir}/vcs.sh

sh_vcp_usage() {
  sed -n "s/^##//gp" $0
}

test $# -gt 0 && {
  case $1 in
    -h|--help)
      sh_vcp_usage && exit 0
      ;;
    -*)
      sh_vcp_usage && exit 1
      ;;
    *)
      sh_vcp_system > /dev/null && sh_vcp_format "$@"
      ;;
  esac
} || {
  sh_vcp_system > /dev/null && sh_vcp_format "$SH_VCP_FORMAT" # default format
}

exit 0

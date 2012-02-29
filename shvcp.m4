#!/bin/sh
changecom()dnl
##_NAME _VERSION (_RELEASE)
##
##Usage:
##  _PROGRAM <OPTION>
##
##Options:
##  -f    Format output.
##  -H    Show this message.
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

usage() {
  sed -n "s/^##//gp" $0
}

while getopts f:h opt; do
  case $opt in
    f) test vcs >/dev/null && format "$OPTARG" && exit 0 ;;
    h) usage && exit 0 ;;
    ?) usage && exit 1 ;;
  esac
done


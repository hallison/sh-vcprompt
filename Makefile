.POSIX:

name = sh-vcp
version = 0.1.0

prefix       ?= /usr/local
bindir       ?= $(prefix)/bin
sharerootdir ?= $(prefix)/share
sharedir     ?= $(sharerootdir)/$(name)

basedir      = build
sourcedir    = src
testdir      = $(sourcedir)/test

directories  = $(prefix) $(bindir) $(sharerootdir) $(sharedir)
programs     = sh-vcp
functions    = git.sh hg.sh

documents    = README.html
tests        = $(functions:.sh=_test.sh)
errors       = $(addprefix $(testdir)/,$(tests:.sh=.err))

all:: build

.SUFFIXES: .sh .err .md .html

.sh:
	echo Will be parsed

.sh.err: 
	sh -x $< 2> $@

.md.html:
	markdown $< > $@

clean:
	rm -rf $(errors)
	rm -rf $(documents)

check: $(errors)

doc: $(documents)


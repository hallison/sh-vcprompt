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
errors       = test.err

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
	rm -rf $(testdir)

check: $(errors)

doc: $(documents)


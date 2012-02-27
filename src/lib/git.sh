system()    { echo git; }

branch()    { git symbolic-ref HEAD | cut -d / -f 3; }

hashkey()   { git show-ref | cut -c 1-6; }

revision()  { git rev-list HEAD | wc -l; }

modified()  { git diff --name-status --quiet || echo -n '+'; }

untracked() { test -n "`git ls-files --other --exclude-standard`" && echo -n '?'; }

staged()    { git diff --cached --quiet || echo -n '*'; }

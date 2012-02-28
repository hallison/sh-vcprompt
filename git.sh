branch()    { git symbolic-ref HEAD | cut -d / -f 3; }
hashkey()   { git show-ref  --head HEAD | cut -c 1-6; }
revision()  { git rev-list HEAD | wc -l; }
modified()  { git diff --name-status --quiet && echo -n '-' || echo -n '+'; }
staged()    { git diff --cached --quiet && echo -n '-' || echo -n '*'; }
untracked() { test `git ls-files --other --exclude-standard | wc -l` -gt 0 && echo -n '?' || echo '-'; }

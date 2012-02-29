sh_vcp_system()    { echo -n git; }
sh_vcp_branch()    { git symbolic-ref HEAD | cut -d / -f 3; }
sh_vcp_hashkey()   { git show-ref  --head HEAD | cut -c 1-6; }
sh_vcp_revision()  { git rev-list HEAD | wc -l; }
sh_vcp_modified()  { git diff --name-status --quiet && echo -n '-' || echo -n '+'; }
sh_vcp_staged()    { git diff --cached --quiet && echo -n '-' || echo -n '*'; }
sh_vcp_untracked() { test `git ls-files --other --exclude-standard | wc -l` -gt 0 && echo -n '?' || echo '-'; }

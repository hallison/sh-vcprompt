sh_vcp_system()    { echo -n hg; }
sh_vcp_branch()    { cat .hg/undo.branch; }
sh_vcp_hashkey()   { HGPLAIN=1 hg log --rev . --quiet --template '{node}' | cut -c 3-8; }
sh_vcp_revision()  { HGPLAIN=1 hg log --rev . --quiet --template '{rev}'  | cut -d : -f 1; }
sh_vcp_modified()  { test `HGPLAIN=1 hg status --modified | wc -l` -gt 0 && echo -n ${SH_VCP_MODIFIED}  || echo -n ${SH_VCP_NONE}; }
sh_vcp_staged()    { test `HGPLAIN=1 hg diff   --stat     | wc -l` -gt 0 && echo -n ${SH_VCP_STAGED}    || echo -n ${SH_VCP_NONE}; }
sh_vcp_untracked() { test `HGPLAIN=1 hg status --unknown  | wc -l` -gt 0 && echo -n ${SH_VCP_UNTRACKED} || echo -n ${SH_VCP_NONE}; }

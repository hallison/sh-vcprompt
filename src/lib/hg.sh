__sh_vcp_hg_revision() {
  test -f .hg/cache/branchheads && cat .hg/cache/branchheads && return 0
  test -f .hg/cache/tags        && cat .hg/cache/tags        && return 0
  # this is need when a new repository
  HGPLAIN=1 hg log --rev 0 --quiet
}

branch()    { cat .hg/undo.branch; }
hashkey()   { __sh_vcp_hg_revision | cut -c 3-8; }
revision()  { __sh_vcp_hg_revision | cut -d : -f 1; }
modified()  { test `HGPLAIN=1 hg status --modified | wc -l` -gt 0 && echo -n '+' || echo -n '-'; }
untracked() { test `HGPLAIN=1 hg status --unknown  | wc -l` -gt 0 && echo -n '?' || echo -n '-'; }
staged()    { test `HGPLAIN=1 hg diff   --stat     | wc -l` -gt 0 && echo -n '*' || echo -n '-'; }

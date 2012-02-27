branch()    { cat .hg/undo.branch; }
hashkey()   { HGPLAIN=1 hg log --rev . --quiet --template '{node}' | cut -c 3-8; }
revision()  { HGPLAIN=1 hg log --rev . --quiet --template '{rev}'  | cut -d : -f 1; }
modified()  { test `HGPLAIN=1 hg status --modified | wc -l` -gt 0 && echo -n '+' || echo -n '-'; }
staged()    { test `HGPLAIN=1 hg diff   --stat     | wc -l` -gt 0 && echo -n '*' || echo -n '-'; }
untracked() { test `HGPLAIN=1 hg status --unknown  | wc -l` -gt 0 && echo -n '?' || echo -n '-'; }

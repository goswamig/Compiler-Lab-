clear
bison Exprtree.y
flex Exprtree.l

cc -g lex.yy.c Exprtree.tab.c SymbTab.c AbsSynTree.c -o Eval
./Eval inp


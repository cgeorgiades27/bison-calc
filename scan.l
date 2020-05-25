%{
#include "bcalc.h"
#include <string.h>
#include <stdlib.h>
#include <iostream>
%}

%%
\+\+   { return INC; }
--     { return DEC; }
(<<)   { return LSHIFT; } 
(>>)   { return RSHIFT; }
[0-9]+ { yylval.i = strtol(yytext, NULL, 10); return INT; }
dump   { return DUMP; }
reset  { return RESET; }
[a-z]  { yylval.c = yytext; return CHAR; }
[ \t]+ { ; }
\n     { ; }
.      { return *yytext; }
%%

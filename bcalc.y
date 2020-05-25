%{
#include <iostream>
#include <map>
#include <string>
#include <stdio.h>

  int linenum = 1;
  std::map<char,int> map; // container for alphabet pairs
  std::string s = "abcdefghijklmnopqrstuvwxyz";
  int flag = 0;

  int yylex();
  void yyerror(char*);
  void dump(std::string);
  bool add(char *);
%}

%union
{
  char *c;
  int i;
  bool b;
}

%token INC DEC LSHIFT RSHIFT DUMP RESET
%token<c> CHAR
%token<i> INT
%type<c> term
%type<i> exp num

%right ASSIGN
%left  XOR
%left  AND
%left  RSHIFT LSHIFT
%left  ADD
%left  MOD DIV MULT
%right NEGATE
%right NOT
%right DEC INC

%%
prog: stmts
    ;
stmts: 
     | stmts exp ';'    {std::cout << $2 << '\n'; }
     | stmts dmp        { dump(s); }
     | stmts rst        { map.clear(); }
     | ';'
     ;
exp : num		{ $$ = $1; }
    | term		{ add($1) ? $$ = map[*$1] : $$ = 0; }
    | term '=' exp	{ $$ = map[*$1] = $3; }
    | exp '|' exp       { $$ = $1 | $3; }
    | exp '^' exp     	{ $$ = $1 ^ $3; }
    | exp '&' exp     	{ $$ = $1 & $3; }
    | exp RSHIFT exp   	{ $$ = $1 >> $3; }
    | exp LSHIFT exp   	{ $$ = $1 << $3; }
    | exp '+' exp      	{ $$ = $1 + $3; }
    | exp '-' exp   	{ $$ = $1 - $3; }
    | exp '*' exp    	{ $$ = $1 * $3; }
    | exp '/' exp    	{ $$ = $1 / $3; }
    | exp '%' exp      	{ $$ = $1 % $3; }
    | '(' exp ')'	{ $$ = $2; }
    | '-' exp       	{ $$ = $2 * -1; }
    | '~' exp           { $$ = ~$2; }
    | term DEC          { $$ = map[*$1]--; }
    | term INC          { $$ = map[*$1]++; }
    | DEC term          { $$ = --map[*$2]; }
    | INC term          { $$ = ++map[*$2]; }
    ;
num : INT 		{ $$ = $1; } 
    ;
term : CHAR    		{ $$ = $1; }
     ;
dmp : DUMP		
    ;
rst : RESET
    ;

%%
int main()
{
  if (yyparse())
    std::cout << "Invalid expression.\n";
  else
    std::cout << "\nCalculator off.\n";
  return 0;
}

void yyerror(char *s) {
  fprintf(stderr, "%d.: %s\n", linenum, s);
}


void dump(std::string s)
{
  std::map<char,int>::iterator mItr;
  for (size_t i = 0; i < s.size(); ++i)
  {
    std::cout << s[i] << ": ";
    mItr = map.find(s[i]);
    if (mItr == map.end())
      std::cout << "unknown\n";
    else
      std::cout << mItr->second << '\n';
  }
}

bool add(char *c)
{
  std::map<char,int>::iterator mItr;
  mItr = map.find(*c);
  return !(mItr == map.end());
}

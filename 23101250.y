%{
#include<bits/stdc++.h>
#include "symbol_info.h"

using namespace std;

#define YYSTYPE symbol_info*

int yyparse(void);
int yylex(void);
extern FILE *yyin;

void yyerror(const char *s);

ofstream outlog;
int lines = 1;

string logString;


%}




%token IF ELSE FOR WHILE DO BREAK INT CHAR FLOAT DOUBLE VOID RETURN CONTINUE SWITCH DEFAULT CASE GOTO PRINTLN LPAREN RPAREN LCURL RCURL LTHIRD RTHIRD COMMA SEMICOLON COLON ADDOP MULOP INCOP DECOP RELOP LOGICOP ASSIGNOP NOT CONST_INT CONST_FLOAT ID

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%right ASSIGNOP

%left LOGICOP
%left RELOP
%left ADDOP
%left MULOP

%right NOT
%right INCOP DECOP

%start start


%%

start
    : program
    {
        $$ = new symbol_info($1->get_name(), "start");

        outlog << "Line " << lines
               << ": start : program\n\n";

        outlog << $$->get_name() << "\n\n";
    }
    ;

program
    : program unit
    {
        $$ = new symbol_info(
                $1->get_name() + "\n" + $2->get_name(),
                "program"
        );

        outlog << "Line " << lines
               << ": program : program unit\n\n";

        outlog << $$->get_name() << "\n\n";
    }

    | unit
    {
        $$ = new symbol_info(
                $1->get_name(),
                "program"
        );

        outlog << "Line " << lines
               << ": program : unit\n\n";

        outlog << $$->get_name() << "\n\n";
    }
    ;


unit
    : variable_decl
    {
        $$ = new symbol_info(
                $1->get_name(),
                "unit"
        );

        outlog << "Line " << lines
               << ": unit : variable_decl\n\n";

        outlog << $$->get_name() << "\n\n";
    }

    | func_declaration
    {
        $$ = new symbol_info(
                $1->get_name(),
                "unit"
        );

        outlog << "Line " << lines
               << ": unit : func_declaration\n\n";

        outlog << $$->get_name() << "\n\n";
    }

    | func_definition
    {
        $$ = new symbol_info(
                $1->get_name(),
                "unit"
        );

        outlog << "Line " << lines
               << ": unit : func_definition\n\n";

        outlog << $$->get_name() << "\n\n";
    }
    ;

func_declaration
    : type_specifier ID LPAREN param_list RPAREN SEMICOLON
    {
        $$ = new symbol_info(
                $1->get_name() + " " +
                $2->get_name() +
                "(" +
                $4->get_name() +
                ")" +
                ";",
                "func_declaration"
        );

        outlog << "Line " << lines
               << ": func_declaration : type_specifier ID LPAREN param_list RPAREN SEMICOLON\n\n";

        outlog << $$->get_name() << "\n\n";
    }

    | type_specifier ID LPAREN RPAREN SEMICOLON
    {
        $$ = new symbol_info(
                $1->get_name() + " " +
                $2->get_name() +
                "();",
                "func_declaration"
        );

        outlog << "Line " << lines
               << ": func_declaration : type_specifier ID LPAREN RPAREN SEMICOLON\n\n";

        outlog << $$->get_name() << "\n\n";
    }
    ;

variable_decl
    : type_specifier declaration_list SEMICOLON
    {
        $$ = new symbol_info(
                $1->get_name()+" "+
                $2->get_name()+";",
                "variable_decl");

        outlog<<"Line "<<lines<<": variable_decl : type_specifier declaration_list SEMICOLON\n\n";
        outlog<<$$->get_name()<<"\n\n";
    }
;

func_definition
    : type_specifier ID LPAREN param_list RPAREN compound_statement
    {
        $$ = new symbol_info(
                $1->get_name() + " " +
                $2->get_name() +
                "(" +
                $4->get_name() +
                ")" +
                $6->get_name(),
                "func_definition"
        );

        outlog << "Line " << lines
               << ": func_definition : type_specifier ID LPAREN param_list RPAREN compound_statement\n\n";

        outlog << $$->get_name() << "\n\n";
    }

    | type_specifier ID LPAREN RPAREN compound_statement
    {
        $$ = new symbol_info(
                $1->get_name() + " " +
                $2->get_name() +
                "()" +
                $5->get_name(),
                "func_definition"
        );

        outlog << "Line " << lines
               << ": func_definition : type_specifier ID LPAREN RPAREN compound_statement\n\n";

        outlog << $$->get_name() << "\n\n";
    }
    ;

param_list
    : param_list COMMA type_specifier ID
    {
        $$ = new symbol_info(
                $1->get_name() + "," +
                $3->get_name() + " " +
                $4->get_name(),
                "param_list"
        );

        outlog << "Line " << lines
               << ": param_list : param_list COMMA type_specifier ID\n\n";

        outlog << $$->get_name() << "\n\n";
    }

    | param_list COMMA type_specifier
    {
        $$ = new symbol_info(
                $1->get_name() + "," +
                $3->get_name(),
                "param_list"
        );

        outlog << "Line " << lines
               << ": param_list : param_list COMMA type_specifier\n\n";

        outlog << $$->get_name() << "\n\n";
    }

    | type_specifier ID
    {
        $$ = new symbol_info(
                $1->get_name() + " " +
                $2->get_name(),
                "param_list"
        );

        outlog << "Line " << lines
               << ": param_list : type_specifier ID\n\n";

        outlog << $$->get_name() << "\n\n";
    }

    | type_specifier
    {
        $$ = new symbol_info(
                $1->get_name(),
                "param_list"
        );

        outlog << "Line " << lines
               << ": param_list : type_specifier\n\n";

        outlog << $$->get_name() << "\n\n";
    }
    ;

compound_statement
    : LCURL statements RCURL
    {
        $$ = new symbol_info(
                "{\n" +
                $2->get_name() +
                "\n}",
                "compound_statement"
        );

        outlog << "Line " << lines
               << ": compound_statement : LCURL statements RCURL\n\n";

        outlog << $$->get_name() << "\n\n";
    }

    | LCURL RCURL
    {
        $$ = new symbol_info(
                "{\n}",
                "compound_statement"
        );

        outlog << "Line " << lines
               << ": compound_statement : LCURL RCURL\n\n";

        outlog << $$->get_name() << "\n\n";
    }
    ;

type_specifier
    : INT
    {
        $$ = new symbol_info("int","type_specifier");

        outlog << "Line " << lines
               << ": type_specifier : INT\n\n";

        outlog << $$->get_name() << "\n\n";
    }

    | FLOAT
    {
        $$ = new symbol_info("float","type_specifier");

        outlog << "Line " << lines
               << ": type_specifier : FLOAT\n\n";

        outlog << $$->get_name() << "\n\n";
    }

    | VOID
    {
        $$ = new symbol_info("void","type_specifier");

        outlog << "Line " << lines
               << ": type_specifier : VOID\n\n";

        outlog << $$->get_name() << "\n\n";
    }

    | CHAR
    {
        $$ = new symbol_info("char","type_specifier");

        outlog << "Line " << lines
               << ": type_specifier : CHAR\n\n";

        outlog << $$->get_name() << "\n\n";
    }
    ;

declaration_list
    : declaration_list COMMA ID
    {
        $$ = new symbol_info(
                $1->get_name() + "," +
                $3->get_name(),
                "declaration_list"
        );

        outlog << "Line " << lines
               << ": declaration_list : declaration_list COMMA ID\n\n";

        outlog << $$->get_name() << "\n\n";
    }

    | declaration_list COMMA ID LTHIRD CONST_INT RTHIRD
    {
        $$ = new symbol_info(
                $1->get_name() + "," +
                $3->get_name() +
                "[" +
                $5->get_name() +
                "]",
                "declaration_list"
        );

        outlog << "Line " << lines
               << ": declaration_list : declaration_list COMMA ID LTHIRD CONST_INT RTHIRD\n\n";

        outlog << $$->get_name() << "\n\n";
    }

    | ID
    {
        $$ = new symbol_info(
                $1->get_name(),
                "declaration_list"
        );

        outlog << "Line " << lines
               << ": declaration_list : ID\n\n";

        outlog << $$->get_name() << "\n\n";
    }

    | ID LTHIRD CONST_INT RTHIRD
    {
        $$ = new symbol_info(
                $1->get_name() +
                "[" +
                $3->get_name() +
                "]",
                "declaration_list"
        );

        outlog << "Line " << lines
               << ": declaration_list : ID LTHIRD CONST_INT RTHIRD\n\n";

        outlog << $$->get_name() << "\n\n";
    }
    ;

statements
    : statement
    {
        $$ = new symbol_info(
                $1->get_name(),
                "statements"
        );

        outlog << "Line " << lines
               << ": statements : statement\n\n";

        outlog << $$->get_name() << "\n\n";
    }

    | statements statement
    {
        $$ = new symbol_info(
                $1->get_name() + "\n" +
                $2->get_name(),
                "statements"
        );

        outlog << "Line " << lines
               << ": statements : statements statement\n\n";

        outlog << $$->get_name() << "\n\n";
    }
    ;

statement
    : variable_decl
    {
        $$ = new symbol_info($1->get_name(),"statement");

        outlog << "Line " << lines
               << ": statement : variable_decl\n\n";

        outlog << $$->get_name() << "\n\n";
    }

    | expression_statement
    {
        $$ = new symbol_info($1->get_name(),"statement");

        outlog << "Line " << lines
               << ": statement : expression_statement\n\n";

        outlog << $$->get_name() << "\n\n";
    }

    | compound_statement
    {
        $$ = new symbol_info($1->get_name(),"statement");

        outlog << "Line " << lines
               << ": statement : compound_statement\n\n";

        outlog << $$->get_name() << "\n\n";
    }

    | FOR LPAREN expression_statement expression_statement expression RPAREN statement
    {
        $$ = new symbol_info(
                "for(" +
                $3->get_name() +
                $4->get_name() +
                $5->get_name() +
                ")" +
                $7->get_name(),
                "statement"
        );

        outlog << "Line " << lines
               << ": statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement\n\n";

        outlog << $$->get_name() << "\n\n";
    }

    | IF LPAREN expression RPAREN statement %prec LOWER_THAN_ELSE
    {
        $$ = new symbol_info(
                "if(" +
                $3->get_name() +
                ")" +
                $5->get_name(),
                "statement"
        );

        outlog << "Line " << lines
               << ": statement : IF LPAREN expression RPAREN statement\n\n";

        outlog << $$->get_name() << "\n\n";
    }

    | IF LPAREN expression RPAREN statement ELSE statement
    {
        $$ = new symbol_info(
                "if(" +
                $3->get_name() +
                ")" +
                $5->get_name() +
                "else " +
                $7->get_name(),
                "statement"
        );

        outlog << "Line " << lines
               << ": statement : IF LPAREN expression RPAREN statement ELSE statement\n\n";

        outlog << $$->get_name() << "\n\n";
    }

    | WHILE LPAREN expression RPAREN statement
    {
        $$ = new symbol_info(
                "while(" +
                $3->get_name() +
                ")" +
                $5->get_name(),
                "statement"
        );

        outlog << "Line " << lines
               << ": statement : WHILE LPAREN expression RPAREN statement\n\n";

        outlog << $$->get_name() << "\n\n";
    }

    | PRINTLN LPAREN ID RPAREN SEMICOLON
    {
        $$ = new symbol_info(
                "printf(" +
                $3->get_name() +
                ");",
                "statement"
        );

        outlog << "Line " << lines
               << ": statement : PRINTLN LPAREN ID RPAREN SEMICOLON\n\n";

        outlog << $$->get_name() << "\n\n";
    }

    | RETURN expression SEMICOLON
    {
        $$ = new symbol_info(
                "return " +
                $2->get_name() +
                ";",
                "statement"
        );

        outlog << "Line " << lines
               << ": statement : RETURN expression SEMICOLON\n\n";

        outlog << $$->get_name() << "\n\n";
    }
    ;

expression_statement
    : SEMICOLON
    {
        $$ = new symbol_info(";", "expression_statement");

        outlog << "Line " << lines
               << ": expression_statement : SEMICOLON\n\n";

        outlog << $$->get_name() << "\n\n";
    }

    | expression SEMICOLON
    {
        $$ = new symbol_info(
                $1->get_name() + ";",
                "expression_statement"
        );

        outlog << "Line " << lines
               << ": expression_statement : expression SEMICOLON\n\n";

        outlog << $$->get_name() << "\n\n";
    }
    ;

variable
    : ID
    {
        $$ = new symbol_info(
                $1->get_name(),
                "variable"
        );

        outlog << "Line " << lines
               << ": variable : ID\n\n";

        outlog << $$->get_name() << "\n\n";
    }

    | ID LTHIRD expression RTHIRD
    {
        $$ = new symbol_info(
                $1->get_name() +
                "[" +
                $3->get_name() +
                "]",
                "variable"
        );

        outlog << "Line " << lines
               << ": variable : ID LTHIRD expression RTHIRD\n\n";

        outlog << $$->get_name() << "\n\n";
    }
    ;

expression
    : logic_expression
    {
        $$ = new symbol_info(
                $1->get_name(),
                "expression"
        );

        outlog << "Line " << lines
               << ": expression : logic_expression\n\n";

        outlog << $$->get_name() << "\n\n";
    }

    | variable ASSIGNOP logic_expression
    {
        $$ = new symbol_info(
                $1->get_name() +
                "=" +
                $3->get_name(),
                "expression"
        );

        outlog << "Line " << lines
               << ": expression : variable ASSIGNOP logic_expression\n\n";

        outlog << $$->get_name() << "\n\n";
    }
    ;

logic_expression
    : rel_expression
    {
        $$ = new symbol_info(
                $1->get_name(),
                "logic_expression"
        );

        outlog << "Line " << lines
               << ": logic_expression : rel_expression\n\n";

        outlog << $$->get_name() << "\n\n";
    }

    | rel_expression LOGICOP rel_expression
    {
        $$ = new symbol_info(
                $1->get_name() +
                $2->get_name() +
                $3->get_name(),
                "logic_expression"
        );

        outlog << "Line " << lines
               << ": logic_expression : rel_expression LOGICOP rel_expression\n\n";

        outlog << $$->get_name() << "\n\n";
    }
    ;
rel_expression
    : simple_expression
    {
        $$ = new symbol_info(
                $1->get_name(),
                "rel_expression"
        );

        outlog << "Line " << lines
               << ": rel_expression : simple_expression\n\n";

        outlog << $$->get_name() << "\n\n";
    }

    | simple_expression RELOP simple_expression
    {
        $$ = new symbol_info(
                $1->get_name() +
                $2->get_name() +
                $3->get_name(),
                "rel_expression"
        );

        outlog << "Line " << lines
               << ": rel_expression : simple_expression RELOP simple_expression\n\n";

        outlog << $$->get_name() << "\n\n";
    }
    ;

simple_expression
    : term
    {
        $$ = new symbol_info(
                $1->get_name(),
                "simple_expression"
        );

        outlog << "Line " << lines
               << ": simple_expression : term\n\n";

        outlog << $$->get_name() << "\n\n";
    }

    | simple_expression ADDOP term
    {
        $$ = new symbol_info(
                $1->get_name() +
                $2->get_name() +
                $3->get_name(),
                "simple_expression"
        );

        outlog << "Line " << lines
               << ": simple_expression : simple_expression ADDOP term\n\n";

        outlog << $$->get_name() << "\n\n";
    }
    ;

term
    : unary_expression
    {
        $$ = new symbol_info(
                $1->get_name(),
                "term"
        );

        outlog << "Line " << lines
               << ": term : unary_expression\n\n";

        outlog << $$->get_name() << "\n\n";
    }

    | term MULOP unary_expression
    {
        $$ = new symbol_info(
                $1->get_name() +
                $2->get_name() +
                $3->get_name(),
                "term"
        );

        outlog << "Line " << lines
               << ": term : term MULOP unary_expression\n\n";

        outlog << $$->get_name() << "\n\n";
    }
    ;

unary_expression
    : ADDOP unary_expression
    | NOT unary_expression
    | factor_info
    ;

factor_info
    : factor
    {
        $$ = new symbol_info(
                $1->get_name(),
                "factor_info");

        outlog<<"Line "<<lines<<": factor_info : factor\n\n";
        outlog<<$$->get_name()<<"\n\n";
    }
;

factor
    : variable
    {
        $$ = new symbol_info(
                $1->get_name(),
                "factor"
        );

        outlog << "Line " << lines
               << ": factor : variable\n\n";

        outlog << $$->get_name() << "\n\n";
    }

    | ID LPAREN argument_list RPAREN
    {
        $$ = new symbol_info(
                $1->get_name() +
                "(" +
                $3->get_name() +
                ")",
                "factor"
        );

        outlog << "Line " << lines
               << ": factor : ID LPAREN argument_list RPAREN\n\n";

        outlog << $$->get_name() << "\n\n";
    }

    | LPAREN expression RPAREN
    {
        $$ = new symbol_info(
                "(" +
                $2->get_name() +
                ")",
                "factor"
        );

        outlog << "Line " << lines
               << ": factor : LPAREN expression RPAREN\n\n";

        outlog << $$->get_name() << "\n\n";
    }

    | CONST_INT
    {
        $$ = new symbol_info(
                $1->get_name(),
                "factor"
        );

        outlog << "Line " << lines
               << ": factor : CONST_INT\n\n";

        outlog << $$->get_name() << "\n\n";
    }

    | CONST_FLOAT
    {
        $$ = new symbol_info(
                $1->get_name(),
                "factor"
        );

        outlog << "Line " << lines
               << ": factor : CONST_FLOAT\n\n";

        outlog << $$->get_name() << "\n\n";
    }

    | variable INCOP
    {
        $$ = new symbol_info(
                $1->get_name() +
                "++",
                "factor"
        );

        outlog << "Line " << lines
               << ": factor : variable INCOP\n\n";

        outlog << $$->get_name() << "\n\n";
    }

    | variable DECOP
    {
        $$ = new symbol_info(
                $1->get_name() +
                "--",
                "factor"
        );

        outlog << "Line " << lines
               << ": factor : variable DECOP\n\n";

        outlog << $$->get_name() << "\n\n";
    }
    ;

argument_list
    : arguments
    {
        $$ = new symbol_info(
                $1->get_name(),
                "argument_list"
        );

        outlog << "Line " << lines
               << ": argument_list : arguments\n\n";

        outlog << $$->get_name() << "\n\n";
    }

    |
    {
        $$ = new symbol_info(
                "",
                "argument_list"
        );

        outlog << "Line " << lines
               << ": argument_list : empty\n\n";

        outlog << "\n";
    }
    ;

arguments
    : arguments COMMA logic_expression
    {
        $$ = new symbol_info(
                $1->get_name() +
                "," +
                $3->get_name(),
                "arguments"
        );

        outlog << "Line " << lines
               << ": arguments : arguments COMMA logic_expression\n\n";

        outlog << $$->get_name() << "\n\n";
    }

    | logic_expression
    {
        $$ = new symbol_info(
                $1->get_name(),
                "arguments"
        );

        outlog << "Line " << lines
               << ": arguments : logic_expression\n\n";

        outlog << $$->get_name() << "\n\n";
    }
    ;

%%

int main(int argc,char *argv[])
{
    if(argc!=2)
    {
        cout<<"Please provide input file"<<endl;
        return 0;
    }

    yyin=fopen(argv[1],"r");

    if(yyin==NULL)
    {
        cout<<"Cannot open input file"<<endl;
        return 0;
    }

    outlog.open("log.txt");

    yyparse();

    outlog << endl;
    outlog << "Total Lines: " << lines << endl;

    outlog.close();
    fclose(yyin);

    return 0;
}

void yyerror(const char *s)
{
    outlog << "Error at line " << lines << ": " << s << endl;
}
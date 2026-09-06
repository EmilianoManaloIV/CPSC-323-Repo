/* =========================
 * This is a starter Flex source file for HW1 Part II.
 * A Flex source file contains three sections: 1. Definitions Section / 2. Rules Section / 3. User Code Section
 *
 * 1. DEFINITIONS SECTION
 * YOUR TODO: Define token patterns that can identify all required tokens in the input source code file (inputsourcecode.txt) and satisfy the other requirements specified in HW1.
 * Some token definitions are provided in the starter code for your reference. 
 * (Optional) Your are welcome to extend your definitions to handle additional cases commonly found in real programming languages.
 *
 * 2. RULES SECTION
 * YOUR TODO: Add rules to recognize all required tokens and satisfy the other requirements specified in HW1.
 *
 * 3. USER CODE SECTION
 * YOUR TODO: Update the input source code filename.
 *
 * Begin Flex implementation in your system using this provided starter code (if you choose to use Flex)
 *
 * You are responsible for checking and debugging Flex syntax issues during development.
 * ========================= */

%option noyywrap
%option yylineno

%{
#include <stdio.h>
#include <stdlib.h>

FILE *fout = NULL;   /* output file handle */

void handle_lexical_error(const char *lexeme);
%}




DIGIT       [0-9]
LETTER      [A-Za-z_]
UNDERSCORE  [_]

/* identifier */
ID  ({LETTER}|{UNDERSCORE})({LETTER}|{DIGIT})*

/* integer */
INTEGER  0|[1-9][0-9]*
BAD_INTEGER 0[0-9]+

/* keyword */
KEYWORD  (int|for|if|else|while|cout|return)

/* string */
STRING \"[^\"\n]*\"

/* operator: single-char */
OP1  [><=/+*%-]
/* operator: double-char */
OP2  (==|!=|<=|>=|\+=|-=|\*=|\/=|&&|\|\||<<)
/* whitespace */
WS  [ \t\r\n]+

/* single-line comments */
LINECOMMENT  \/\/[^\n]*

/* parentheses */
PARENS  [\[\]\(\)\{\}]

/* punctuation */
PUNC  [;,.:]

%%

    /* === 2.RULES SECTION === */

{WS}                 { /* ignore */ }

{LINECOMMENT}        { /* ignore */ }


{KEYWORD}            { fprintf(stdout, "%-30s %-20s\n", yytext, "KEYWORD");
                          if (fout) fprintf(fout, "%-30s %-20s\n", yytext, "KEYWORD");}

{BAD_INTEGER}        { handle_lexical_error(yytext);}

{INTEGER}            { fprintf(stdout, "%-30s %-20s\n", yytext, "INTEGER");
                          if (fout) fprintf(fout, "%-30s %-20s\n", yytext, "INTEGER");}

{ID}                 { fprintf(stdout, "%-30s %-20s\n", yytext, "IDENTIFIER");
                          if (fout) fprintf(fout, "%-30s %-20s\n", yytext, "IDENTIFIER");}

{OP2}                {fprintf(stdout, "%-30s %-20s\n", yytext, "OPERATOR");
                          if (fout) fprintf(fout, "%-30s %-20s\n", yytext, "OPERATOR");}

{OP1}                { fprintf(stdout, "%-30s %-20s\n", yytext, "OPERATOR");
                          if (fout) fprintf(fout, "%-30s %-20s\n", yytext, "OPERATOR");}

{PARENS}             { fprintf(stdout, "%-30s %-20s\n", yytext, "PARENTHESES");
                          if (fout) fprintf(fout, "%-30s %-20s\n", yytext, "PARENTHESES"); }

{PUNC}               { fprintf(stdout, "%-30s %-20s\n", yytext, "PUNCTUATION");
                          if (fout) fprintf(fout, "%-30s %-20s\n", yytext, "PUNCTUATION"); }

{STRING}             { fprintf(stdout, "%-30s %-20s\n", yytext, "STRING");
                       if (fout) fprintf(fout, "%-30s %-20s\n", yytext, "STRING"); }

.                    { handle_lexical_error(yytext);} 

%%

    /* === 3. USER CODE SECTION === */

void handle_lexical_error (const char *lexeme)
{
    fprintf(stdout, "%-30s %-20s\n", lexeme, "LEXICAL ERROR"); 
    if (fout) fprintf(fout, "%-30s %-20s\n", lexeme, "LEXICAL ERROR"); 
    fprintf(stderr, "Lexical error '%s' is at line %d:\n", lexeme, yylineno);
}

int main(void)
{

    /* open "inputsourcecode.txt" as yyin */
    yyin = fopen("inputsourcecode.txt", "r");
    if (!yyin) {
        perror("Failed to open sourcecode.txt");
        return 1;
    }

    /* open "output" file for writing */
    fout = fopen("output", "w");
    if (!fout) {
        perror("Failed to open output");
        fclose(yyin);
        return 1;
    }

    /* table header */
    fprintf(stdout, "%-30s %-20s\n", "Lexeme", "Token");
    fprintf(stdout, "%-30s %-20s\n", "------", "-----");
    fprintf(fout,   "%-30s %-20s\n", "Lexeme", "Token");
    fprintf(fout,   "%-30s %-20s\n", "------", "-----");

    /* run scanner */
    yylex();

    fclose(fout);
    fclose(yyin);
    return 0;
}
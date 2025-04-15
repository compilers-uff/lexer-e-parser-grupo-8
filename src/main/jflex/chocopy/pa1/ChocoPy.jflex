package chocopy.pa1;
import java_cup.runtime.*;
import java.util.Stack;

%%

/*** Do not change the flags below unless you know what you are doing. ***/

%unicode
%line
%column

%class ChocoPyLexer
%public

%cupsym ChocoPyTokens
%cup
%cupdebug

%eofclose false

/*** Do not change the flags above unless you know what you are doing. ***/

/* The following code section is copied verbatim to the
 * generated lexer class. */
%{
    /* The code below includes some convenience methods to create tokens
     * of a given type and optionally a value that the CUP parser can
     * understand. Specifically, a lot of the logic below deals with
     * embedded information about where in the source code a given token
     * was recognized, so that the parser can report errors accurately.
     * (It need not be modified for this project.) */

    /** Producer of token-related values for the parser. */
    final ComplexSymbolFactory symbolFactory = new ComplexSymbolFactory();

    /** Return a terminal symbol of syntactic category TYPE and no
     *  semantic value at the current source location. */
    private Symbol symbol(int type) {
        return symbol(type, yytext());
    }

    /** Return a terminal symbol of syntactic category TYPE and semantic
     *  value VALUE at the current source location. */
    private Symbol symbol(int type, Object value) {
        return symbolFactory.newSymbol(ChocoPyTokens.terminalNames[type], type,
            new ComplexSymbolFactory.Location(yyline + 1, yycolumn + 1),
            new ComplexSymbolFactory.Location(yyline + 1,yycolumn + yylength()),
            value);
    }

    // Pilha para rastrear níveis de indentação
    private Stack<Integer> indentStack = new Stack<Integer>() {{ push(0); }};
    private boolean atStartOfLine = true;
    private int currentIndent = 0;


%}

/* Macros (regexes used in rules below) */

WhiteSpace = [ \t]
LineBreak  = \r|\n|\r\n
IntegerLiteral = 0 | [1-9][0-9]*
Letter = [a-zA-Z_]
Digit = [0-9]
Identifier = {Letter}({Letter}|{Digit})*
Comment = \#.*

%%


<YYINITIAL> {

  /* Delimiters. */
  {LineBreak}                 { atStartOfLine = true; return symbol(ChocoPyTokens.NEWLINE); }

    // --- Linhas sem whitespace no início (DEDENT explícito) ---
    ^[^ \t]+ {
        if (atStartOfLine) {
            int top = indentStack.peek();
            if (top > 0) {
                // 1. Emite DEDENT
                indentStack.pop();
                System.out.println(yylength());
                yypushback(yylength());
                System.out.println(yylength());
                // 3. Força reprocessamento
                atStartOfLine = false; 
                System.out.println(atStartOfLine);
                yybegin(YYINITIAL);
                return symbol(ChocoPyTokens.DEDENT);
            }
            atStartOfLine = false;
        }
    }


    // Verifica indentação no início da linha
    ^{WhiteSpace}+     {
                          if (atStartOfLine) {
            currentIndent = yytext().replace("\t", "    ").length();
            int top = indentStack.peek();
            if (currentIndent > top) {
                indentStack.push(currentIndent);
                return symbol(ChocoPyTokens.INDENT);
            } else if (currentIndent < top) {
                indentStack.pop();
                yypushback(yylength());
                return symbol(ChocoPyTokens.DEDENT);
            }
            atStartOfLine = false;
        }
                       }    

    // --- Ignora whitespace no meio da linha ---
    {WhiteSpace}+     { /* Ignora espaços/tabs fora do início da linha */ }


  /* Literals. */
  {IntegerLiteral}            { return symbol(ChocoPyTokens.NUMBER, Integer.parseInt(yytext())); }

  /* Operators. */
  "+"                         { return symbol(ChocoPyTokens.PLUS); }
  "-"                         { return symbol(ChocoPyTokens.MINUS); }
  "*"                         { return symbol(ChocoPyTokens.TIMES); }
  "//"                        { return symbol(ChocoPyTokens.DIVIDE); }
  "%"                         { return symbol(ChocoPyTokens.MOD); }
  "="                         { return symbol(ChocoPyTokens.ASSIGN); }
  "=="                        { return symbol(ChocoPyTokens.EQ); }
  "!="                        { return symbol(ChocoPyTokens.NEQ); }
  "<"                         { return symbol(ChocoPyTokens.LT); }
  ">"                         { return symbol(ChocoPyTokens.GT); }
  ">="                        { return symbol(ChocoPyTokens.GEQ); }
  "<="                        { return symbol(ChocoPyTokens.LEQ); }

  /* Delimiters. */
  "("                         { return symbol(ChocoPyTokens.LPAREN); }
  ")"                         { return symbol(ChocoPyTokens.RPAREN); }
  "{"                         { return symbol(ChocoPyTokens.LBRACE); }
  "}"                         { return symbol(ChocoPyTokens.RBRACE); }
  "["                         { return symbol(ChocoPyTokens.LBRACKET); }
  "]"                         { return symbol(ChocoPyTokens.RBRACKET); }
  ","                         { return symbol(ChocoPyTokens.COMMA); }
  ":"                         { return symbol(ChocoPyTokens.COLON); }
  "."                         { return symbol(ChocoPyTokens.DOT); }
  "->"                        { return symbol(ChocoPyTokens.ARROW); }
  
  /* Keywords. */
  "if"                        { return symbol(ChocoPyTokens.IF); }
  "elif"                      { return symbol(ChocoPyTokens.ELIF); }
  "else"                      { return symbol(ChocoPyTokens.ELSE); }
  "while"                     { return symbol(ChocoPyTokens.WHILE); }
  "for"                       { return symbol(ChocoPyTokens.FOR); }
  "def"                       { return symbol(ChocoPyTokens.DEF); }
  "return"                    { return symbol(ChocoPyTokens.RETURN); }
  "class"                     { return symbol(ChocoPyTokens.CLASS); }
  "print"                     { return symbol(ChocoPyTokens.PRINT); }
  "None"                      { return symbol(ChocoPyTokens.NONE); }
  "True"                      { return symbol(ChocoPyTokens.TRUE); }
  "False"                     { return symbol(ChocoPyTokens.FALSE); }
  "pass"                      { return symbol(ChocoPyTokens.PASS); }
  "is"                        { return symbol(ChocoPyTokens.IS); }
  "in"                        { return symbol(ChocoPyTokens.IN); }
  "global"                    { return symbol(ChocoPyTokens.GLOBAL); }
  "nonlocal"                  { return symbol(ChocoPyTokens.NONLOCAL); }
  "not"                       { return symbol(ChocoPyTokens.NOT); }

  /* Identifiers. */
  {Identifier}                { return symbol(ChocoPyTokens.IDENTIFIER, yytext()); }

  /* Ignore */
  {Comment}                   { /* Ignora comentários */ }
}

<<EOF>>                       { 
    if (!indentStack.isEmpty()) {
        indentStack.pop(); // Remove o 0 inicial
        while (!indentStack.isEmpty()) {
            indentStack.pop();
            return symbol(ChocoPyTokens.DEDENT);
        }
    }
    return symbol(ChocoPyTokens.EOF); }

/* Error fallback. */
[^]                           { return symbol(ChocoPyTokens.UNRECOGNIZED); }

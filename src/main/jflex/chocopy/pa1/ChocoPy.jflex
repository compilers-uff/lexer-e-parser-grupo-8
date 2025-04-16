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

%xstate IDENTATION
%xstate BODY


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

    // --- Linhas sem whitespace no início (DEDENT explícito) ---
    [^ \t]+ {
        if (atStartOfLine) {
          //  System.out.println(atStartOfLine);
            yypushback(yylength());
            yybegin(IDENTATION);
        }
        else{
          //  System.out.println(atStartOfLine);
            yypushback(yylength());
            yybegin(BODY);
        }
    }


    // Verifica indentação no início da linha
    ^{WhiteSpace}+     {
                          if (atStartOfLine) {
                            yypushback(yylength());
            yybegin(IDENTATION);
        }
                       }    

    // --- Ignora whitespace no meio da linha ---
    {WhiteSpace}+     { /* Ignora espaços/tabs fora do início da linha */ }


  
}


<BODY>{

    /* Delimiters. */
  {LineBreak}                 { atStartOfLine = true; yybegin(YYINITIAL); return symbol(ChocoPyTokens.NEWLINE); }


    /* Literals. */
  {IntegerLiteral}            { yybegin(YYINITIAL); return symbol(ChocoPyTokens.NUMBER, Integer.parseInt(yytext())); }

  /* Operators. */
  "+"                         { yybegin(YYINITIAL); return symbol(ChocoPyTokens.PLUS); }
  "-"                         { yybegin(YYINITIAL); return symbol(ChocoPyTokens.MINUS); }
  "*"                         { yybegin(YYINITIAL); return symbol(ChocoPyTokens.TIMES); }
  "//"                        { yybegin(YYINITIAL); return symbol(ChocoPyTokens.DIVIDE); }
  "%"                         { yybegin(YYINITIAL); return symbol(ChocoPyTokens.MOD); }
  "="                         { yybegin(YYINITIAL); return symbol(ChocoPyTokens.ASSIGN); }
  "=="                        { yybegin(YYINITIAL); return symbol(ChocoPyTokens.EQ); }
  "!="                        { yybegin(YYINITIAL); return symbol(ChocoPyTokens.NEQ); }
  "<"                         { yybegin(YYINITIAL); return symbol(ChocoPyTokens.LT); }
  ">"                         { yybegin(YYINITIAL); return symbol(ChocoPyTokens.GT); }
  ">="                        { yybegin(YYINITIAL); return symbol(ChocoPyTokens.GEQ); }
  "<="                        { yybegin(YYINITIAL); return symbol(ChocoPyTokens.LEQ); }

  /* Delimiters. */
  "("                         { yybegin(YYINITIAL); return symbol(ChocoPyTokens.LPAREN); }
  ")"                         { yybegin(YYINITIAL); return symbol(ChocoPyTokens.RPAREN); }
  "{"                         { yybegin(YYINITIAL); return symbol(ChocoPyTokens.LBRACE); }
  "}"                         { yybegin(YYINITIAL); return symbol(ChocoPyTokens.RBRACE); }
  "["                         { yybegin(YYINITIAL); return symbol(ChocoPyTokens.LBRACKET); }
  "]"                         { yybegin(YYINITIAL); return symbol(ChocoPyTokens.RBRACKET); }
  ","                         { yybegin(YYINITIAL); return symbol(ChocoPyTokens.COMMA); }
  ":"                         { yybegin(YYINITIAL); return symbol(ChocoPyTokens.COLON); }
  "."                         { yybegin(YYINITIAL); return symbol(ChocoPyTokens.DOT); }
  "->"                        { yybegin(YYINITIAL); return symbol(ChocoPyTokens.ARROW); }
  
  /* Keywords. */
  "if"                        { yybegin(YYINITIAL); return symbol(ChocoPyTokens.IF); }
  "elif"                      { yybegin(YYINITIAL); return symbol(ChocoPyTokens.ELIF); }
  "else"                      { yybegin(YYINITIAL); return symbol(ChocoPyTokens.ELSE); }
  "while"                     { yybegin(YYINITIAL); return symbol(ChocoPyTokens.WHILE); }
  "for"                       { yybegin(YYINITIAL); return symbol(ChocoPyTokens.FOR); }
  "def"                       { yybegin(YYINITIAL); return symbol(ChocoPyTokens.DEF); }
  "return"                    { yybegin(YYINITIAL); return symbol(ChocoPyTokens.RETURN); }
  "class"                     { yybegin(YYINITIAL); return symbol(ChocoPyTokens.CLASS); }
  "print"                     { yybegin(YYINITIAL); return symbol(ChocoPyTokens.PRINT); }
  "None"                      { yybegin(YYINITIAL); return symbol(ChocoPyTokens.NONE); }
  "True"                      { yybegin(YYINITIAL); return symbol(ChocoPyTokens.TRUE); }
  "False"                     { yybegin(YYINITIAL); return symbol(ChocoPyTokens.FALSE); }
  "pass"                      { yybegin(YYINITIAL); return symbol(ChocoPyTokens.PASS); }
  "is"                        { yybegin(YYINITIAL); return symbol(ChocoPyTokens.IS); }
  "in"                        { yybegin(YYINITIAL); return symbol(ChocoPyTokens.IN); }
  "global"                    { yybegin(YYINITIAL); return symbol(ChocoPyTokens.GLOBAL); }
  "nonlocal"                  { yybegin(YYINITIAL); return symbol(ChocoPyTokens.NONLOCAL); }
  "not"                       { yybegin(YYINITIAL); return symbol(ChocoPyTokens.NOT); }

  /* Identifiers. */
  {Identifier}                { yybegin(YYINITIAL); return symbol(ChocoPyTokens.IDENTIFIER, yytext()); }

  /* Ignore */
  {Comment}                   { yybegin(YYINITIAL); /* Ignora comentários */ }
}


<IDENTATION>{

    // Verifica indentação no início da linha
    ^{WhiteSpace}+     {
            if (atStartOfLine) {
            currentIndent = yytext().replace("\t", "    ").length();
            int top = indentStack.peek();
            
            if (currentIndent > top) {
                indentStack.push(currentIndent);
                atStartOfLine = false;
                yybegin(YYINITIAL);
                return symbol(ChocoPyTokens.INDENT);
            } else if (currentIndent < top) {
                indentStack.pop();
                yypushback(yylength());
                atStartOfLine = false;
                yybegin(YYINITIAL);
                return symbol(ChocoPyTokens.DEDENT);
            } else {
                atStartOfLine = false;
                yybegin(YYINITIAL);
            }
        }
    }   

    ^[^ \t]+ {
        if (atStartOfLine) {
            int top = indentStack.peek();
            if (top > 0) {
                indentStack.pop();
                yypushback(yylength());
                atStartOfLine = false;
                yybegin(YYINITIAL);
                return symbol(ChocoPyTokens.DEDENT);
            } else {
                yypushback(yylength());
                atStartOfLine = false;
                yybegin(YYINITIAL);
            }
        }  
    } 

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

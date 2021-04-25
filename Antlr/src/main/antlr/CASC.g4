//header
grammar CASC;

@header {
package io.github.chaosunity.antlr;
}

//RULES
compilationUnit                 : classDeclaration EOF;
classDeclaration                : CLASS className '{' classBody '}';
className                       : ID;
classBody                       : function* ;
function                        : functionDeclaration block ;
functionDeclaration             : FUNC functionName '('(functionParameter (',' functionParameter)*)?')' (':' type)? ;
functionName                    : ID ;
functionParameter               : ID ':' type functionParameterDefaultValue? ;
functionParameterDefaultValue   : '=' expression ;
type                            : primitiveType
                                | classType
                                ;

primitiveType   :  ('boolean'   | '\u5e03\u6797') ('[' ']')*
                |  ('string'    | '\u5b57\u4e32') ('[' ']')*
                |  ('char'      | '\u5b57\u5143') ('[' ']')*
                |  ('byte'      | '\u4f4d\u5143') ('[' ']')*
                |  ('short'     | '\u77ed\u6574\u6578') ('[' ']')*
                |  ('int'       | '\u6574\u6578') ('[' ']')*
                |  ('long'      | '\u9577\u6574\u6578') ('[' ']')*
                |  ('float'     | '\u6d6e\u9ede\u6578') ('[' ']')*
                |  ('double'    | '\u500d\u6d6e\u9ede\u6578') ('[' ']')*
                |  ('void'      | '\u7a7a') ('[' ']')*
                ;

classType       : QUALIFIED_NAME ('[' ']')* ;

block           : '{' statement* '}' ;

statement       : block
                | variableDeclaration
                | printStatement
                | printlnStatement
                | functionCall
                | returnStatement
                | ifStatement
                ;

variableDeclaration     : VARIABLE name ('=' | '\u8ce6') expression;
printStatement          : PRINT '('expression')';
printlnStatement        : PRINTLN '('expression')';
returnStatement         : RETURN? expression                    #ReturnWithValue
                        | RETURN                                #ReturnVoid
                        ;
functionCall            : mod=(NEG | POS)? functionName '('argument? (',' argument)*')';
ifStatement             : IF ('(')? expression (')')? trueStatement=block (ELSE falseStatement=block)?;
name                    : ID ;
argument                : expression
                        | name '=' expression ;

expressionList          : expression? (',' expression)* ;
expression              : expression cmp=GREATER expression                                                     #conditionalExpression
                        | expression cmp=LESS expression                                                        #conditionalExpression
                        | expression cmp=EQ expression                                                          #conditionalExpression
                        | expression cmp=NOT_EQ expression                                                      #conditionalExpression
                        | expression cmp=GREATER_EQ expression                                                  #conditionalExpression
                        | expression cmp=LESS_EQ expression                                                     #conditionalExpression
                        | mod=(NEG | POS)? varReference                                                         #VarRef
                        | mod=(NEG | POS)? value                                                                #Val
                        | mod=(NEG | POS)? functionCall                                                         #FuncCall
                        | condition=expression '?' trueExpression=expression ':' falseExpression=expression     #IfExpr
                        | mod=(NEG | POS)? '('expression STAR expression')'                                     #ModMultiply       // The order of arithmetic expression are related to its actual operator precedence.
                        | expression STAR expression                                                            #Multiply
                        | mod=(NEG | POS)? '(' expression SLASH expression ')'                                  #ModDivide
                        | expression SLASH expression                                                           #Divide
                        | mod=(NEG | POS)? '(' expression PLUS expression ')'                                   #ModAdd
                        | expression PLUS expression                                                            #Add
                        | mod=(NEG | POS)? '(' expression MINUS expression ')'                                  #ModSubtract
                        | expression MINUS expression                                                           #Subtract
                        ;

varReference        : mod=(NEG | POS)? ID ;
value               : NUMBER
                    | STRING
                    | FALSE
                    | TRUE
                    ;

//TOKENS
fragment CHAR     :  ('A'..'Z') | ('a'..'z')        ;
fragment DIGIT    :  ('0'..'9')                     ;
fragment UNICODE  :  '\u0080'..'\uFFFF'             ;

CLASS           : 'class'   | '\u985e\u5225'        ;     // class, 類別
FUNC            : 'func'    | '\u51fd\u5f0f'        ;     // func, 函式
VARIABLE        : 'var'     | '\u8b8a\u6578'        ;     // var, 變數
IF              : 'if'      | '\u5982\u679c'        ;     // if, 如果
ELSE            : 'else'    | '\u5426\u5247'        ;     // else, 否則
RETURN          : 'return'  | '\u8fd4\u56de'        ;     // return, 返回

PRINT           : 'print'   | '\u5370\u51fa'        ;     // print, 印出
PRINTLN         : 'println' | '\u5370\u51fa\u884c'  ;     // println, 印出行

NEG             : '-' | '\u8ca0'                    ; // -, 負
POS             : '+' | '\u6b63'                    ; // +, 正

PLUS            : '+' | '\u52a0'                    ; // +, 加
MINUS           : '-' | '\u6e1b'                    ; // -, 減
STAR            : '*' | '\u4e58'                    ; // *, 乘
SLASH           : '/' | '\u9664'                    ; // /, 除
EQUALS          : '=' | '\u8ce6'                    ; // =, 賦          THIS EQUALS IS NOT WORKING PROPERLY SOMEHOW

GREATER         : '>'       | '\u5927\u65bc'        ;     // >, 大於
LESS            : '<'       | '\u5c0f\u65bc'        ;     // <, 小於
GREATER_EQ      : '>='      | '\u5927\u7b49\u65bc'  ;     // >=, 大等於
LESS_EQ         : '<='      | '\u5c0f\u7b49\u65bc'  ;     // <=, 小等於
EQ              : '=='      | '\u662f'              ;     // ==, 等於
NOT_EQ          : '!='      | '\u4e0d\u662f'        ;     // !=, 不等於

NUMBER          : [0-9]+                        ;
STRING          : '"'~('\r' | '\n' | '"')*'"'   ;
ID              : (CHAR|DIGIT|UNICODE)+         ;
TRUE            : 'true' | '\u771f'             ;
FALSE           : 'false' | '\u5047'            ;
QUALIFIED_NAME  : ID ('.' ID)+                  ;
WS              : [ \t\n\r]+ -> skip            ;
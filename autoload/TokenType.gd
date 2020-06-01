extends Node

enum {
	# Single-character tokens.                      
	LEFT_PAREN, RIGHT_PAREN, LEFT_BRACE, RIGHT_BRACE,
	COMMA, DOT, MINUS, PLUS, SEMICOLON, SLASH, STAR,

  # One or two character tokens.                  
	BANG, BANG_EQUAL,
	EQUAL, EQUAL_EQUAL,
	GREATER, GREATER_EQUAL,
	LESS, LESS_EQUAL,

  # Literals.
	IDENTIFIER, STRING, NUMBER,

  # Keywords.
	AND, CLASS, ELSE, FALSE, FUN, FOR, IF, NIL, OR,
	PRINT, RETURN, SUPER, THIS, TRUE, VAR, WHILE,

	EOF
}


var keywords := {
	'and': AND,
	'class': CLASS,
	'else': ELSE,
	'false': FALSE,
	'for': FOR,
	'fun': FUN,
	'if': IF,
	'nil': NIL, 
	'or': OR, 
	'print': PRINT,
	'return': RETURN,
	'super': SUPER,
	'this': THIS,
	'true': TRUE,
	'var': VAR,
	'while': WHILE
}

func get_keywords(text):
	
	if keywords.has(text):
		return keywords[text]
	
	return IDENTIFIER

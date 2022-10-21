extends LexerBase
class_name LexerLox

var _actions := [
	NumberAction.new(),
	IdentifierAction.new(),
	
	SingleLetterAction.new(),
	OperatorsAction.new(),
	
	CommentOrSlashAction.new(),
	WhiteSpaceAction.new(),
	NextLineAction.new(),
	
	StringAction.new(),
]
func get_actions() -> Array:
	return _actions



class StringAction:
	extends LexerActionBase
	
	func check(c):
		return c in ["'", "\""]
	
	func lex(lexer, symbol):
		
		while not lexer.is_at_end() and lexer.peek() != symbol:
			
			if lexer.peek() == '\n':
				lexer.next_line()
			
			lexer.advance()
		
		# Unterminated string.
		if lexer.is_at_end():
			ErrorHandler.error(lexer.line, 'Unterminated string.')
			return
		
		# The closing ".
		lexer.advance()
		
		# Trim the surrounding quotes
		lexer.add_token_literal(TokenType.STRING, lexer.selected_string())
		


class SingleLetterAction:
	extends LexerActionBase
	
	func check(c):
		return c in TokenType.single_chars.keys()
	
	func lex(lexer, letter):
		lexer.add_token_literal(TokenType.single_chars[letter], letter)
		


class OperatorsAction:
	extends LexerActionBase
	
	func check(c):
		return c in TokenType.operators
	
	func lex(lexer, letter):
		lexer.add_token_literal(TokenType.operators[letter][0] if lexer.match('=') else TokenType.operators[letter][1], letter)
		


class CommentOrSlashAction:
	extends LexerActionBase
	
	func check(c):
		return c == '/'
	
	func lex(lexer, letter):
		if lexer.match('/'):
			while lexer.peek() != '\n' and not lexer.is_at_end():
				lexer.advance()
		
		elif lexer.match('*'):
			while not lexer.is_at_end():
				
				if lexer.match('*') and lexer.match('/'):
					break
				
				if lexer.peek() == '\n':
					lexer.next_line()
				
				lexer.advance()
			
		else:
			lexer.add_token_literal(TokenType.SLASH, letter)
		

class WhiteSpaceAction:
	extends LexerAction.WhiteSpaceAction
#	func check(c):
#		return c in [' ', '\r', '\t']
#
#	func lex(lexer, letter):
#		pass
#



class NextLineAction:
	extends LexerActionBase
	
	func check(c):
		return c == '\n'
	
	func lex(lexer, letter):
		lexer.next_line()
		

class NumberAction:
	extends LexerActionBase
	
	func check(c):
		return '0' <= c && c <= '9'
	
	func lex(lexer, letter):
		while lexer.is_digit(lexer.peek()):
			lexer.advance();
		
		# Look for a fractional part.
		if lexer.peek() == '.' && lexer.is_digit(lexer.peek_next()):
			# Consume the "."
			lexer.advance();                                              
		
			while lexer.is_digit(lexer.peek()): 
				lexer.advance()
		
		lexer.add_token_literal(TokenType.NUMBER, float(lexer.selected_text()))


class IdentifierAction:
	extends LexerActionBase
	
	func check(c):
		return ('a' <= c and c <= 'z')\
			or ('A' <= c and c <= 'Z')\
			or c == '_'
	
	func lex(lexer, letter):
		
		while lexer.is_alpha_numeric(lexer.peek()):
			lexer.advance()
		
		# See if the identifier is a reserved word.

		var text = lexer.selected_text()
		var type = TokenType.get_keywords(text)
		
#		lexer.add_token_type(type)
		lexer.add_token_literal(type, text)



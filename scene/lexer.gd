extends Node





func do():
	scan_tokens()





func scan_tokens():
	while not Reader.is_at_end():
		
		Reader.fresh()
		scan_token()
	
	
	Reader.add_token(Token.new(TokenType.EOF, "", null, Reader.line))
	
	



var actions := [
	NumberAction.new(),
	IdentifierAction.new(),
	
	SingleLetterAction.new(),
	OperatorsAction.new(),
	
	CommentOrSlashAction.new(),
	WhiteSpaceAction.new(),
	NextLineAction.new(),
	
	StringAction.new(),
]



func scan_token():
	
	var c = Reader.advance()
	
	var error = true
	
	
	
	for action in actions:
		if action.check(c):
			action.lex(c)
			error = false
			break
	
	
	
	if error:
		ErrorHandler.error("%d: %s: Unexpected character." % [Reader.line, c])










func keywords_pattern(letter_array: PoolStringArray) -> Array:
	
	var index := 0
	var lexeme := ''
	var token_array := []
	

	for index in letter_array.size():
		var charr := letter_array[index]
		if charr != u.white_space:
			lexeme += charr

		if index + 1 < letter_array.size():
			if letter_array[index + 1] == u.white_space or letter_array[index + 1] in u.words or lexeme in u.words:
				if lexeme != '':
					
					var token = set_token(lexeme)
					
					token_array.append(token)
					lexeme = ''
					
		else:
			if lexeme != '':
				var token = set_token(lexeme)
				
				token_array.append(token)
				lexeme = ''

	
	token_array = detect_string(token_array)
	
	return token_array

func set_token(lexeme):
	var fixed = lexeme.replace('\n', '<newline>')
	var token = u.Token.new(fixed)
	
	if fixed == '<newline>':
		token.text = ''
		token.type = 'new_line'
	elif fixed in u.keywords:
		token.type = 'keyword'
	elif fixed in u.symbols:
		token.type = 'symbol'
	else:
		token.type = 'text'
	
	return token


func detect_string(token_array):
	
	var tok_ar = []
	
	var index = 0
	var can_read = true
	var is_string = false
	var tok_string : Token
	
	while can_read:
		
		if not(index < token_array.size()):
			can_read = false
			continue
		
		
		var tok = token_array[index]
		
		if is_string:
			tok_string.text += tok.text
			if token_array[index - 1].text != '\'' or token_array[index + 1].text != '\'':
				tok_string.text += ' '
			
			index += 1
			
			if token_array[index].text == '\'':
				is_string = false
				tok_ar.append(tok_string)
				index += 1
				continue
		
		else:
			if tok.text == '\'':
				tok_string = u.Token.new('', 'string')
				is_string = true
				index += 1
				continue
			else:
				tok_ar.append(tok)
				index += 1
	
	return tok_ar



class StringAction:
	
	func check(c):
		return c in ["'", "\""]
	
	func lex(symbol):
		
		while not Reader.is_at_end() and Reader.peek() != symbol:
			
			if Reader.peek() == '\n':
				Reader.next_line()
			
			Reader.advance()
		
		# Unterminated string.
		if Reader.is_at_end():
			ErrorHandler.error('%d: Unterminated string.' % Reader.line)
			print(ErrorHandler.errors)
			return
		
		# The closing ".
		Reader.advance()
		
		# Trim the surrounding quotes
		Reader.add_token_literal(TokenType.STRING, Reader.selected_string())
		


class SingleLetterAction:
	
	func check(c):
		return c in TokenType.single_chars.keys()
	
	func lex(letter):
		Reader.add_token_literal(TokenType.single_chars[letter], letter)
		


class OperatorsAction:
	
	func check(c):
		return c in TokenType.operators
	
	func lex(letter):
		Reader.add_token_literal(TokenType.operators[letter][0] if Reader.match('=') else TokenType.operators[letter][1], letter)
		


class CommentOrSlashAction:
	
	func check(c):
		return c == '/'
	
	func lex(letter):
		if Reader.match('/'):
			while Reader.peek() != '\n' and not Reader.is_at_end():
				Reader.advance()
		
		elif Reader.match('*'):
			while not Reader.is_at_end():
				
				if Reader.match('*') and Reader.match('/'):
					break
				
				if Reader.peek() == '\n':
					Reader.next_line()
				
				Reader.advance()
			
		else:
			Reader.add_token_literal(TokenType.SLASH, letter)
		

class WhiteSpaceAction:
	
	func check(c):
		return c in [' ', '\r', '\t']
	
	func lex(letter):
		pass
		

class NextLineAction:
	
	func check(c):
		return c == '\n'
	
	func lex(letter):
		Reader.next_line()
		

class NumberAction:
	
	func check(c):
		return Reader.is_digit(c)
	
	func lex(letter):
		while Reader.is_digit(Reader.peek()):
			Reader.advance();
		
		# Look for a fractional part.
		if Reader.peek() == '.' && Reader.is_digit(Reader.peek_next()):
			# Consume the "."                                      
			Reader.advance();                                              
		
			while Reader.is_digit(Reader.peek()): 
				Reader.advance();
		
		Reader.add_token_literal(TokenType.NUMBER, float(Reader.selected_text()))


class IdentifierAction:
	
	
	
	func check(c):
		return Reader.is_alpha(c)
	
	func lex(letter):
		
		while Reader.is_alpha_numeric(Reader.peek()):
			Reader.advance()
		
		# See if the identifier is a reserved word.

		var text = Reader.selected_text()
		var type = TokenType.get_keywords(text)
		
#		Reader.add_token_type(type);
		Reader.add_token_literal(type, text);



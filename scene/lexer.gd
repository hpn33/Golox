extends Node





func do():
	scan_tokens()





func scan_tokens():
	while not Reader.is_at_end():
		
		Reader.fresh()
		scan_token()
	
	
	Reader.add_token(Token.new(TokenType.EOF, "", null, Reader.line))
	
	



var actions := [
	SingleLetterAction.new(),
	OperatorsAction.new(),
	CommentOrSlashAction.new(),
	WhiteSpaceAction.new(),
	NextLineAction.new(),
	StringAction.new()
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
#		print(lexeme)
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
#		print(lexeme)
	
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
			print('not complete string')
			print(ErrorHandler.errors)
			return
		
		# The closing ".
		Reader.advance()
		
		# Trim the surrounding quotes
		Reader.add_token_literal(TokenType.STRING, Reader.selected_string())
		


class SingleLetterAction:
	
	var dic := {
		'(': TokenType.LEFT_PAREN,
		')': TokenType.RIGHT_PAREN,
		'{': TokenType.LEFT_BRACE,
		'}': TokenType.RIGHT_BRACE,
		',': TokenType.COMMA,
		'.': TokenType.DOT,
		'-': TokenType.MINUS,
		'+': TokenType.PLUS,
		';': TokenType.SEMICOLON,
		'*': TokenType.STAR
	}
	
	
	func check(c):
		return c in dic.keys()
	
	func lex(letter):
		Reader.add_token_literal(dic[letter], letter)
		


class OperatorsAction:
	
	var dic := {
		'!': [TokenType.BANG_EQUAL, TokenType.BANG],
		'=': [TokenType.EQUAL_EQUAL, TokenType.EQUAL],
		'<': [TokenType.LESS_EQUAL, TokenType.LESS],
		'>': [TokenType.GREATER_EQUAL, TokenType.GREATER]
	}
	
	
	func check(c):
		return c in dic
	
	func lex(letter):
		Reader.add_token_literal(dic[letter][0] if Reader.match('=') else dic[letter][1], letter)
		


class CommentOrSlashAction:
	
	func check(c):
		return c == '/'
	
	func lex(letter):
		if Reader.match('/'):
			while Reader.peek() != '\n' and not Reader.is_at_end():
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
		

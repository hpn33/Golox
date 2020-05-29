extends Node





func do():
	scan_tokens()





func scan_tokens():
	while not Reader.is_at_end():
		
		if ErrorHandler.had_error:
			ErrorHandler.show_error()
			break
		
		Reader.fresh()
		scan_token()
	
	Reader.add_token({
		type = 'EOF',
		body = ''})



var actions = [
	StringAction.new()
]



func scan_token():
	
	var c = Reader.advance()
	
#	print(c)
	
	
	
	
	
#	for action in actions:
#		if action.check(c):
#			action.lex(c)
#			break
	
	if false:
		pass
	
	else:
		ErrorHandler.error(str(Reader.line) + ": \""+ c + "\" : Unexpected character.")



class StringAction:
	
	func check(c):
		return c in ["'", "\""]
	
	func lex(symbol):
		
		while not Reader.is_at_end() and Reader.peek() != symbol:
			
			Reader.advance()
		
		# Unterminated string.
		if Reader.is_at_end():
			# Lox.error(self.line, 'Unterminated string.')
			ErrorHandler.error('Unterminated string.')
		
		# The closing ".
#		Reader.advance()
		
		# Trim the surrounding quotes
#		value = Reader.source[self.start + 1: self.current - 1]
		var value = Reader.substr(Reader.start + 1, Reader.current - 1)
		# print(value)
		print(value)
		Reader.add_token({type = "string", body =value})
		



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
	var tok_string : u.Token
	
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




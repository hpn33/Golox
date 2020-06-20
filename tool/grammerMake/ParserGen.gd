extends ParserBase
class_name ParserGen




func parse() -> Array:
	
#	print(tokens)
	
	while not is_at_end():
		print(declaration())
	
	
	
	
	return []


func declaration():
	var id = consume(TokenType.IDENTIFIER, '')
	
	var content = null                           
	if match(['->']):
		content = expression()
	
#	if not consume(TokenType.SEMICOLON, "Expect ';' after variable declaration."):
#		return null
	
	return Content.new(id, content)

func expression():
	var c := []
	
	while not match([TokenType.SEMICOLON]):
		c.append(peek())
	
	return c

class Content:
	var id 
	var content
	
	func _init(_id, _content):
		id = _id
		content = _content
	
	func _to_string():
		return str(id) + ' ' + str(content)



func consume(type, message: String):
	if check(type):
		return advance()
	







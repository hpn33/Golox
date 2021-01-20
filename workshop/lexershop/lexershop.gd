extends Node

onready var input = $ui/input
onready var list = $ui/ScrollContainer/VBoxContainer

const sample = """
Everywhere was suffocatingly red.
It was red, but not red red. It was a yellowy red, so vermilion.
The leaves, the trunks, and the branches of the trees in this forest,
though there was some variance in strength, were all the same color.
To say a bit more, the ground onto which the leaves had fallen was
red, too.
No, not red, vermilion. It kind of made his eyes hurt.
Up ahead, Alice C turned back, the sinister shovel thrust into the
ground. “This is the Scarlet Forest.”
It was dirty, or rather stained, but Haruhiro wondered if maybe
Alice’s raincoat had been red at one point.
“Scarlet...” Haruhiro murmured to himself. The word sounded
familiar. If he recalled, Alice had offhandedly mentioned they were
heading to some place with a name like that once. “‘Scarlet’ is the
name of a color, right?”
“What else did you think it was?”
“No, nothing really...”
He hadn’t heard Alice properly to begin with, and there would have
been no point in going, “Scar... what? Sorry, what’d you say?” He’d
just have been ignored. And if he argued back now, saying there
hadn’t really been any reason for him to think it was that color, that
would get ignored, too.
"""



func _ready() -> void:
	input.text = sample
	
	
	var lexList = LexerBase.new().do(sample)
	
	for i in lexList:
		var label = Label.new()
		label.text = str(i)
		list.add_child(label)


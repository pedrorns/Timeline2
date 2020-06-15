extends MarginContainer

onready var CardDatabase=preload("res://Cards/CardsDatabase.gd")

var Cardname = 'Fuego'
onready var CardInfo = CardDatabase.DATA[CardDatabase.get(Cardname)]
onready var CardImg = str("res://Cards/",CardInfo[5],".png")
onready var Orig_scale = rect_scale.x
var startpos = 0
var targetpos = 0
var startrot = 0
var targetrot = 0
var t = 0
var TimeOrder = 0
#var Timepos = 0

var CardBacktoHandpos = 0
var CardBacktoHandrot = 0

var DRAWTIME = .2
var ORGANIZETIME = .1
enum {
	BackToHand
	InHand
	InPlay
	InMouse
	FocusInHand
	MoveDrawnCardToHand
	ReOrganiseHand
	Timelining
	Timelining2
	Timelining3
	Timelined
	TimedRight
	TimedWrong
}
var state = InHand

# Called when the node enters the scene tree for the first time.
func _ready():
	print(CardInfo[5])
	var CardSize = rect_size
	$Card.scale*= CardSize/$Card.texture.get_size()
	$Card.texture = load(CardImg)
	$CardBack.scale*= CardSize/$CardBack.texture.get_size()
	$CardBack.texture = load(CardImg)
	var Type=str(CardInfo[0])
	var Event=str(CardInfo[1])
	var Description=str(CardInfo[2])
	var YearLabel=str(CardInfo[3])
	var Year=float(CardInfo[4])
	$CardWords/Bars/TopBar/Type/CenterContainer/Label.text = Type
	$CardWords/Bars/MidBar/Description/CenterContainer/Label.text = ""
	$CardWords/Bars/BottomBar/Event/CenterContainer/Label.text = Event
	$BarsBack/TopBar/Type/CenterContainer/Label.text = Type
	$BarsBack/MidBar/YearLabel/CenterContainer/Label.text = YearLabel
	$BarsBack/BottomBar/Event/CenterContainer/Label.text = Event
	
func _physics_process(delta):
	match state:
		BackToHand:
			rect_position=CardBacktoHandpos
			rect_rotation=CardBacktoHandrot
			state = InHand
		InHand:
			pass
		InPlay:
			pass
		InMouse:
			pass
			$Card.set_z_index(10)
			$CardWords.set_z_index(11)
		FocusInHand:
			pass
		MoveDrawnCardToHand:
			if t <=1:
				rect_position = startpos.linear_interpolate(targetpos, t)
				rect_rotation=startrot * (1-t) + targetrot*t
				t += delta/float(DRAWTIME)
			else:
				rect_position = targetpos
				rect_rotation=targetrot
				state = InHand
				t = 0
		ReOrganiseHand:
			if t <=1:
				rect_position = startpos.linear_interpolate(targetpos, t)
				rect_rotation=startrot * (1-t) + targetrot*t
				t += delta/float(DRAWTIME)
			else:
				rect_position = targetpos
				rect_rotation=targetrot
				state = InHand
				t = 0
		Timelining:
			if t <=1:
				rect_position = startpos.linear_interpolate(targetpos, t)
				rect_rotation=startrot * (1-t) + targetrot*t
				t += delta/float(DRAWTIME)
			else:
				rect_position = targetpos
				rect_rotation=targetrot
				state = Timelining2
				t = 0
		Timelining2:
			if t <=1:
				rect_scale.x = Orig_scale * abs(2*t-1)
				if $Card.visible:
					if t>=0.5:
						$Card.visible = false
						$CardWords/Bars.visible = false
						$CardBack.visible = true
						$BarsBack.visible = true
				t += delta/float(DRAWTIME)
			else:
				t = 0
				rect_scale.x = Orig_scale 
				#print("Timelined")
				state = Timelining3
		Timelining3:
			pass
		Timelined:
			rect_position=targetpos
			rect_rotation=0
		TimedWrong:
			pass
		TimedRight:
			state = Timelined


extends Control

var currentScore = 0

func _ready():
	pass

func dano(dano):
	$ProgressBar.value -= dano

func score(score):
	currentScore += score
	$Score.text = "Score: " + str(currentScore) 



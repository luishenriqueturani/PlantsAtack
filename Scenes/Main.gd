extends Node2D

func _ready():
	$Player.connect("levarDano", $GUICanvas/GUI, "dano")
	$Player.connect("aumentarScore", $GUICanvas/GUI, "score")
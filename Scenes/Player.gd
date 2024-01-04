extends KinematicBody2D

const GRAVITY = 300
const UP = Vector2(0, -1)
const SPEED = 130
const JUMP = 200
const CAMERAMAX = 0
const CAMERAMIN = -50

var motion = Vector2()
var dir = 1
var cameraOffset = -50
var hp = 100
var colisor_dano = false
var objetoInimigo

signal levarDano
signal aumentarScore

func _ready():
	$areaDano.connect("area_entered", self, "on_areaDano_area_entered")
	$AnimationPlayer.play("Parado")
	
	$areaBater.connect("area_entered", self, "_on_areaBater_area_entered")
	$areaBater.connect("area_exited", self, "_on_areaBater_area_exited")
	
	$TempoMorrer.connect("timeout", self, "TempoMorrer")

func _physics_process(delta):
	if !is_on_floor():
		motion.y += GRAVITY * delta
	
	if Input.is_action_pressed("ui_right"):
		dir = 1
		$Sprite.flip_h = false
		motion.x = SPEED * dir
		if is_on_floor():
			$AnimationPlayer.play("Andando")
	elif Input.is_action_pressed("ui_left"):
		dir = -1
		$Sprite.flip_h = true
		motion.x = SPEED * dir
		if is_on_floor():
			$AnimationPlayer.play("Andando")
	else:
		dir = 0
		motion.x = SPEED * dir
		if is_on_floor():
			$AnimationPlayer.play("Parado")
	
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			motion.y = -JUMP
			$AnimationPlayer.play("Pulando")
			$Pulo.play()
	
	move_and_slide(motion, UP)
	
	$Camera2D.offset.y = cameraOffset
	if Input.is_action_pressed("ui_down"):
		cameraOffset += 1
	if !Input.is_action_pressed("ui_down"):
		cameraOffset -= 1
	
	if cameraOffset > 0:
		cameraOffset = CAMERAMAX
	if cameraOffset < -50:
		cameraOffset = CAMERAMIN
	
	if hp <= 0:
		morrer()
	

func morrer():
	$Particles2D.emitting = true
	$Sprite.visible = false
	$TempoMorrer.start()
	set_physics_process(false)

func TempoMorrer():
	get_tree().reload_current_scene()

func on_areaDano_area_entered(area):
	if area.is_in_group("inimigo"):
		if $Tempo_invencivel.time_left == 0:
			if colisor_dano == false:
				$Tempo_invencivel.start()
				tomou_dano()
				hp -= 10
				emit_signal("levarDano", 10)
			else:
				area.get_owner().call_deferred("explodir")
				motion.y = -(JUMP/2)
				$Pulo.play()
				emit_signal("aumentarScore", 50)
	pass

func _on_areaBater_area_entered(area):
	if area.is_in_group("inimigo"):
		colisor_dano = true

func _on_areaBater_area_exited(area):
	if area.is_in_group("inimigo"):
		colisor_dano = false


func tomou_dano():
	$Tween.interpolate_property($Sprite, "modulate", Color(0.55, 0, 0, 1), Color(1, 1, 1, 1), .5, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Sprite, "scale", Vector2(0.5, 0.5), Vector2(1, 1), .5, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	
	if objetoInimigo != null:
		if objetoInimigo.direcaoInimigo == -1:
			$Tween.interpolate_property(self, "position", null, Vector2(position.x -30, position.y), .5, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
		else:
			$Tween.interpolate_property(self, "position", null, Vector2(position.x +30, position.y), .5, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	
	$Dano.play()
	$Tween.start()
	
	
	pass











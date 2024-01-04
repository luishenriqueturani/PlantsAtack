extends StaticBody2D

var areaDetectavel = false
var objetoPersonagem
var direcaoInimigo = 0

func _ready():
	$AreaAtaque.connect("body_entered",self,"entrouAreaPersonagem")
	$AreaAtaque.connect("body_exited", self,"saiuAreaPersonagem")
	$AnimationPlayer.play("paradoEsquerda")
	$AnimationPlayer.connect("animation_finished", self, "animacao_terminada")
	$DestroyTimer.connect("timeout",self,"destruir")

func animacao_terminada(animacao):
	if animacao == "AtaqueEsquerda" || animacao == "AtaqueDireita":
		if $Sprite.flip_h == false:
			$AnimationPlayer.play("paradoEsquerda")
		else:
			$AnimationPlayer.play("paradoDireita")
	

func entrouAreaPersonagem(body):
	if body.is_in_group("personagem"):
		objetoPersonagem = body
		body.objetoInimigo = self
		areaDetectavel = true

func saiuAreaPersonagem(body):
	if body.is_in_group("personagem"):
		objetoPersonagem = null
		body.objetoInimigo = null
		areaDetectavel = false

func personagemAparece():
	if $AnimationPlayer.current_animation != "AtaqueEsquerda" || $AnimationPlayer.current_animation != "AtaqueDireita":
		if $Sprite.flip_h == false:
			$AnimationPlayer.play("AtaqueEsquerda")
		else:
			$AnimationPlayer.play("AtaqueDireita")


func verificarLado(body):
	if body.position.x < position.x:
		virarPersonagem(false)
	else:
		virarPersonagem(true)

func virarPersonagem(dir):
	if dir:
		direcaoInimigo = 1
	else:
		direcaoInimigo = -1
	
	$Sprite.flip_h = dir

func explodir():
	$boca.monitoring = false
	set_physics_process(false)
	$Tween.interpolate_property($Sprite, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), .5, Tween.TRANS_BOUNCE,Tween.EASE_IN_OUT)
	$Tween.start()
	$Explodir.play()
	$Particles2D.emitting = true
	$DestroyTimer.start()

func destruir():
	queue_free()

func _physics_process(delta):
	if areaDetectavel:
		personagemAparece()
		if objetoPersonagem != null:
			verificarLado(objetoPersonagem)



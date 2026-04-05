extends npc
class_name friend

@export var Dialogue:Array = ["1LOSIENTE!!!", "2WUILSON LOSIENTE!!!"]

func _process(delta: float) -> void:
	$UI.rotation = -rotation
func _on_dialogue_body_entered(body: Node2D) -> void:
	if body.has_meta("player"):
		$UI.visible = true
		body.change_dialogue(Dialogue)

func _on_dialogue_body_exited(body: Node2D) -> void:
	if body.has_meta("player"):
		$UI.visible = false
		body.change_dialogue(null)

func additional():
	$Dialogue/Collision.disabled = true

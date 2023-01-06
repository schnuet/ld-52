extends Area2D

## This component handles interactions with interactable objects.
## All interactable objects entering its range will be saved in a list.
## 
## When requesting an interaction (with interact_with_object) the first object
## will be triggered.
## 
## Interactive scenes can be any scenes with those three methods:
##   _on_leave_range()
##   _on_enter_range()
##   interact(player)
## 
## Interactive scenes have to be on collision layer 3 (interactable).


# Collect all interactable references we are in range to in this array.
var available_interact_objects = [];

onready var activator = get_parent();

# interact
func _unhandled_input(event):
	if event.is_action_pressed("action"):
		interact_with_object();
		

func interact_with_object():
	if available_interact_objects.size() == 0:
		return;
	
	available_interact_objects[0].interact(activator);

func _on_InteractArea2D_body_entered(body:Node2D):
	if body.disabled:
		return;
	
	available_interact_objects.push_back(body);
	
	print(body, "entered")
	
	if body.has_method("_on_enter_range"):
		body._on_enter_range();


func _on_InteractArea2D_body_exited(body):
	available_interact_objects.erase(body)
	
	if body.has_method("_on_leave_range"):
		body._on_leave_range();

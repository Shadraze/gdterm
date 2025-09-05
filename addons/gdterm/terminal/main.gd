@tool
extends MarginContainer

enum INSTANCE_TYPE {MAIN, BOTTOM}
var instance_type : INSTANCE_TYPE

func set_active(flag : bool):
	$term_container.set_active(flag)

func theme_changed():
	$term_container.apply_themes()

func set_initial_cmds(cmds):
	$term_container.set_initial_cmds(cmds)

func set_alt_meta(setting):
	$term_container.set_alt_meta(setting)

func set_font_setting(font, font_size):
	$term_container.set_font_setting(font, font_size)

func _on_theme_changed():
	theme_changed()

func set_instance_type(type : INSTANCE_TYPE):
	instance_type = type

func set_bottom_panel_toggle(button: Button):
	button.pressed.connect(focus_bottom_panel_terminal)

func set_main_panel_switch(shortcut: Shortcut, control: Control):
	main_panel_control = control
	print("super init")
	add_offscreen_button_shortcut(shortcut, switch_main_panel_terminal, main_panel_control.get_parent())

func set_bottom_panel_focus(shortcut: Shortcut):
	add_offscreen_button_shortcut(shortcut, focus_bottom_panel_terminal, self)

var main_panel_control : Control
func switch_main_panel_terminal():
	if(instance_type == INSTANCE_TYPE.MAIN):
		EditorInterface.set_main_screen_editor("Terminal")
		$term_container/term/GDTerm.grab_focus()

func focus_bottom_panel_terminal():
	if(instance_type == INSTANCE_TYPE.BOTTOM):
		$term_container/term/GDTerm.grab_focus()

func add_offscreen_button_shortcut(
	shortcut : Shortcut, 
	press_handler : Callable,
	parent_control : Control
	):
	var offscreen_control_parent : Control = Control.new()
	offscreen_control_parent.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	offscreen_control_parent.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	offscreen_control_parent.mouse_filter = Control.MOUSE_FILTER_PASS
	offscreen_control_parent.clip_contents = true
	
	var offscreen_control : Control = Control.new()
	offscreen_control.mouse_filter = Control.MOUSE_FILTER_PASS
	offscreen_control.position.y = -100
	
	var offscreen_button = Button.new()
	offscreen_button.shortcut = shortcut
	offscreen_button.focus_mode = Control.FOCUS_NONE
	offscreen_button.pressed.connect(press_handler)

	offscreen_control_parent.add_child(offscreen_control)
	offscreen_control.add_child(offscreen_button)

	parent_control.add_child(offscreen_control_parent)
#	$Offsceen/Control.add_child(offscreen_button)

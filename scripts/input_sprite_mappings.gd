extends Node

const UNKNOWN_TEXTURE: Texture2D = preload("res://kenney_input-prompts_1.4/Generic/Double/generic_button_square.png")
const UNKNOWN_TEXTURE_OUTLINE: Texture2D = preload("res://kenney_input-prompts_1.4/Generic/Double/generic_button_square_outline.png")

const KEY_TEXTURES: Dictionary[Key, Texture2D] = {
	Key.KEY_0: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_0.png"),
	Key.KEY_1: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_1.png"),
	Key.KEY_2: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_2.png"),
	Key.KEY_3: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_3.png"),
	Key.KEY_4: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_4.png"),
	Key.KEY_5: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_5.png"),
	Key.KEY_6: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_6.png"),
	Key.KEY_7: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_7.png"),
	Key.KEY_8: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_8.png"),
	Key.KEY_9: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_9.png"),
	
	Key.KEY_A: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_a.png"),
	Key.KEY_B: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_b.png"),
	Key.KEY_C: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_c.png"),
	Key.KEY_D: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_d.png"),
	Key.KEY_E: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_e.png"),
	Key.KEY_F: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_f.png"),
	Key.KEY_G: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_g.png"),
	Key.KEY_H: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_h.png"),
	Key.KEY_I: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_i.png"),
	Key.KEY_J: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_j.png"),
	Key.KEY_K: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_k.png"),
	Key.KEY_L: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_l.png"),
	Key.KEY_M: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_m.png"),
	Key.KEY_N: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_n.png"),
	Key.KEY_O: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_o.png"),
	Key.KEY_P: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_p.png"),
	Key.KEY_Q: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_q.png"),
	Key.KEY_R: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_r.png"),
	Key.KEY_S: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_s.png"),
	Key.KEY_T: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_t.png"),
	Key.KEY_U: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_u.png"),
	Key.KEY_V: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_v.png"),
	Key.KEY_W: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_w.png"),
	Key.KEY_X: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_x.png"),
	Key.KEY_Y: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_y.png"),
	Key.KEY_Z: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_z.png"),
	
	Key.KEY_TAB: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_tab.png"),
	Key.KEY_SHIFT: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_shift.png"),
	Key.KEY_CTRL: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_ctrl.png"),
	Key.KEY_ENTER: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_enter.png"),
	Key.KEY_SPACE: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_space.png"),
	
	Key.KEY_GREATER: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_bracket_greater.png"),
	Key.KEY_LESS: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_bracket_less.png"),
	Key.KEY_PERIOD: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_period.png"),
	Key.KEY_APOSTROPHE: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_apostrophe.png"),
}

const BUTTON_TEXTURES_XBOX: Dictionary[JoyButton, Texture2D] = {
	JoyButton.JOY_BUTTON_A: preload("res://kenney_input-prompts_1.4/Xbox Series/Double/xbox_button_color_a.png"),
	JoyButton.JOY_BUTTON_B: preload("res://kenney_input-prompts_1.4/Xbox Series/Double/xbox_button_color_b.png"),
	JoyButton.JOY_BUTTON_X: preload("res://kenney_input-prompts_1.4/Xbox Series/Double/xbox_button_color_x.png"),
	JoyButton.JOY_BUTTON_Y: preload("res://kenney_input-prompts_1.4/Xbox Series/Double/xbox_button_color_y.png"),
}

const BUTTON_TEXTURES_SWITCH: Dictionary[JoyButton, Texture2D] = {
	JoyButton.JOY_BUTTON_A: preload("res://kenney_input-prompts_1.4/Nintendo Switch/Double/switch_button_b.png"),
	JoyButton.JOY_BUTTON_B: preload("res://kenney_input-prompts_1.4/Nintendo Switch/Double/switch_button_a.png"),
	JoyButton.JOY_BUTTON_X: preload("res://kenney_input-prompts_1.4/Nintendo Switch/Double/switch_button_y.png"),
	JoyButton.JOY_BUTTON_Y: preload("res://kenney_input-prompts_1.4/Nintendo Switch/Double/switch_button_x.png"),
}

const BUTTON_TEXTURES_PLAYSTATION: Dictionary[JoyButton, Texture2D] = {
	JoyButton.JOY_BUTTON_A: preload("res://kenney_input-prompts_1.4/PlayStation Series/Double/playstation_button_color_cross.png"),
	JoyButton.JOY_BUTTON_B: preload("res://kenney_input-prompts_1.4/PlayStation Series/Double/playstation_button_color_circle.png"),
	JoyButton.JOY_BUTTON_X: preload("res://kenney_input-prompts_1.4/PlayStation Series/Double/playstation_button_color_square.png"),
	JoyButton.JOY_BUTTON_Y: preload("res://kenney_input-prompts_1.4/PlayStation Series/Double/playstation_button_color_triangle.png"),
}

const KEY_TEXTURES_OUTLINE: Dictionary[Key, Texture2D] = {
	Key.KEY_0: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_0_outline.png"),
	Key.KEY_1: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_1_outline.png"),
	Key.KEY_2: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_2_outline.png"),
	Key.KEY_3: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_3_outline.png"),
	Key.KEY_4: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_4_outline.png"),
	Key.KEY_5: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_5_outline.png"),
	Key.KEY_6: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_6_outline.png"),
	Key.KEY_7: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_7_outline.png"),
	Key.KEY_8: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_8_outline.png"),
	Key.KEY_9: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_9_outline.png"),
	
	Key.KEY_A: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_a_outline.png"),
	Key.KEY_B: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_b_outline.png"),
	Key.KEY_C: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_c_outline.png"),
	Key.KEY_D: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_d_outline.png"),
	Key.KEY_E: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_e_outline.png"),
	Key.KEY_F: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_f_outline.png"),
	Key.KEY_G: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_g_outline.png"),
	Key.KEY_H: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_h_outline.png"),
	Key.KEY_I: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_i_outline.png"),
	Key.KEY_J: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_j_outline.png"),
	Key.KEY_K: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_k_outline.png"),
	Key.KEY_L: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_l_outline.png"),
	Key.KEY_M: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_m_outline.png"),
	Key.KEY_N: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_n_outline.png"),
	Key.KEY_O: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_o_outline.png"),
	Key.KEY_P: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_p_outline.png"),
	Key.KEY_Q: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_q_outline.png"),
	Key.KEY_R: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_r_outline.png"),
	Key.KEY_S: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_s_outline.png"),
	Key.KEY_T: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_t_outline.png"),
	Key.KEY_U: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_u_outline.png"),
	Key.KEY_V: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_v_outline.png"),
	Key.KEY_W: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_w_outline.png"),
	Key.KEY_X: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_x_outline.png"),
	Key.KEY_Y: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_y_outline.png"),
	Key.KEY_Z: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_z_outline.png"),
	
	Key.KEY_TAB: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_tab_outline.png"),
	Key.KEY_SHIFT: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_shift_outline.png"),
	Key.KEY_CTRL: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_ctrl_outline.png"),
	Key.KEY_ENTER: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_enter_outline.png"),
	Key.KEY_SPACE: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_enter_outline.png"),
		
	Key.KEY_GREATER: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_bracket_greater_outline.png"),
	Key.KEY_LESS: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_bracket_less_outline.png"),
	Key.KEY_PERIOD: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_period_outline.png"),
	Key.KEY_APOSTROPHE: preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_apostrophe_outline.png"),
}

const BUTTON_TEXTURES_XBOX_OUTLINE: Dictionary[JoyButton, Texture2D] = {
	JoyButton.JOY_BUTTON_A: preload("res://kenney_input-prompts_1.4/Xbox Series/Double/xbox_button_color_a_outline.png"),
	JoyButton.JOY_BUTTON_B: preload("res://kenney_input-prompts_1.4/Xbox Series/Double/xbox_button_color_b_outline.png"),
	JoyButton.JOY_BUTTON_X: preload("res://kenney_input-prompts_1.4/Xbox Series/Double/xbox_button_color_x_outline.png"),
	JoyButton.JOY_BUTTON_Y: preload("res://kenney_input-prompts_1.4/Xbox Series/Double/xbox_button_color_y_outline.png"),
}

const BUTTON_TEXTURES_SWITCH_OUTLINE: Dictionary[JoyButton, Texture2D] = {
	JoyButton.JOY_BUTTON_A: preload("res://kenney_input-prompts_1.4/Nintendo Switch/Double/switch_button_b_outline.png"),
	JoyButton.JOY_BUTTON_B: preload("res://kenney_input-prompts_1.4/Nintendo Switch/Double/switch_button_a_outline.png"),
	JoyButton.JOY_BUTTON_X: preload("res://kenney_input-prompts_1.4/Nintendo Switch/Double/switch_button_y_outline.png"),
	JoyButton.JOY_BUTTON_Y: preload("res://kenney_input-prompts_1.4/Nintendo Switch/Double/switch_button_x_outline.png"),
}

const BUTTON_TEXTURES_PLAYSTATION_OUTLINE: Dictionary[JoyButton, Texture2D] = {
	JoyButton.JOY_BUTTON_A: preload("res://kenney_input-prompts_1.4/PlayStation Series/Double/playstation_button_color_cross_outline.png"),
	JoyButton.JOY_BUTTON_B: preload("res://kenney_input-prompts_1.4/PlayStation Series/Double/playstation_button_color_circle_outline.png"),
	JoyButton.JOY_BUTTON_X: preload("res://kenney_input-prompts_1.4/PlayStation Series/Double/playstation_button_color_square_outline.png"),
	JoyButton.JOY_BUTTON_Y: preload("res://kenney_input-prompts_1.4/PlayStation Series/Double/playstation_button_color_triangle_outline.png"),
}

var MOVE_KEYS: Texture2D = preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/keyboard_arrows.png")
var AIM_MOUSE: Texture2D = preload("res://kenney_input-prompts_1.4/Keyboard & Mouse/Double/mouse.png")

var MOVE_STICK_SWITCH: Texture2D = preload("res://kenney_input-prompts_1.4/Nintendo Switch/Double/switch_stick_l.png")
var MOVE_STICK_PLAYSTATION: Texture2D = preload("res://kenney_input-prompts_1.4/PlayStation Series/Double/playstation_stick_l.png")
var MOVE_STICK_XBOX: Texture2D = preload("res://kenney_input-prompts_1.4/Xbox Series/Double/xbox_stick_l.png")

var AIM_STICK_SWITCH: Texture2D = preload("res://kenney_input-prompts_1.4/Nintendo Switch/Double/switch_stick_r.png")
var AIM_STICK_PLAYSTATION: Texture2D = preload("res://kenney_input-prompts_1.4/PlayStation Series/Double/playstation_stick_r.png")
var AIM_STICK_XBOX: Texture2D = preload("res://kenney_input-prompts_1.4/Xbox Series/Double/xbox_stick_r.png")

var JUMP_SWITCH: Texture2D = preload("res://kenney_input-prompts_1.4/Nintendo Switch/Double/switch_button_zr.png")
var SPRINT_SWITCH: Texture2D = preload("res://kenney_input-prompts_1.4/Nintendo Switch/Double/switch_button_zl.png")

var JUMP_XBOX: Texture2D = preload("res://kenney_input-prompts_1.4/Xbox Series/Double/xbox_rt.png")
var SPRINT_XBOX: Texture2D = preload("res://kenney_input-prompts_1.4/Xbox Series/Double/xbox_lt.png")

var JUMP_PLAYSTATION: Texture2D = preload("res://kenney_input-prompts_1.4/PlayStation Series/Double/playstation_trigger_r2.png")
var SPRINT_PLAYSTATION: Texture2D = preload("res://kenney_input-prompts_1.4/PlayStation Series/Double/playstation_trigger_l2.png")

var ARTE_0_KEY: Key = KEY_A
var ARTE_1_KEY: Key = KEY_A
var ARTE_2_KEY: Key = KEY_A
var ARTE_3_KEY: Key = KEY_A
func _ready() -> void:
	var arte_0_key_events := InputMap.action_get_events("arte_0")
	for event in arte_0_key_events:
		if event is InputEventKey:
			ARTE_0_KEY = DisplayServer.keyboard_get_keycode_from_physical((event as InputEventKey).physical_keycode)
	
	var arte_1_key_events := InputMap.action_get_events("arte_1")
	for event in arte_1_key_events:
		if event is InputEventKey:
			ARTE_1_KEY = DisplayServer.keyboard_get_keycode_from_physical((event as InputEventKey).physical_keycode)
	
	var arte_2_key_events := InputMap.action_get_events("arte_2")
	for event in arte_2_key_events:
		if event is InputEventKey:
			ARTE_2_KEY = DisplayServer.keyboard_get_keycode_from_physical((event as InputEventKey).physical_keycode)
	
	var arte_3_key_events := InputMap.action_get_events("arte_3")
	for event in arte_3_key_events:
		if event is InputEventKey:
			ARTE_3_KEY = DisplayServer.keyboard_get_keycode_from_physical((event as InputEventKey).physical_keycode)
	

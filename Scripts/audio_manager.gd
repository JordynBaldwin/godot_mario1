extends Node

#region music
@onready var ground_theme = $Music/GroundTheme
@onready var underground_theme = $Music/UndergroundTheme
#endregion

#region SFX
@onready var sfx_1up = $"SFX/sfx_1up"
@onready var sfx_breakblock = $SFX/sfx_breakblock
@onready var sfx_bump = $SFX/sfx_bump
@onready var sfx_coin = $SFX/sfx_coin
@onready var sfx_fireball = $SFX/sfx_fireball
@onready var sfx_flagpole = $SFX/sfx_flagpole
@onready var sfx_gameover = $SFX/sfx_gameover
@onready var sfx_jump_small = $SFX/sfx_jump_small
@onready var sfx_jump_super = $SFX/sfx_jump_super
@onready var sfx_kick = $SFX/sfx_kick
@onready var sfx_mariodie = $SFX/sfx_mariodie
@onready var sfx_pause = $SFX/sfx_pause
@onready var sfx_pipe = $SFX/sfx_pipe
@onready var sfx_powerup = $SFX/sfx_powerup
@onready var sfx_powerup_appears = $SFX/sfx_powerup_appears
@onready var sfx_stage_clear = $SFX/sfx_stage_clear
@onready var sfx_stomp = $SFX/sfx_stomp
@onready var sfx_warning = $SFX/sfx_warning
#endregion

func _ready():
	Global.audio_manager = self
	
func stopMusic():
	get_tree().call_group("music", "stop")
	
func stopSFX():
	get_tree().call_group("SFX", "stop")
	
func stopSound():
	stopMusic()
	stopSFX()

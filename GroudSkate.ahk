#include "config.ahk"
CoordMode("ToolTip", "Screen")
CoordMode("Mouse", "Screen")
HotIfWinActive("ahk_exe destiny2.exe")

fading_tips("已加载配置文件 `nconfig file loaded.")
A_TrayMenu.Delete()
A_TrayMenu.Add("重载(Reload)", reload_app)
A_TrayMenu.Add("退出(Quit)", quit_app)

register_keys()
register_keys(){
  try{
    Hotkey(key_bindings.ground_skate, ground_skate)

    ; terminate script
    HotIfWinActive()
    Hotkey(key_bindings.reload, reload_app)
    Hotkey(key_bindings.exit, quit_app)
    fading_tips("已注册所有热键, Hotkeys registered.")
  } catch Error as err{
    log_error(err)
  }
}

ground_skate(*){
  momentum := StrLower(values.guardian_class) == "hunter" ? "air_move" : "super"
  press_key("heavy_weapon", "down", 30)
  press_key("heavy_weapon", "up", values.skate_delay)
  press_key("interact", "down", values.interact_duration)
  press_key("jump", "down", 10)
  press_key("jump", "up", 5)
  press_key("light_attack", "down", 10)
  press_key("light_attack", "up", 5)
  press_key("jump", "down", 10)
  press_key("jump", "up", 5)
  press_key(momentum, "down", 10)
  press_key(momentum, "up")
  press_key("sword_block", "down", 100)
  press_key("interact", "up")
  press_key("sword_block", "up")
}

reload_app(*){
  Reload()
}
quit_app(*){
  fading_tips("正在退出脚本", 0)
  Sleep(1000)
  ExitApp
}

press_key(binding_name, action, delay:=0){
  key_name := key_bindings.%binding_name%
  Send(Format("{Blind}{{1} {2}}", key_name, action))
  Sleep(delay)
}
fading_tips(msg, display_time:=2000){
  ToolTip(msg, tooltip_pos.x, tooltip_pos.y)
  reset := () => ToolTip()
  SetTimer(reset, 0)
  display_time ? SetTimer(reset, -display_time) : 0
}
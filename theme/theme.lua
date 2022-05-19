local dpi = require("beautiful.xresources").apply_dpi

local theme = {}

theme.dir = os.getenv("HOME") .. "/.config/awesome/theme"

local function icon(name)
  return theme.dir .. "/icons/" .. name
end

theme.default_bg = "#232627"
theme.bg_systray = theme.default_bg

-- Global {{{
theme.useless_gap = 5
theme.awesome_icon = icon("awesome.png")
awesome.set_preferred_icon_size(48)
theme.wallpaper = theme.dir .. "/wallpaper.jpg"
theme.font_name = "Ubuntu R "
theme.font = theme.font_name .. "13"
theme.icon_theme = "Papirus-Dark"
theme.fg_normal = "#FEFEFE"
theme.fg_focus = "#889FA7"
theme.fg_urgent = "#b74822"
theme.bg_normal = theme.default_bg
theme.bg_focus = "#1E2320"
theme.bg_urgent = "#3F3F3F"
--}}}
-- Taglist {{{
theme.taglist_font = "Noto Sans Regular 13"
theme.taglist_squares_sel = icon("square_sel.png")
theme.taglist_squares_unsel = icon("square_unsel.png")
theme.taglist_fg_focus = "#6EB9D3"
--}}}
-- Tasklist {{{
theme.tasklist_bg_focus = theme.default_bg
theme.tasklist_fg_focus = "#6EB9D3"
theme.tasklist_font = theme.font_name .. "11"
theme.tasklist_plain_task_name = true
theme.tasklist_disable_icon = true
--}}}
-- Border {{{
theme.border_width = dpi(2)
theme.border_normal = "#3F3F3F"
theme.border_focus = "#245C85"
theme.border_marked = "#CC9393"
--}}}
-- Menu {{{
theme.menu_height = dpi(25)
theme.menu_width = dpi(260)
theme.menu_submenu_icon = icon("submenu.png")
--}}}
-- Layout {{{
theme.layout_tile = icon("layout/tile.png")
theme.layout_tileleft = icon("layout/tileleft.png")
theme.layout_tilebottom = icon("layout/tilebottom.png")
theme.layout_tiletop = icon("layout/tiletop.png")
theme.layout_fairv = icon("layout/fairv.png")
theme.layout_fairh = icon("layout/fairh.png")
theme.layout_spiral = icon("layout/spiral.png")
theme.layout_dwindle = icon("layout/dwindle.png")
theme.layout_max = icon("layout/max.png")
theme.layout_fullscreen = icon("layout/fullscreen.png")
theme.layout_magnifier = icon("layout/magnifier.png")
theme.layout_floating = icon("layout/floating.png")
theme.layout_cascade = icon("layout/cascadew.png")
theme.layout_cascadetile = icon("layout/cascadetilew.png")
theme.layout_centerwork = icon("layout/centerworkw.png")
theme.layout_centerworkh = icon("layout/centerworkhw.png")
theme.layout_termfair = icon("layout/termfairw.png")
theme.layout_centerfair = icon("layout/centerfairw.png")
--}}}
-- Widget {{{
theme.widget_ac = icon("ac.png")
theme.widget_battery = icon("battery/battery.png")
theme.widget_battery_low = icon("battery/battery_low.png")
theme.widget_battery_empty = icon("battery/battery_empty.png")
theme.widget_mem = icon("mem.png")
theme.widget_cpu = icon("cpu.png")
theme.widget_temp = icon("temp.png")
theme.widget_net = icon("net.png")
theme.widget_hdd = icon("hdd.png")
theme.widget_music = icon("note.png")
theme.widget_music_on = icon("note.png")
theme.widget_music_pause = icon("pause.png")
theme.widget_music_stop = icon("stop.png")
theme.widget_vol = icon("volume/vol.png")
theme.widget_vol_low = icon("volume/vol_low.png")
theme.widget_vol_no = icon("volume/vol_no.png")
theme.widget_vol_mute = icon("volume/vol_mute.png")
theme.widget_mail = icon("mail.png")
theme.widget_mail_on = icon("mail_on.png")
theme.widget_task = icon("task.png")
theme.widget_scissors = icon("scissors.png")
theme.widget_weather = icon("dish.png")
--}}}
-- Titlebar {{{
theme.titlebar_bg_focus = theme.bg_focus
theme.titlebar_bg_normal = theme.bg_normal
theme.titlebar_fg_focus = theme.fg_focus
theme.titlebar_close_button_focus = icon("titlebar/close_focus.png")
theme.titlebar_close_button_normal = icon("titlebar/close_normal.png")
theme.titlebar_ontop_button_focus_active = icon("titlebar/ontop_focus_active.png")
theme.titlebar_ontop_button_normal_active = icon("titlebar/ontop_normal_active.png")
theme.titlebar_ontop_button_focus_inactive = icon("titlebar/ontop_focus_inactive.png")
theme.titlebar_ontop_button_normal_inactive = icon("titlebar/ontop_normal_inactive.png")
theme.titlebar_sticky_button_focus_active = icon("titlebar/sticky_focus_active.png")
theme.titlebar_sticky_button_normal_active = icon("titlebar/sticky_normal_active.png")
theme.titlebar_sticky_button_focus_inactive = icon("titlebar/sticky_focus_inactive.png")
theme.titlebar_sticky_button_normal_inactive = icon("titlebar/sticky_normal_inactive.png")
theme.titlebar_floating_button_focus_active = icon("titlebar/floating_focus_active.png")
theme.titlebar_floating_button_normal_active = icon("titlebar/floating_normal_active.png")
theme.titlebar_floating_button_focus_inactive = icon("titlebar/floating_focus_inactive.png")
theme.titlebar_floating_button_normal_inactive = icon("titlebar/floating_normal_inactive.png")
theme.titlebar_maximized_button_focus_active = icon("titlebar/maximized_focus_active.png")
theme.titlebar_maximized_button_normal_active = icon("titlebar/maximized_normal_active.png")
theme.titlebar_maximized_button_focus_inactive = icon("titlebar/maximized_focus_inactive.png")
theme.titlebar_maximized_button_normal_inactive = icon("titlebar/maximized_normal_inactive.png")
--}}}
-- Dropbox {{{
theme.dropbox_status_busy2 = icon("dropbox/dropboxstatus-busy2.png")
theme.dropbox_status_busy1 = icon("dropbox/dropboxstatus-busy1.png")
theme.dropbox_status_idle = icon("dropbox/dropboxstatus-idle.png")
theme.dropbox_status_logo = icon("dropbox/dropboxstatus-logo.png")
theme.dropbox_status_x = icon("dropbox/dropboxstatus-x.png")
theme.dropbox_loading_icon = theme.dropbox_status_busy1
--}}}

return theme

-- vim: fdm=marker fdl=0

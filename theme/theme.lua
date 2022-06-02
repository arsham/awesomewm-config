local dpi = require("beautiful.xresources").apply_dpi
local gears = require("gears")
local theme_assets = require("beautiful.theme_assets")
local rnotification = require("ruled.notification")

local dir = os.getenv("HOME") .. "/.config/awesome/theme"
local function icon(name)
  return dir .. "/icons/" .. name
end

local function rrect(size)
  return function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, size)
  end
end
local default_bg = "#232627"
local fg_normal = "#FEFEFE"
local font_ubuntu = "Ubuntu R "
local font_noto = "Noto Sans Regular "
local font_dejavu_mono = "DejaVu Sans Mono "
local font_emoji = "Noto Color Emoji "
local fg_focus = "#889FA7"
local bg_focus = "#1E2320"
local border_color = "#285577"
local tooltip_bg = "#1A1A1A"
awesome.set_preferred_icon_size(48)

local theme = {
  -- Global {{{
  dir = os.getenv("HOME") .. "/.config/awesome/theme",
  default_bg = "#232627",
  awesome_icon = icon("awesome.png"), -- The Awesome icon path
  icon_theme = "Papirus-Dark", -- The icon theme name
  bg_normal = default_bg, -- The default background color
  fg_normal = fg_normal, -- The default foreground (text) color
  useless_gap = 15, -- The gap between clients
  font = font_ubuntu .. "13", -- The textbox font
  font_name = font_ubuntu,
  font_name_mono = font_dejavu_mono,
  font_mono = font_dejavu_mono,
  font_emoji = font_emoji,
  bg_focus = bg_focus,
  bg_urgent = bg_focus,
  bg_minimize = nil, -- The default minimized element background color
  bg_systray = default_bg, -- The system tray background color
  fg_focus = fg_focus, -- The default focused element foreground (text) color
  fg_urgent = "#b74822", -- The default urgent element foreground (text) color
  fg_minimize = nil, -- The default minimized element foreground (text) color
  border_color = border_color, -- The fallback border color
  wallpaper = dir .. "/wallpaper.jpg", -- The wallpaper path
  --}}}
  -- Border {{{
  border_width = dpi(2), -- The fallback border width when nothing else is set
  border_color_normal = "#3F3F3F",
  border_color_active = "#245C85",
  border_marked = "#CC9393",
  border_color_marked = nil, -- The border color when the client is marked
  border_color_floating = nil, -- The fallback border color when the client is floating
  border_color_maximized = nil, -- The fallback border color when the client is maximized
  border_color_fullscreen = nil, -- The fallback border color when the client is fullscreen
  border_color_urgent = nil, -- The border color when the client has the urgent property set
  border_color_new = nil, -- The border color when the client is not active and new
  border_color_floating_active = nil, -- The border color when the (floating) client is active
  border_color_floating_normal = nil, -- The border color when the (floating) client is not active
  border_color_floating_urgent = nil, -- The border color when the (floating) client has the urgent property set
  border_color_floating_new = nil, -- The border color when the (floating) client is not active and new
  border_color_maximized_active = nil, -- The border color when the (maximized) client is active
  border_color_maximized_normal = nil, -- The border color when the (maximized) client is not active
  border_color_maximized_urgent = nil, -- The border color when the (maximized) client has the urgent property set
  border_color_maximized_new = nil, -- The border color when the (maximized) client is not active and new
  border_color_fullscreen_active = nil, -- The border color when the (fullscreen) client is active
  border_color_fullscreen_normal = nil, -- The border color when the (fullscreen) client is not active
  border_color_fullscreen_urgent = nil, -- The border color when the (fullscreen) client has the urgent property set
  border_color_fullscreen_new = nil, -- The border color when the (fullscreen) client is not active and new
  border_width_floating = nil, -- The fallback border width when the client is floating
  border_width_maximized = nil, -- The fallback border width when the client is maximized
  border_width_normal = nil, -- The client border width for the normal clients
  border_width_active = nil, -- The client border width for the active client
  border_width_urgent = nil, -- The client border width for the urgent clients
  border_width_new = nil, -- The client border width for the new clients
  border_width_floating_normal = nil, -- The client border width for the normal floating clients
  border_width_floating_active = nil, -- The client border width for the active floating client
  border_width_floating_urgent = nil, -- The client border width for the urgent floating clients
  border_width_floating_new = nil, -- The client border width for the new floating clients
  border_width_maximized_normal = nil, -- The client border width for the normal maximized clients
  border_width_maximized_active = nil, -- The client border width for the active maximized client
  border_width_maximized_urgent = nil, -- The client border width for the urgent maximized clients
  border_width_maximized_new = nil, -- The client border width for the new maximized clients
  border_width_fullscreen_normal = nil, -- The client border width for the normal fullscreen clients
  border_width_fullscreen_active = nil, -- The client border width for the active fullscreen client
  border_width_fullscreen_urgent = nil, -- The client border width for the urgent fullscreen clients
  border_width_fullscreen_new = nil, -- The client border width for the new fullscreen clients
  --}}}
  -- Arcchart {{{
  arcchart_border_color = nil, -- The progressbar border background color
  arcchart_color = nil, -- The progressbar foreground color
  arcchart_border_width = nil, -- The progressbar border width
  arcchart_paddings = nil, -- The padding between the outline and the progressbar
  arcchart_thickness = nil, -- The arc thickness
  --}}}
  -- Calendar {{{
  calendar_style = nil, -- The generic calendar style table
  calendar_font = nil, -- The calendar font
  calendar_spacing = nil, -- The calendar spacing
  calendar_week_numbers = nil, -- Display the calendar week numbers
  calendar_start_sunday = nil, -- Start the week on Sunday
  calendar_long_weekdays = nil, -- Format the weekdays with three characters instead of two
  --}}}
  -- Checkbox {{{
  checkbox_border_width = nil, -- The outer (unchecked area) border width
  checkbox_bg = nil, -- The outer (unchecked area) background color, pattern or gradient
  checkbox_border_color = nil, -- The outer (unchecked area) border color
  checkbox_check_border_color = nil, -- The checked part border color
  checkbox_check_border_width = nil, -- The checked part border width
  checkbox_check_color = nil, -- The checked part filling color
  checkbox_shape = nil, -- The outer (unchecked area) shape
  checkbox_check_shape = nil, -- The checked part shape
  checkbox_paddings = nil, -- The padding between the outline and the progressbar
  checkbox_color = nil, -- The checkbox color
  --}}}
  -- Column {{{
  column_count = nil, -- The default number of columns
  --}}}
  -- Cursor {{{
  cursor_mouse_resize = nil, -- The resize cursor name
  cursor_mouse_move = nil, -- The move cursor name
  enable_spawn_cursor = nil, -- Show busy mouse cursor during spawn
  --}}}
  -- Flex {{{
  flex_height = nil, -- Allow cells to have flexible height
  --}}}
  -- Fullscreen {{{
  fullscreen_hide_border = true, -- Hide the border on fullscreen clients
  --}}}
  -- Gap {{{
  gap_single_client = nil, -- Enable gaps for a single client
  --}}}
  -- Graph {{{
  graph_fg = nil,
  graph_bg = nil,
  graph_border_color = nil,
  --}}}
  -- Hotkeys  Widget{{{
  hotkeys_bg = nil,
  hotkeys_fg = nil,
  hotkeys_border_width = nil,
  hotkeys_border_color = nil,
  hotkeys_shape = nil,
  hotkeys_modifiers_fg = nil, -- Foreground color used for hotkey modifiers (Ctrl, Alt, Super, etc)
  hotkeys_label_bg = nil, -- Background color used for miscellaneous labels of hotkeys widget
  hotkeys_label_fg = nil, -- Foreground color used for hotkey groups and other labels
  hotkeys_font = font_ubuntu .. "13",
  hotkeys_description_font = nil,
  hotkeys_group_margin = 10,
  --}}}
  -- Layout {{{
  layout_cornernw = nil, -- The cornernw layout layoutbox icon
  layout_cornerne = nil, -- The cornerne layout layoutbox icon
  layout_cornersw = nil, -- The cornersw layout layoutbox icon
  layout_cornerse = nil, -- The cornerse layout layoutbox icon
  layout_fairh = icon("layout/fairh.png"),
  layout_fairv = icon("layout/fairv.png"),
  layout_floating = icon("layout/floating.png"),
  layout_magnifier = icon("layout/magnifier.png"),
  layout_max = icon("layout/max.png"),
  layout_fullscreen = icon("layout/fullscreen.png"),
  layout_spiral = icon("layout/spiral.png"),
  layout_dwindle = icon("layout/dwindle.png"),
  layout_tile = icon("layout/tile.png"),
  layout_tiletop = icon("layout/tiletop.png"),
  layout_tilebottom = icon("layout/tilebottom.png"),
  layout_tileleft = icon("layout/tileleft.png"),
  layout_cascade = icon("layout/cascadew.png"),
  layout_cascadetile = icon("layout/cascadetilew.png"),
  layout_centerwork = icon("layout/centerworkw.png"),
  layout_centerworkh = icon("layout/centerworkhw.png"),
  layout_termfair = icon("layout/termfairw.png"),
  layout_centerfair = icon("layout/centerfairw.png"),
  --}}}
  -- layoutlist{{{
  layoutlist_fg_normal = nil, -- The default foreground (text) color
  layoutlist_bg_normal = nil, -- The default background color
  layoutlist_fg_selected = nil, -- The selected layout foreground (text) color
  layoutlist_bg_selected = nil, -- The selected layout background color
  layoutlist_disable_icon = nil, -- Disable the layout icons (only show the name label)
  layoutlist_disable_name = nil, -- Disable the layout name label (only show the icon)
  layoutlist_font = nil, -- The layoutlist font
  layoutlist_align = nil, -- The selected layout alignment
  layoutlist_font_selected = nil, -- The selected layout title font
  layoutlist_spacing = nil, -- The space between the layouts
  layoutlist_shape = nil, -- The default layoutlist elements shape
  layoutlist_shape_border_width = nil, -- The default layoutlist elements border width
  layoutlist_shape_border_color = nil, -- The default layoutlist elements border color
  layoutlist_shape_selected = nil, -- The selected layout shape
  layoutlist_shape_border_width_selected = nil, -- The selected layout border width
  layoutlist_shape_border_color_selected = nil, -- The selected layout border color
  --}}}
  --  Master {{{
  master_width_factor = nil, -- The default master width factor
  master_fill_policy = nil, -- The default fill policy
  master_count = nil, -- The default number of master windows
  --}}}
  -- Maximized {{{
  maximized_honor_padding = nil, -- Honor the screen padding when maximizing
  maximized_hide_border = nil, -- Hide the border on maximized clients
  --}}}
  -- Menu {{{
  menu_submenu_icon = icon("submenu.png"),
  menu_font = nil, -- The menu text font
  menu_height = dpi(25), -- The item height
  menu_width = dpi(260), -- The default menu width
  menu_border_color = nil, -- The menu item border color
  menu_border_width = nil, -- The menu item border width
  menu_fg_focus = nil, -- The default focused item foreground (text) color
  menu_bg_focus = nil, -- The default focused item background color
  menu_fg_normal = nil, -- The default foreground (text) color
  menu_bg_normal = nil, -- The default background color
  menu_submenu = nil, -- The default sub-menu indicator if no menusubmenuicon is provided
  --}}}
  -- Menubar {{{
  menubar_fg_normal = nil, -- Menubar normal text color
  menubar_bg_normal = nil, -- Menubar normal background color
  menubar_border_width = nil, -- Menubar border width
  menubar_border_color = nil, -- Menubar border color
  menubar_fg_focus = nil, -- Menubar selected item text color
  menubar_bg_focus = nil, -- Menubar selected item background color
  menubar_font = nil, -- Menubar font
  --}}}
  -- Notification {{{
  notification_max_width = nil, -- The maximum notification width
  notification_position = nil, -- The maximum notification position
  notification_action_underline_normal = nil, -- Whether or not to underline the action name
  notification_action_underline_selected = nil, -- Whether or not to underline the selected action name
  notification_action_icon_only = nil, -- Whether or not the action label should be shown
  notification_action_label_only = nil, -- Whether or not the action icon should be shown
  notification_action_shape_normal = nil, -- The shape used for a normal action
  notification_action_shape_selected = nil, -- The shape used for a selected action
  notification_action_shape_border_color_normal = nil, -- The shape border color for normal actions
  notification_action_shape_border_color_selected = nil, -- The shape border color for selected actions
  notification_action_shape_border_width_normal = nil, -- The shape border width for normal actions
  notification_action_shape_border_width_selected = nil, -- The shape border width for selected actions
  notification_action_icon_size_normal = nil, -- The action icon size
  notification_action_icon_size_selected = nil, -- The selected action icon size
  notification_action_bg_normal = nil, -- The background color for normal actions
  notification_action_bg_selected = nil, -- The background color for selected actions
  notification_action_fg_normal = nil, -- The foreground color for normal actions
  notification_action_fg_selected = nil, -- The foreground color for selected actions
  notification_action_bgimage_normal = nil, -- The background image for normal actions
  notification_action_bgimage_selected = nil, -- The background image for selected actions
  notification_shape_normal = nil, -- The shape used for a normal notification
  notification_shape_selected = nil, -- The shape used for a selected notification
  notification_shape_border_color_normal = nil, -- The shape border color for normal notifications
  notification_shape_border_color_selected = nil, -- The shape border color for selected notifications
  notification_shape_border_width_normal = nil, -- The shape border width for normal notifications
  notification_shape_border_width_selected = nil, -- The shape border width for selected notifications
  notification_icon_size_normal = nil, -- The notification icon size
  notification_icon_size_selected = nil, -- The selected notification icon size
  notification_bg_normal = nil, -- The background color for normal notifications
  notification_bg_selected = nil, -- The background color for selected notifications
  notification_fg_normal = nil, -- The foreground color for normal notifications
  notification_fg_selected = nil, -- The foreground color for selected notifications
  notification_bgimage_normal = nil, -- The background image for normal notifications
  notification_bgimage_selected = nil, -- The background image for selected notifications
  notification_font = nil, -- Notifications font
  notification_bg = bg_focus, -- Notifications background color
  notification_fg = nil, -- Notifications foreground color
  notification_border_width = nil, -- Notifications border width
  notification_border_color = nil, -- Notifications border color
  notification_shape = nil, -- Notifications shape
  notification_opacity = nil, -- Notifications opacity
  notification_margin = 30, -- The margins inside of the notification widget (or popup)
  notification_width = nil, -- Notifications width
  notification_height = nil, -- Notifications height
  notification_spacing = nil, -- The spacing between the notifications
  notification_icon_resize_strategy = nil, -- The default way to resize the icon
  --}}}
  -- Opacity {{{
  opacity_normal = nil, -- The client opacity for the normal clients
  opacity_active = nil, -- The client opacity for the active client
  opacity_urgent = nil, -- The client opacity for the urgent clients
  opacity_new = nil, -- The client opacity for the new clients
  opacity_floating_normal = nil, -- The client opacity for the normal floating clients
  opacity_floating_active = nil, -- The client opacity for the active floating client
  opacity_floating_urgent = nil, -- The client opacity for the urgent floating clients
  opacity_floating_new = nil, -- The client opacity for the new floating clients
  opacity_maximized_normal = nil, -- The client opacity for the normal maximized clients
  opacity_maximized_active = nil, -- The client opacity for the active maximized client
  opacity_maximized_urgent = nil, -- The client opacity for the urgent maximized clients
  opacity_maximized_new = nil, -- The client opacity for the new maximized clients
  opacity_fullscreen_normal = nil, -- The client opacity for the normal fullscreen clients
  opacity_fullscreen_active = nil, -- The client opacity for the active fullscreen client
  opacity_fullscreen_urgent = nil, -- The client opacity for the urgent fullscreen clients
  opacity_fullscreen_new = nil, -- The client opacity for the new fullscreen clients
  --}}}
  -- Piechart {{{
  piechart_border_color = nil, -- The border color
  piechart_border_width = nil, -- The pie elements border width
  piechart_colors = nil, -- The pie chart colors
  --}}}
  -- Progressbar {{{
  progressbar_bg = nil, -- The progressbar background color
  progressbar_fg = nil, -- The progressbar foreground color
  progressbar_shape = nil, -- The progressbar shape
  progressbar_border_color = nil, -- The progressbar border color
  progressbar_border_width = nil, -- The progressbar outer border width
  progressbar_bar_shape = nil, -- The progressbar inner shape
  progressbar_bar_border_width = nil, -- The progressbar bar border width
  progressbar_bar_border_color = nil, -- The progressbar bar border color
  progressbar_margins = nil, -- The progressbar margins
  progressbar_paddings = nil, -- The progressbar padding
  --}}}
  -- Prompt {{{
  prompt_fg_cursor = nil, -- The prompt cursor foreground color
  prompt_bg_cursor = nil, -- The prompt cursor background color
  prompt_font = nil, -- The prompt text font
  prompt_fg = nil, -- The prompt foreground color
  prompt_bg = nil, -- The prompt background color
  --}}}
  -- Radialprogressbar {{{
  radialprogressbar_border_color = nil, -- The progressbar border background color
  radialprogressbar_color = nil, -- The progressbar foreground color
  radialprogressbar_border_width = nil, -- The progressbar border width
  radialprogressbar_paddings = nil, -- The padding between the outline and the progressbar
  --}}}
  -- Separator {{{
  separator_thickness = nil, -- The separator thickness
  separator_border_color = nil, -- The separator border color
  separator_border_width = nil, -- The separator border width
  separator_span_ratio = nil, -- The relative percentage covered by the bar
  separator_color = nil, -- The separator's color
  separator_shape = nil, -- The separator's shape
  --}}}
  -- Slider {{{
  slider_bar_border_width = nil, -- The bar (background) border width
  slider_bar_border_color = nil, -- The bar (background) border color
  slider_handle_border_color = nil, -- The handle border_color
  slider_handle_border_width = nil, -- The handle border width
  slider_handle_width = nil, -- The handle width
  slider_handle_color = nil, -- The handle color
  slider_handle_shape = nil, -- The handle shape
  slider_bar_shape = nil, -- The bar (background) shape
  slider_bar_height = nil, -- The bar (background) height
  slider_bar_margins = nil, -- The bar (background) margins
  slider_handle_margins = nil, -- The slider handle margins
  slider_bar_color = nil, -- The bar (background) color
  slider_bar_active_color = nil, -- The bar (active) color
  --}}}
  -- Snap {{{
  snap_bg = nil, -- The snap outline background color
  snap_border_width = nil, -- The snap outline width
  snap_shape = nil, -- The snap outline shape
  --}}}
  -- Snapper {{{
  snapper_gap = nil, -- The gap between snapped clients
  --}}}
  -- Systray {{{
  systray_icon_spacing = nil, -- The systray icon spacing
  --}}}
  -- Taglist {{{
  taglist_fg_focus = "#6EB9D3", -- The tag list main foreground (text) color
  taglist_bg_focus = nil, -- The tag list main background color
  taglist_fg_urgent = nil, -- The tag list urgent elements foreground (text) color
  taglist_bg_urgent = nil, -- The tag list urgent elements background color
  taglist_bg_occupied = nil, -- The tag list occupied elements background color
  taglist_fg_occupied = nil, -- The tag list occupied elements foreground (text) color
  taglist_bg_empty = nil, -- The tag list empty elements background color
  taglist_fg_empty = nil, -- The tag list empty elements foreground (text) color
  taglist_bg_volatile = nil, -- The tag list volatile elements background color
  taglist_fg_volatile = nil, -- The tag list volatile elements foreground (text) color
  taglist_squares_sel = icon("square_sel.png"), -- The selected elements background image
  taglist_squares_sel_empty = nil, -- The selected empty elements background image
  taglist_squares_unsel_empty = nil, -- The unselected empty elements background image
  taglist_squares_resize = nil, -- If the background images can be resized
  taglist_disable_icon = false, -- Do not display the tag icons, even if they are set
  taglist_font = font_noto .. "13", -- The taglist font
  taglist_squares_unsel = icon("square_unsel.png"), -- The unselected elements background image
  taglist_spacing = nil, -- The space between the taglist elements
  taglist_shape = nil, -- The main shape used for the elements
  taglist_shape_border_width = nil, -- The shape elements border width
  taglist_shape_border_color = nil, -- The elements shape border color
  taglist_shape_empty = nil, -- The shape used for the empty elements
  taglist_shape_border_width_empty = nil, -- The shape used for the empty elements border width
  taglist_shape_border_color_empty = nil, -- The empty elements shape border color
  taglist_shape_focus = nil, -- The shape used for the selected elements
  taglist_shape_border_width_focus = nil, -- The shape used for the selected elements border width
  taglist_shape_border_color_focus = nil, -- The selected elements shape border color
  taglist_shape_urgent = nil, -- The shape used for the urgent elements
  taglist_shape_border_width_urgent = nil, -- The shape used for the urgent elements border width
  taglist_shape_border_color_urgent = nil, -- The urgents elements shape border color
  taglist_shape_volatile = nil, -- The shape used for the volatile elements
  taglist_shape_border_width_volatile = nil, -- The shape used for the volatile elements border width
  taglist_shape_border_color_volatile = nil, -- The volatile elements shape border color
  --}}}
  -- Tasklist {{{
  tasklist_fg_normal = nil, -- The default foreground (text) color
  tasklist_bg_normal = nil, -- The default background color
  tasklist_fg_focus = "#6EB9D3", -- The focused client foreground (text) color
  tasklist_bg_focus = default_bg, -- The focused client background color
  tasklist_fg_urgent = nil, -- The urgent clients foreground (text) color
  tasklist_bg_urgent = nil, -- The urgent clients background color
  tasklist_fg_minimize = nil, -- The minimized clients foreground (text) color
  tasklist_bg_minimize = nil, -- The minimized clients background color
  tasklist_bg_image_normal = nil, -- The elements default background image
  tasklist_bg_image_focus = nil, -- The focused client background image
  tasklist_bg_image_urgent = nil, -- The urgent clients background image
  tasklist_bg_image_minimize = nil, -- The minimized clients background image
  tasklist_disable_icon = true, -- Disable the tasklist client icons
  tasklist_disable_task_name = nil, -- Disable the tasklist client titles
  tasklist_plain_task_name = false, -- Disable the extra tasklist client property notification icons
  tasklist_sticky = nil, -- Extra tasklist client property notification icon for clients with the sticky property set
  tasklist_ontop = nil, -- Extra tasklist client property notification icon for clients with the ontop property set
  tasklist_above = nil, -- Extra tasklist client property notification icon for clients with the above property set
  tasklist_below = nil, -- Extra tasklist client property notification icon for clients with the below property set
  tasklist_floating = nil, -- Extra tasklist client property notification icon for clients with the floating property set
  tasklist_maximized = nil, -- Extra tasklist client property notification icon for clients with the maximized property set
  tasklist_maximized_horizontal = nil, -- Extra tasklist client property notification icon for clients with the maximized_horizontal property set
  tasklist_maximized_vertical = nil, -- Extra tasklist client property notification icon for clients with the maximized_vertical property set
  tasklist_align = nil, -- The focused client alignment
  tasklist_font = font_ubuntu .. "11", -- The tasklist font
  tasklist_font_focus = nil, -- The focused client title alignment
  tasklist_font_minimized = nil, -- The minimized clients font
  tasklist_font_urgent = nil, -- The urgent clients font
  tasklist_spacing = nil, -- The space between the tasklist elements
  tasklist_shape = nil, -- The default tasklist elements shape
  tasklist_shape_border_width = nil, -- The default tasklist elements border width
  tasklist_shape_border_color = nil, -- The default tasklist elements border color
  tasklist_shape_focus = nil, -- The focused client shape
  tasklist_shape_border_width_focus = nil, -- The focused client border width
  tasklist_shape_border_color_focus = nil, -- The focused client border color
  tasklist_shape_minimized = nil, -- The minimized clients shape
  tasklist_shape_border_width_minimized = nil, -- The minimized clients border width
  tasklist_shape_border_color_minimized = nil, -- The minimized clients border color
  tasklist_shape_urgent = nil, -- The urgent clients shape
  tasklist_shape_border_width_urgent = nil, -- The urgent clients border width
  tasklist_shape_border_color_urgent = nil, -- The urgent clients border color
  --}}}
  -- Titlebar {{{
  titlebar_fg_normal = nil, -- The titlebar foreground (text) color
  titlebar_bg_normal = default_bg, -- The titlebar background color
  titlebar_bgimage_normal = nil, -- The titlebar background image image
  titlebar_fg = nil, -- The titlebar foreground (text) color
  titlebar_bg = nil, -- The titlebar background color
  titlebar_bgimage = nil, -- The titlebar background image image
  titlebar_fg_focus = fg_focus, -- The focused titlebar foreground (text) color
  titlebar_bg_focus = bg_focus, -- The focused titlebar background color
  titlebar_bgimage_focus = nil, -- The focused titlebar background image image
  titlebar_fg_urgent = nil, -- The urgent titlebar foreground (text) color
  titlebar_bg_urgent = nil, -- The urgent titlebar background color
  titlebar_bgimage_urgent = nil, -- The urgent titlebar background image image
  titlebar_floating_button_normal = nil,
  titlebar_maximized_button_normal = nil,
  titlebar_minimize_button_normal = nil,
  titlebar_minimize_button_normal_hover = nil,
  titlebar_minimize_button_normal_press = nil,
  titlebar_close_button_normal = icon("titlebar/close_normal.png"),
  titlebar_close_button_normal_hover = nil,
  titlebar_close_button_normal_press = nil,
  titlebar_ontop_button_normal = nil,
  titlebar_sticky_button_normal = nil,
  titlebar_floating_button_focus = nil,
  titlebar_maximized_button_focus = nil,
  titlebar_minimize_button_focus = nil,
  titlebar_minimize_button_focus_hover = nil,
  titlebar_minimize_button_focus_press = nil,
  titlebar_close_button_focus = icon("titlebar/close_focus.png"),
  titlebar_close_button_focus_hover = nil,
  titlebar_close_button_focus_press = nil,
  titlebar_ontop_button_focus = nil,
  titlebar_sticky_button_focus = nil,
  titlebar_floating_button_normal_active = icon("titlebar/floating_normal_active.png"),
  titlebar_floating_button_normal_active_hover = nil,
  titlebar_floating_button_normal_active_press = nil,
  titlebar_maximized_button_normal_active = icon("titlebar/maximized_normal_active.png"),
  titlebar_maximized_button_normal_active_hover = nil,
  titlebar_maximized_button_normal_active_press = nil,
  titlebar_ontop_button_normal_active = icon("titlebar/ontop_normal_active.png"),
  titlebar_ontop_button_normal_active_hover = nil,
  titlebar_ontop_button_normal_active_press = nil,
  titlebar_sticky_button_normal_active = icon("titlebar/sticky_normal_active.png"),
  titlebar_sticky_button_normal_active_hover = nil,
  titlebar_sticky_button_normal_active_press = nil,
  titlebar_floating_button_focus_active = icon("titlebar/floating_focus_active.png"),
  titlebar_floating_button_focus_active_hover = nil,
  titlebar_floating_button_focus_active_press = nil,
  titlebar_maximized_button_focus_active = icon("titlebar/maximized_focus_active.png"),
  titlebar_maximized_button_focus_active_hover = nil,
  titlebar_maximized_button_focus_active_press = nil,
  titlebar_ontop_button_focus_active = icon("titlebar/ontop_focus_active.png"),
  titlebar_ontop_button_focus_active_hover = nil,
  titlebar_ontop_button_focus_active_press = nil,
  titlebar_sticky_button_focus_active = icon("titlebar/sticky_focus_active.png"),
  titlebar_sticky_button_focus_active_hover = nil,
  titlebar_sticky_button_focus_active_press = nil,
  titlebar_floating_button_normal_inactive = icon("titlebar/floating_normal_inactive.png"),
  titlebar_floating_button_normal_inactive_hover = nil,
  titlebar_floating_button_normal_inactive_press = nil,
  titlebar_maximized_button_normal_inactive = icon("titlebar/maximized_normal_inactive.png"),
  titlebar_maximized_button_normal_inactive_hover = nil,
  titlebar_maximized_button_normal_inactive_press = nil,
  titlebar_ontop_button_normal_inactive = icon("titlebar/ontop_normal_inactive.png"),
  titlebar_ontop_button_normal_inactive_hover = nil,
  titlebar_ontop_button_normal_inactive_press = nil,
  titlebar_sticky_button_normal_inactive = icon("titlebar/sticky_normal_inactive.png"),
  titlebar_sticky_button_normal_inactive_hover = nil,
  titlebar_sticky_button_normal_inactive_press = nil,
  titlebar_floating_button_focus_inactive = icon("titlebar/floating_focus_inactive.png"),
  titlebar_floating_button_focus_inactive_hover = nil,
  titlebar_floating_button_focus_inactive_press = nil,
  titlebar_maximized_button_focus_inactive = icon("titlebar/maximized_focus_inactive.png"),
  titlebar_maximized_button_focus_inactive_hover = nil,
  titlebar_maximized_button_focus_inactive_press = nil,
  titlebar_ontop_button_focus_inactive = icon("titlebar/ontop_focus_inactive.png"),
  titlebar_ontop_button_focus_inactive_hover = nil,
  titlebar_ontop_button_focus_inactive_press = nil,
  titlebar_sticky_button_focus_inactive = icon("titlebar/sticky_focus_inactive.png"),
  titlebar_sticky_button_focus_inactive_hover = nil,
  titlebar_sticky_button_focus_inactive_press = nil,
  --}}}
  -- Tooltip {{{
  tooltip_border_color = nil, -- The tooltip border color
  tooltip_bg = tooltip_bg, -- The tooltip background color
  tooltip_fg = fg_normal, -- The tooltip foregound (text) color
  tooltip_font = font_ubuntu .. "11", -- The tooltip font
  tooltip_border_width = nil, -- The tooltip border width
  tooltip_opacity = nil, -- The tooltip opacity
  tooltip_gaps = { left = 5, right = 5, top = 5, bottom = 5 }, -- The tooltip margins
  tooltip_shape = rrect(10), -- The default tooltip shape
  tooltip_align = nil, -- The default tooltip alignment
  --}}}
  -- Wallpaper {{{
  wallpaper_bg = nil, -- The default wallpaper background color
  wallpaper_fg = nil, -- The default wallpaper foreground color
  --}}}
  -- Wibar {{{
  wibar_stretch = nil, -- If the wibar needs to be stretched to fill the screen
  wibar_favor_vertical = nil, -- If there is both vertical and horizontal wibar, give more space to vertical ones
  wibar_border_width = nil, -- The wibar border width
  wibar_border_color = nil, -- The wibar border color
  wibar_ontop = nil, -- If the wibar is to be on top of other windows
  wibar_cursor = nil, -- The wibar's mouse cursor
  wibar_opacity = nil, -- The wibar opacity, between 0 and 1
  wibar_type = nil, -- The window type (desktop, normal, dock, …)
  wibar_width = nil, -- The wibar's width
  wibar_height = nil, -- The wibar's height
  wibar_bg = nil, -- The wibar's background color
  wibar_bgimage = nil, -- The wibar's background image
  wibar_fg = nil, -- The wibar's foreground (text) color
  wibar_shape = nil, -- The wibar's shape
  wibar_margins = nil, -- The wibar's margins
  wibar_align = nil, -- The wibar's alignments
  --}}}
  -- Widget {{{
  widget = {
    battery = {
      charged = icon("battery/bat-charged.png"),
      charging_00 = icon("battery/bat-000-charging.png"),
      charge_00 = icon("battery/bat-000.png"),
      charging_20 = icon("battery/bat-020-charging.png"),
      charge_20 = icon("battery/bat-020.png"),
      charging_40 = icon("battery/bat-040-charging.png"),
      charge_40 = icon("battery/bat-040.png"),
      charging_60 = icon("battery/bat-060-charging.png"),
      charge_60 = icon("battery/bat-060.png"),
      charging_80 = icon("battery/bat-080-charging.png"),
      charge_80 = icon("battery/bat-080.png"),
      charging_100 = icon("battery/bat-100-charging.png"),
      charge_100 = icon("battery/bat-100.png"),
    },
    vol = icon("volume/vol.png"),
    vol_svg = icon("volume/vol_icon.svg"),
  },
  --}}}
  -- Dropbox {{{
  dropbox_status_busy2 = icon("dropbox/dropboxstatus-busy2.png"),
  dropbox_status_busy1 = icon("dropbox/dropboxstatus-busy1.png"),
  dropbox_status_idle = icon("dropbox/dropboxstatus-idle.png"),
  dropbox_status_logo = icon("dropbox/dropboxstatus-logo.png"),
  dropbox_status_x = icon("dropbox/dropboxstatus-x.png"),
  dropbox_loading_icon = icon("dropbox/dropboxstatus-busy1.png"),
  --}}}
}

local naughty = require("naughty")

theme.notification_border_color = border_color
theme.notification_shape = rrect(10)
naughty.config.defaults.margin = theme.notification_margin
naughty.config.presets.critical.fg = theme.fg_urgent
naughty.config.presets.critical.bg = theme.bg_urgent

local beautiful = require("beautiful")
beautiful.init(theme)
naughty.config.defaults.border_width = beautiful.notification_border_width

return theme

-- vim: fdm=marker fdl=0 filetype=lua expandtab shiftwidth=4 tabstop=8 softtabstop=4 textwidth=80

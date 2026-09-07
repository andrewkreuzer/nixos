local smw = require("plugins.split-monitor-workspaces")

------------------
---- MONITORS ----
------------------

hl.monitor({
    output   = "eDP-1",
    mode     = "3456x2160@60",
    position = "0x0",
    scale    = 2,
    bitdepth = 10,
})

hl.monitor({
    output   = "DP-7",
    mode     = "1920x1080@144",
    position = "1728x0",
    scale    = 1,
    bitdepth = 10,
})

hl.monitor({
    output    = "DP-9",
    mode      = "1920x1200@60",
    position  = "3648x-425",
    scale     = 1,
    transform = 1,
    bitdepth  = 10,
})


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- hl.env("LIBVA_DRIVER_NAME", "nvidia")
-- hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
-- hl.env("NVD_BACKEND", "direct")
-- hl.env("AQ_DRM_DEVICES", "/dev/dri/card0:/dev/dri/card1")
-- hl.env("WLR_DRM_DEVICES", "/dev/dri/card0:/dev/dri/card1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- hl.env("XDG_SESSION_TYPE", "wayland")
-- hl.env("GBM_BACKEND", "nvidia-drm")

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "McMojave")
hl.env("HYPRCURSOR_SIZE", "20")


-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("mako")
end)


-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    cursor = {
        no_hardware_cursors = true,
    },

    debug = {
        disable_logs = false,
    },

    ecosystem = {
        no_update_news = true,
    },

    general = {
        gaps_in     = 5,
        gaps_out    = 10,
        border_size = 1,
        col = {
            active_border   = "rgba(595959aa)",
            inactive_border = "rgba(595959aa)",
        },
        layout = "dwindle",
    },

    decoration = {
        rounding = 5,
        blur = {
            enabled = true,
            size = 3,
            passes = 1,
            new_optimizations = true,
        },
        shadow = {
            enabled = true,
            range = 3,
        },
    },

    animations = {
        enabled = true,
    },

    gestures = {
        workspace_swipe_invert = false,
    },

    misc = {
        font_family = "Source Code Pro",
        key_press_enables_dpms = true,
    },

    input = {
        kb_layout    = "us",
        kb_options   = "caps:escape",
        follow_mouse = 1,
        sensitivity  = 0,
        touchpad = {
            natural_scroll = false,
        },
    },

    -- dwindle = {
    --     pseudotile      = true,
    --     preserve_split  = true,
    -- },
})


--------------------
---- ANIMATIONS ----
--------------------

hl.curve("bez", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })

hl.animation({ leaf = "windows",     enabled = true, speed = 7,  bezier = "bez" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 5,  bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border",      enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8,  bezier = "default" })
hl.animation({ leaf = "fade",        enabled = true, speed = 7,  bezier = "default" })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 5,  bezier = "default", style = "slide" })


-----------------
---- GESTURES ---
-----------------

hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})


----------------------
---- WINDOW RULES ----
----------------------

hl.window_rule({
    match   = { class = "term" },
    opacity = "0.95 0.7",
})

hl.window_rule({
    match   = { class = "com.ghostty.term" },
    opacity = "0.95 0.7",
})

hl.window_rule({
    match   = { class = "com.ghostty.float" },
    opacity = "0.8 0.5",
})

hl.window_rule({
    match = { class = "com.ghostty.float" },
    float = true,
})

-- hl.window_rule({
--     match = { title = "plot" },
--     float = true,
--     move  = "100%-20",
-- })


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"
local ctrlMod = "CTRL"
local lock    = "SHIFT + CTRL"

hl.bind(mainMod .. " + F",         hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + B",         hl.dsp.exec_cmd('brave --class=bravePersonal --profile-directory="Default"'))
hl.bind(mainMod .. " + W",         hl.dsp.exec_cmd("work"))
hl.bind(ctrlMod .. " + SHIFT + S", hl.dsp.exec_cmd("screenshot"))

hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("nvidia-offload ghostty --class=com.ghostty.term"))
hl.bind(mainMod .. " + A",      hl.dsp.exec_cmd("nvidia-offload ghostty --class=com.ghostty.float"))
hl.bind(mainMod .. " + C",      hl.dsp.window.close())
hl.bind(mainMod .. " + M",      hl.dsp.exit())
hl.bind(mainMod .. " + V",      hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R",      hl.dsp.exec_cmd("rofi -show drun"))
hl.bind(mainMod .. " + P",      hl.dsp.window.pseudo())

-- Move focus
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

-- Move window
hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.move({ direction = "down" }))

-- Cycle monitors
hl.bind(ctrlMod .. " + LEFT",  hl.dsp.focus({ workspace = "m-1" }))
hl.bind(ctrlMod .. " + RIGHT", hl.dsp.focus({ workspace = "m+1" }))

-- split-monitor-workspaces plugin dispatchers
smw.setup({
  workspace_count = 10,
  keep_focused = true,
  enable_notifications = false,
  enable_persistent_workspaces = false,
})
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,           smw.workspace(i))
    hl.bind(mainMod .. " + SHIFT + " .. key,   smw.move_to_workspace(i))
end

hl.bind(mainMod .. " + CTRL + 1", hl.dsp.workspace.toggle_special("1"))

-- Move/resize windows with mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Brightness / volume
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightness up"),                                     { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightness down"),                                   { repeating = true })
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"),  { repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),         { locked = true, repeating = true })

-- Lock / dpms / notifications
hl.bind(lock    .. " + L", hl.dsp.exec_cmd("sleep 1 && loginctl lock-session"))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("sleep 1 && hyprctl dispatch dpms off"))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("makoctl dismiss"))

-- # trigger when the switch is toggled
-- hl.bind(",switch:[switch name]",     hl.dsp.exec_cmd("swaylock"),                                              { locked = true })
-- hl.bind(",switch:on:[switch name]",  hl.dsp.exec_cmd("hyprctl keyword monitor 'eDP-1, 2560x1600, 0x0, 1'"),    { locked = true })
-- hl.bind(",switch:off:[switch name]", hl.dsp.exec_cmd("hyprctl keyword monitor 'eDP-1, disable'"),              { locked = true })

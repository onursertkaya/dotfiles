set $mod Mod4

font pango:UbuntuMono bold 6
#font pango:DejaVu Sans Mono 8

exec --no-startup-id xss-lock --transfer-sleep-lock -- i3lock --nofork
exec --no-startup-id nm-applet

set $refresh_i3status killall -SIGUSR1 i3status
bindsym XF86AudioRaiseVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +10% && $refresh_i3status
bindsym XF86AudioLowerVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -10% && $refresh_i3status
bindsym XF86AudioMute exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle && $refresh_i3status
bindsym XF86AudioMicMute exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle && $refresh_i3status

bindsym XF86MonBrightnessUp exec --no-startup-id "wrappers.bash brightness_up"
bindsym XF86MonBrightnessDown exec --no-startup-id "wrappers.bash brightness_down"

# mouse drag modifier
floating_modifier $mod


# focus
bindsym $mod+h focus left
bindsym $mod+j focus down
bindsym $mod+k focus up
bindsym $mod+l focus right

bindsym $mod+Tab focus mode_toggle
bindsym $mod+q   focus parent
bindsym $mod+a   focus child

# layout
bindsym $mod+Ctrl+a layout stacking
bindsym $mod+Ctrl+s layout tabbed
bindsym $mod+Ctrl+d layout toggle split
bindsym $mod+Ctrl+z split h
bindsym $mod+Ctrl+x split v


# window state
bindsym $mod+Ctrl+q kill
bindsym $mod+Ctrl+f floating toggle


# scratchpad
bindsym $mod+space scratchpad show


# moving windows
bindsym $mod+Shift+f move to scratchpad

bindsym $mod+Shift+h move left
bindsym $mod+Shift+j move down
bindsym $mod+Shift+k move up
bindsym $mod+Shift+l move right

bindsym $mod+Ctrl+Shift+j move workspace prev
bindsym $mod+Ctrl+Shift+k move workspace next
bindsym $mod+Ctrl+Shift+Left  move workspace prev
bindsym $mod+Ctrl+Shift+Right move workspace next


# workspaces
bindsym $mod+Ctrl+j workspace prev
bindsym $mod+Ctrl+k workspace next

set $ws1 "1"
set $ws2 "2"
set $ws3 "3"
set $ws4 "4"
set $ws5 "5"
set $ws6 "6"
set $ws7 "7"
set $ws8 "8"
set $ws9 "9"
set $ws10 "10"

# switch to workspace
bindsym $mod+1 workspace number $ws1
bindsym $mod+2 workspace number $ws2
bindsym $mod+3 workspace number $ws3
bindsym $mod+4 workspace number $ws4
bindsym $mod+5 workspace number $ws5
bindsym $mod+6 workspace number $ws6
bindsym $mod+7 workspace number $ws7
bindsym $mod+8 workspace number $ws8
bindsym $mod+9 workspace number $ws9
bindsym $mod+0 workspace number $ws10

# move focused container to workspace
bindsym $mod+Shift+1 move container to workspace number $ws1
bindsym $mod+Shift+2 move container to workspace number $ws2
bindsym $mod+Shift+3 move container to workspace number $ws3
bindsym $mod+Shift+4 move container to workspace number $ws4
bindsym $mod+Shift+5 move container to workspace number $ws5
bindsym $mod+Shift+6 move container to workspace number $ws6
bindsym $mod+Shift+7 move container to workspace number $ws7
bindsym $mod+Shift+8 move container to workspace number $ws8
bindsym $mod+Shift+9 move container to workspace number $ws9
bindsym $mod+Shift+0 move container to workspace number $ws10


# control
bindsym $mod+Return exec "wrappers.bash alacritty_cc"
bindsym $mod+d      exec "wrappers.bash rofi_show"
bindsym $mod+f      exec "wrappers.bash rofi_window"

bindsym $mod+Ctrl+1 exec "wrappers.bash noscreen"
bindsym $mod+Ctrl+2 exec "wrappers.bash homescreen"


bindsym $mod+Ctrl+m exec --no-startup-id "wrappers.bash music"
bindsym $mod+Ctrl+b exec --no-startup-id "wrappers.bash browsers"

bindsym F10 exec pass_s
bindsym F9 exec pass_a

# i3-control
mode "control" {
    bindsym h mode "default"; exec "wrappers.bash notify_control_mode_keybindings"
    bindsym e mode "default"; exec "i3-nagbar -t warning -m 'Logout?' -B 'Yep.' 'i3-msg exit'"
    bindsym s mode "default"; exec "wrappers.bash system_sleep";
    bindsym q mode "default"; exec "wrappers.bash system_shutdown";
    bindsym c mode "default"; reload
    bindsym r mode "default"; restart

    bindsym l mode "default"; exec "wrappers.bash screen_turn_off"
    bindsym j mode "default"; exec "wrappers.bash lock"
    bindsym k exec "wrappers.bash kbd_toggle"

    bindsym Return mode "default"
    bindsym Escape mode "default"
}
bindsym $mod+Ctrl+Escape mode "control"


# modes
mode "resize" {
    bindsym h resize shrink width  80 px; move right 40 px;
    bindsym j resize grow   height 80 px; move up    40 px;
    bindsym k resize shrink height 80 px; move down  40 px;
    bindsym l resize grow   width  80 px; move left  40 px;

    bindsym Left  resize shrink width  80 px; move right 40 px;
    bindsym Down  resize grow   height 80 px; move up    40 px;
    bindsym Up    resize shrink height 80 px; move down  40 px;
    bindsym Right resize grow   width  80 px; move left  40 px;

    bindsym Return mode "default"
    bindsym Escape mode "default"
}

mode "move" {
    bindsym h move left  40 px; 
    bindsym j move down  40 px; 
    bindsym k move up    40 px; 
    bindsym l move right 40 px; 

    bindsym Left  move left  40 px; 
    bindsym Down  move down  40 px; 
    bindsym Up    move up    40 px; 
    bindsym Right move right 40 px; 
    
    bindsym c move position center

    bindsym Return mode "default"
    bindsym Escape mode "default"
}


bindsym $mod+r mode "resize"
bindsym $mod+m mode "move"


# colors
set $grey_dark      #1a0138

set $c1_dark  #1d6785
set $c1_med   #1d7dac
set $c1_light #1a8077

set $separator #1c75a9

set $c2_dark  #11577b
set $c2_med   #11bb7b
set $c2_light #11ddaa

set $grey_light  #999999
set $grey_med   #444444


# bar
bar {
    status_command i3status --config ~/.config/i3/i3status.conf
    #status_command i3blocks
    tray_output primary
    font pango:UbuntuMono bold 6
    separator_symbol "//"
    position bottom

    colors {
        background $grey_dark

        statusline $grey_light
        separator  $separator

        # <colorclass>     <border>     <background>   <text>
        focused_workspace  $c1_med      $c1_dark       $c1_dark
        active_workspace   $c1_med      $c1_dark       $c1_dark
        inactive_workspace $c1_dark     $c1_dark       $c1_dark

        urgent_workspace   #ffffff           #cc2458           #ffffff
        binding_mode       #ffffff           #cc2458           #ffffff
    }
}


# edges
hide_edge_borders both
default_border none
for_window [floating] border pixel 0


# class                 border      backgr.    text       indicator  child_border
client.focused          $c1_dark    $grey_dark  $c1_light #ffffff    #ffffff
client.focused_inactive $c1_med     $grey_med   $c1_med   #ffffff    #ffffff
client.unfocused        $c1_med     $grey_med   $c1_med   #ffffff    #ffffff
client.urgent           #ffffff     #cc2458     $grey_light
client.placeholder      #aa0000     #cc2458     $grey_light

client.background       #00ff00


# KB shortcuts

# startup
# exec --no-startup-id "wrappers.bash homescreen"
exec --no-startup-id "wrappers.bash kbd_init"
exec --no-startup-id "wrappers.bash compton_cc"
exec --no-startup-id "wrappers.bash dunst_cc"

exec --no-startup-id "feh --bg-scale ~/Downloads/wp.jpg"
exec --no-startup-id "pasystray"
exec --no-startup-id "blueman-applet"


# floating windows
for_window [class="Gedit"] floating enable
for_window [class="firefox"] floating enable
for_window [class="Gnome-terminal"] floating enable
for_window [class="Alacritty"] floating enable

# ws1, ws2, ws5
assign [class="Slack"] number $ws1
assign [class="Google-chrome"] number $ws2
assign [class="Microsoft Teams - Preview"] number $ws5

# ws4 is for music
for_window [class="Spotify"] move to workspace $ws4
for_window [class="Pulseeffects"] move to workspace $ws4
for_window [workspace=$ws4] layout tabbed




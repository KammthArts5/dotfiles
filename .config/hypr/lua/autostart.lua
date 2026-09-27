-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
hl.on("hyprland.start", function()
	hl.exec_cmd("nm-applet")
	hl.exec_cmd("waybar")
	hl.exec_cmd("awww-daemon & sleep 1 && ~/.config/hypr/scripts/bing-wallpaper.sh")
	hl.exec_cmd("gnome-keyring-daemon --start --components=pkcs11,secrets,ssh")
	hl.exec_cmd("dbus-update-activation-environment --all")
end)

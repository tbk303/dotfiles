--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

import XMonad
import XMonad.Actions.SpawnOn
import XMonad.Layout.PerWorkspace
import XMonad.Layout.ThreeColumns
import XMonad.Layout.ResizableTile
import XMonad.Layout.NoBorders
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.SetWMName
import XMonad.Hooks.EwmhDesktops
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeysP)
import XMonad.Config.Gnome

import System.IO
import System.Exit

import Graphics.X11.ExtraTypes.XF86

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "alacritty"

-- Width of the window border in pixels.
--
myBorderWidth   = 1

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = ["cod","scm","dev","web","irc","bus","vfx","con1","con2", "con3"]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#505050"
myFocusedBorderColor = "#00ff00"


------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $

    -- launch a terminal
    [ ((modMask .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- launch dmenu
    --, ((modMask,               xK_p     ), spawnHere "exe=`dmenu_run -nb \"#212121\" -nf \"#dddddd\" -sb \"#00ffff\" -sf \"#212121\" -fn \"Terminus:style=bold:pixelsize=14\"` && eval \"exec $exe\"")
    , ((modMask,               xK_p     ), spawn "rofi -show run")

    -- launch gmrun
    , ((modMask .|. shiftMask, xK_p     ), spawn "gmrun")

    -- close focused window 
    , ((modMask .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modMask,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modMask .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modMask,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modMask,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modMask,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modMask,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modMask,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modMask,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modMask .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modMask .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modMask,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modMask,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modMask,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modMask              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modMask              , xK_period), sendMessage (IncMasterN (-1)))

    -- toggle the status bar gap
    -- TODO, update this binding with avoidStruts , ((modMask              , xK_b     ),

    -- Quit xmonad
    , ((modMask .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modMask              , xK_q     ), restart "xmonad" True)

    -- Lock the screen
    , ((modMask .|. shiftMask, xK_z     ), spawn "light-locker-command -l")
    -- Shrink/Expand window
    , ((modMask .|. shiftMask, xK_h     ), sendMessage MirrorShrink)
    , ((modMask .|. shiftMask, xK_l     ), sendMessage MirrorExpand)
    ]

    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0,1,2]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modMask, button1), (\w -> focus w >> mouseMoveWindow w))

    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, button2), (\w -> focus w >> windows W.swapMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, button3), (\w -> focus w >> mouseResizeWindow w))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
--myLayout = tiled ||| Mirror tiled ||| Full
--  where
--     -- default tiling algorithm partitions the screen into two panes
--     tiled   = Tall nmaster delta ratio
--
--     -- The default number of windows in the master pane
--     nmaster = 1
--
--     -- Default proportion of screen occupied by master pane
--     ratio   = 10/16
--
--     -- Percent of screen to increment by when resizing panes
--     delta   = 3/100

defaultTiled = ResizableTall 1 (3/100) (11/16) []

myLayout = onWorkspace "cod" (smartBorders (ResizableTall 1 (3/100) (1/2) [] ||| Mirror (ResizableTall 2 (3/100) (3/4) []) ||| Full))
  $ onWorkspace "scm" (smartBorders (ResizableTall 1 (3/100) (1/2) [] ||| Mirror (ResizableTall 2 (3/100) (3/4) []) ||| Full))
  $ onWorkspace "dev"  (smartBorders (ResizableTall 1 (3/100) (10/16) [] ||| Full))
  $ onWorkspace "web" (smartBorders (defaultTiled ||| Full))
  $ onWorkspace "irc"  (smartBorders (ResizableTall 1 (3/100) (14/16) [] ||| Mirror defaultTiled))
  $ onWorkspace "bus" (smartBorders (ResizableTall 1 (3/100) (7/16) [] ||| Full))
  $ onWorkspace "vfx" (smartBorders (ResizableTall 1 (3/100) (8/16) [] ||| Mirror defaultTiled ||| Full))
  $ onWorkspace "con1" (smartBorders (ResizableTall 1 (3/100) (1/2) [] ||| Mirror (ResizableTall 2 (3/100) (3/4) []) ||| Full))
  $ onWorkspace "con2" (smartBorders (ResizableTall 1 (3/100) (1/2) [] ||| Mirror (ResizableTall 2 (3/100) (3/4) []) ||| Full))
  $ onWorkspace "con3" (smartBorders (ResizableTall 1 (3/100) (1/2) [] ||| Mirror (ResizableTall 2 (3/100) (3/4) []) ||| Full)) defaultTiled

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll . concat $
    [ [ className =? c --> doFloat          | c <- myFloats]
    , [ title     =? t --> doFloat          | t <- myOtherFloats]
    , [ resource  =? "desktop_window" --> doIgnore]
    , [ resource  =? "kdesktop"       --> doIgnore]
    , [ resource  =? "stalonetray"         --> doIgnore]
    , [ className   =? c --> doF (W.shift "web") | c <- webApps]
    , [ className   =? c --> doF (W.shift "irc") | c <- ircApps]
    , [ className   =? c --> doF (W.shift "msg") | c <- msgApps]
    , [ className =? "Do" --> doIgnore ]
    ]
 where
   myFloats      = ["MPlayer", "Calculator", "gnome-calculator"]
   myOtherFloats = ["alsamixer",".", "Firefox Preferences", "Selenium IDE"]
   webApps       = ["chromium-browser"]
   ircApps       = ["XChat"]
   msgApps       = ["kontact","kmail"]


-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'DynamicLog' extension for examples.
--
-- To emulate dwm's status bar
--
-- > logHook = dynamicLogDzen
--


------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = setWMName "LG3D"

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = do
  xmonad $ defaults

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will 
-- use the defaults defined in xmonad/XMonad/Config.hs
-- 
-- No need to modify this.
--
defaults = gnomeConfig {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = avoidStruts $ myLayout,
        manageHook         = manageSpawn <+> manageDocks <+> myManageHook <+> manageHook gnomeConfig,
        handleEventHook    = fullscreenEventHook
        --startupHook        = myStartupHook
    }

    `additionalKeysP`

    [ ("M-S-q", spawn "gnome-session-quit")
    , ("M-0",   windows $ W.greedyView "con3")  -- workspace 0
    , ("M-S-0", windows $ W.shift "con3") -- shift window to WS 0
    ]

    -- Backlight
    --[ ("<XF86MonBrightnessUp>"          , spawn "xbacklight +10")
    --, ("<XF86MonBrightnessDown>"        , spawn "xbacklight -10")

    -- Volume
    --, ("<XF86AudioRaiseVolume>"         , spawn "amixer -c 1 set Master 1+ unmute")
    --, ("<XF86AudioLowerVolume>"         , spawn "amixer -c 1 set Master 1- unmute")
    --, ("<XF86AudioMute>"                , spawn "amixer -D pulse set Master 1+ toggle")
    --, ("<XF86AudioPlay>"                , spawn "cmus-remote -u")
    --]



-- based on https://github.com/Jorick/dotfiles/blob/master/xmonad/xmonad.hs

import XMonad
import System.Exit
import XMonad.Util.Run (safeSpawn)
import XMonad.Actions.SpawnOn
import Graphics.X11.ExtraTypes.XF86
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import Data.List
-- layouts
import XMonad.Layout.Spacing 
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Grid
--import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders
import XMonad.Layout.MultiToggle
-- hooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops
-- var
import System.Exit

-- Main process
main :: IO()
main = xmonad =<< statusBar myBar myPP toggleStrutsKey (ewmh $ myConfig)

-- Configs
myConfig = def { modMask = myModMask,
                          terminal = myTerminal,
                          workspaces = myWorkspaces,
                          layoutHook = myLayoutHook,
                          borderWidth = myBorderWidth,
                          normalBorderColor = myNormalBorderColor,
                          focusedBorderColor = myFocusedBorderColor,
                          handleEventHook = fullscreenEventHook,
                          keys = myKeys
                          }

-- Startup

-- Modkey
myModMask = mod1Mask
-- Terminal
myTerminal = "tilda"

-- workspaces
myWorkspaces = ["da", "dro", "browse", "comm", "trel", "6", "7", "8", "9"]

-- management
myManageHook = composeAll
    [ className =? "Firefox"         --> doShift "browse"
    , className =? "google-chrome"   --> doShift "secure"
    , className =? "chromium-browser" --> doShift "browse"
    , className =? "slack"           --> doShift "comms"
    , className =? "Slack"           --> doShift "comms"
    , className =? "skypeforlinux"   --> doShift "comms"
    , className =? "spotify"         --> doShift "media"
    , className =? "Spotify"         --> doShift "media"
    ]

-- Layouts
-- No spacing
{-myLayoutHook = avoidStruts $ smartBorders (tall ||| GridRatio (4/3) ||| Full )-}
                   {-where tall = Tall 1 (3/100) (1/2) -}

-- with spacing
myLayoutHook = (spacing 10 $ avoidStruts (tall ||| ThreeCol 1 (3/100) (1/2) ||| Grid ||| Full ))
                   where tall = Tall 1 (3/100) (1/2) 

-- fullscreen layout (not needed with ewmh)
--myFullscreen = (fullscreenFloat . fullscreenFull) (smartBorders Full)

myEventHook = docksEventHook <+> fullscreenEventHook

-- Looks
myBorderWidth = 0
myNormalBorderColor = "#333"
myFocusedBorderColor = "#555"

-- Xmonbar
myBar = "xmobar"
myPP = xmobarPP { ppCurrent = xmobarColor "#cc342b" ""
                     , ppHidden = xmobarColor "#373b41" ""
                     , ppHiddenNoWindows = xmobarColor "#c5c8c6" ""
                     , ppUrgent = xmobarColor "#198844" ""
                     , ppLayout = xmobarColor "#c5c8c6" ""
                     , ppTitle =  xmobarColor "#373b41" "" . shorten 80
                     , ppSep = xmobarColor "#c5c8c6" "" "  "
                     }

toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

-- Keyboard shortcuts
myKeys :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
    -- launching apps
    [ ((modMask .|. shiftMask, xK_Return), spawn "tilda") 
    , ((modMask,                 xK_p     ), spawn "dmenu_run -fn 'Droid Sans Mono-14'") 
    , ((modMask,                 xK_o     ), safeSpawn "rofi" ["-show", "window"]) 
    , ((modMask .|. shiftMask, xK_c     ), safeSpawn "firefox" [])
    , ((modMask .|. shiftMask, xK_b     ), safeSpawn "chromium" [])
    -- Kill windows
    , ((modMask .|. shiftMask, xK_w     ), kill)
    -- lock screen
    , ((modMask .|. shiftMask, xK_l), spawn "bash ~/.xmonad/pixellock.sh")
    -- screenshot
    , ((0, xK_Print                     ), safeSpawn "scrot" [])
    -- brightness
    , ((0, 0x1008FF02                   ), spawn "xrandr --output eDP-1 --brightness 1.0")
    , ((0, 0x1008FF03                   ), spawn "xrandr --output eDP-1 --brightness 0.5")
    -- multimedia
    , ((0, xF86XK_AudioRaiseVolume      ), spawn "amixer -D pulse sset Master 10%+")
    , ((0, xF86XK_AudioLowerVolume      ), spawn "amixer -D pulse sset Master 10%-")
    , ((0, 0x1008FF12                   ), spawn "amixer -D pulse sset Master mute")
    , ((0 .|. shiftMask, 0x1008FF12     ), spawn "amixer -D pulse sset Master unmute")
    , ((modMask,                 xK_Down), safeSpawn "mpc" ["toggle"])
    , ((modMask,                 xK_Up),   safeSpawn "mpc" ["stop"])
    , ((modMask,                 xK_Left), safeSpawn "mpc" ["prev"])
    , ((modMask,                 xK_Right), safeSpawn "mpc" ["next"])
    -- layouts
    , ((modMask,               xK_space ), sendMessage NextLayout)
    , ((modMask .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- floating layer stuff
    , ((modMask,               xK_t     ), withFocused $ windows . W.sink)

    -- refresh
    , ((modMask,               xK_n     ), refresh)

    -- focus
    , ((modMask,               xK_Tab   ), windows W.focusDown)
    , ((modMask,               xK_j     ), windows W.focusDown)
    , ((modMask,               xK_k     ), windows W.focusUp)
    , ((modMask,               xK_m     ), windows W.focusMaster)

    -- swapping
    , ((modMask,               xK_Return), windows W.shiftMaster)
    , ((modMask .|. shiftMask, xK_j     ), windows W.swapDown  )
    , ((modMask .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- increase or decrease number of windows in the master area
    , ((modMask              , xK_comma ), sendMessage (IncMasterN 1))
    , ((modMask              , xK_semicolon), sendMessage (IncMasterN (-1)))

    -- resizing
    , ((modMask,               xK_h     ), sendMessage Shrink)
    , ((modMask,               xK_l     ), sendMessage Expand)
    -- quit, or restart
    , ((modMask .|. shiftMask, xK_Escape  ), io (exitWith ExitSuccess))
    , ((modMask              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")
    ]
    ++
    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

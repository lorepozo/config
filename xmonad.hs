import XMonad
import XMonad.Config.Xfce (xfceConfig)
import XMonad.Util.EZConfig (additionalKeys, additionalMouseBindings)
import XMonad.Hooks.ManageDocks (avoidStruts, manageDocks, ToggleStruts(ToggleStruts))
import XMonad.Layout.Grid (Grid(Grid))
import XMonad.Layout.ResizableTile (ResizableTall(ResizableTall), MirrorResize(MirrorShrink, MirrorExpand))
import XMonad.Layout.ThreeColumns (ThreeCol(ThreeColMid))
import Text.Printf (printf)
import qualified XMonad.StackSet as W

main = xmonad $ xfceConfig
  { terminal    = myTerminal
  , borderWidth = myBorderWidth
  , normalBorderColor  = myBorderColor
  , focusedBorderColor = myBorderColor
  , layoutHook  = myLayouts
  , workspaces  = myWorkspaces
  , modMask     = mod4Mask
  , manageHook  = manageHook xfceConfig <+> manageDocks
  , startupHook = windows $ W.greedyView startupWorkspace
  } `additionalKeys` myKeys
    `additionalMouseBindings` myMouseBindings

myTerminal = "alacritty"
myBorderWidth = 1
myBorderColor = "black"
myLogout = "xfce4-session-logout"
myDmenu = "rofi -show run -modi run,window -sidebar-mode -lines 6 -width 400 -terminal alacritty"
myNotifier msg = spawn $
  printf "notify-send -t 1000 xmonad '%s'" msg

startupWorkspace = myWorkspaces!!0
myWorkspaces = map show [ 1 .. 9 ] ++ [ "0", "-", "+" ]
myWorkspaceKeys = [ xK_1 .. xK_9 ] ++ [ xK_0, xK_minus, xK_equal ]

myLayouts = avoidStruts $
  ResizableTall 1 (3/100) (1/2) []
  ||| Mirror (ResizableTall 1 (3/100) (1/2) [])
  ||| ThreeColMid 1 (3/100) (1/2)
  ||| Full
  ||| Grid

notifyLayout = gets windowset
  >>= return . description . W.layout . W.workspace . W.current
    >>= myNotifier

myKeys = myKeyBindings ++ workspaceKeyBindings
myKeyBindings =
  [ ((mod4Mask, xK_b), sendMessage ToggleStruts)
  , ((mod4Mask, xK_a), sendMessage MirrorShrink)
  , ((mod4Mask, xK_z), sendMessage MirrorExpand)
  , ((mod4Mask, xK_space), spawn myDmenu)
  , ((mod1Mask, xK_space), sendMessage NextLayout >> notifyLayout)
  , ((mod4Mask .|. shiftMask, xK_q), spawn myLogout)
  ]
workspaceKeyBindings =
  [((m .|. mod4Mask, k), windows $ f i)
      | (i, k) <- zip myWorkspaces myWorkspaceKeys
      , (f, m) <- [(W.greedyView, noModMask), (W.shift, shiftMask)]]

myMouseBindings =
  [((mod1Mask .|. mod4Mask, button1),
    (\w -> focus w >> mouseResizeWindow w))]


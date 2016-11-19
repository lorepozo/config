import XMonad
import XMonad.Config.Xfce -- xfceConfig
import XMonad.Util.EZConfig -- additionalKeys (appends to default keys)
import XMonad.Hooks.ManageDocks -- avoidStruts (status bar)
import XMonad.Layout.Grid
import XMonad.Layout.ResizableTile
import XMonad.Layout.ThreeColumns
import qualified XMonad.StackSet as W
import qualified Data.Map as M

main = xmonad $ xfceConfig {
    terminal = myTerminal
  , borderWidth = myBorderWidth
  , layoutHook = myLayouts
  , workspaces = myWorkspaces
  , modMask = myModMask
  , manageHook = manageHook xfceConfig <+> manageDocks
  , startupHook = windows $ W.greedyView startupWorkspace
  } `additionalKeys` myKeys
    `additionalMouseBindings` myMouseBindings

myModMask     = mod4Mask
myBorderWidth = 0
myTerminal    = "urxvt"
myWorkspaces =
  [ "1",  "2", "3"
  , "4",  "5", "6"
  , "7",  "8", "9"
  , "0",  "-", "+"
  ]
startupWorkspace = "1"

myLayouts = avoidStruts basicLayouts
basicLayouts =
  ResizableTall 1 (3/100) (1/2) []
  ||| Mirror (ResizableTall 1 (3/100) (1/2) [])
  ||| ThreeColMid 1 (3/100) (1/2)
  ||| Full
  ||| Grid

myKeys = myKeyBindings ++ workspaceKeyBindings
myKeyBindings =
  [ ((myModMask, xK_b), sendMessage ToggleStruts)
  , ((myModMask, xK_a), sendMessage MirrorShrink)
  , ((myModMask, xK_z), sendMessage MirrorExpand)
  , ((myModMask, xK_o), spawn "dmenu_run")
  ]
workspaceKeyBindings =
  [((m .|. myModMask, k), windows $ f i)
      | (i, k) <- zip myWorkspaces workspaceKeys
      , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
workspaceKeys = [ xK_1 .. xK_9 ] ++ [ xK_0, xK_minus, xK_equal ]

myMouseBindings =
  [ ((myModMask .|. mod1Mask, button1),
     (\w -> focus w >> mouseResizeWindow w))
  ]


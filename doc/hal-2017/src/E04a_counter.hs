{-----------------------------------------------------------------------------
    Threepenny

    A simple counter.
------------------------------------------------------------------------------}
module E04_counter_event where

import Data.IORef

import qualified Graphics.UI.Threepenny      as UI
import           Graphics.UI.Threepenny.Core

{-----------------------------------------------------------------------------
    Main
------------------------------------------------------------------------------}

main = startGUI defaultConfig { jsStatic = Just "." } setup

setup :: Window -> UI ()
setup window = do
    UI.addStyleSheet window "foundation-5.css"
    return  window # set UI.title "Simple counter"
    getBody window #+ [ mkDisplay ]
    return ()

-- | Create counter element
mkDisplay :: UI Element
mkDisplay = do
    bup     <- UI.button # set UI.text "Up"
    bdown   <- UI.button # set UI.text "Down"
    counter <- UI.div    # set UI.text "0"

    -- store counter value in an IORef
    count <- liftIO $ newIORef 0

    -- click up button
    on UI.click bup $ \_ -> do
        x <- liftIO $ do
            modifyIORef count (+1)
            readIORef count
        element counter # set UI.text (show x)
    
    -- click down button
    on UI.click bdown $ \_ -> do
        x <- liftIO $ do
            modifyIORef count (subtract 1)
            readIORef count
        element counter # set UI.text (show x)

    -- visual style
    UI.div #. "row" #+
        [ UI.ul #. "button-group round" #+
            map (\x -> UI.li #+ [element x]) [bup, bdown]
        , element counter #. "small-2 columns panel"
        ]

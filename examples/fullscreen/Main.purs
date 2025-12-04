module Main where

import Prelude

import Effect (Effect)
import Ink as Ink
import React.Basic.Hooks as React

main :: Effect Unit
main = do
  app <- mkApp
  renderFullscreen $ app {}

mkApp :: React.Component {}
mkApp = do
  React.component "App" \_ -> React.do
    { exit } <- Ink.useApp

    Ink.useInput true $ exitInputHandler exit

    pure $ Ink.box
      [ Ink.padding 1.0
      , Ink.flexDirection "column"
      , Ink.width "100%"
      , Ink.justifyContent "flex-start"
      , Ink.height "100%"
      ]
      [ Ink.text [] "Hello world"
      , Ink.text [ Ink.color "blue", Ink.italic true ] "Hello world"
      , Ink.text [ Ink.color "green", Ink.underline true ] "Hello world"
      , Ink.text [ Ink.color "yellow", Ink.strikethrough true ] "Hello world"
      , Ink.text [ Ink.color "magenta", Ink.bold true ] "Hello world"
      ]

exitInputHandler :: Effect Unit -> String -> Ink.Key -> Effect Unit
exitInputHandler exit input key
  | input == "q" = exit
  | Ink.keyIsEscape key = exit
  | otherwise = pure unit

renderFullscreen :: React.JSX -> Effect Unit
renderFullscreen = renderFullscreenImpl

foreign import renderFullscreenImpl :: React.JSX -> Effect Unit

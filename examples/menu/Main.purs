module Main where

import Prelude

import Effect (Effect)
import Ink as Ink
import React.Basic.Hooks as React

main :: Effect Unit
main = do
  app <- mkApp
  Ink.render $ app {}

mkApp :: React.Component {}
mkApp = do
  React.component "App" \_ -> React.do
    { exit } <- Ink.useApp

    Ink.useInput true $ exitInputHandler exit

    pure $ Ink.box
      [] -- Ink.justifyContent "flex-start" ]
      [ Ink.text [] "Hello world"
      ]

exitInputHandler :: Effect Unit -> String -> Ink.Key -> Effect Unit
exitInputHandler exit input key
  | input == "q" = exit
  | Ink.keyIsEscape key = exit
  | otherwise = pure unit

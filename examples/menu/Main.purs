module Main where

import Prelude

import Data.Array as Array
import Data.Traversable (for)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Ink as Ink
import React.Basic.Hooks as React

main :: Effect Unit
main = do
  app <- mkApp
  Ink.render $ app {}

mkApp :: React.Component {}
mkApp = do
  options <- for [ "Red", "Green", "Blue" ] \color -> do
    React.component "Color" \{ setChoice } -> React.do
      { isFocused } <- Ink.useFocus
      React.useEffect [ isFocused ] do
        when isFocused $ do
          setChoice color
        pure $ pure unit

      pure $ Ink.text
        [ Ink.bold isFocused
        , Ink.underline isFocused
        , Ink.italic isFocused
        ]
        color

  React.component "App" \_ -> React.do
    { exit } <- Ink.useApp
    choice /\ setChoice <- React.useState' "Red"
    finalized /\ setFinalized <- React.useState' false

    Ink.useInput true $ \input key -> do
      exitInputHandler exit input key
      when (Ink.keyIsEnter key) (setFinalized true)
      pure unit

    pure $ do
      if finalized then (Ink.text [] choice)
      else
        ( Ink.box
            []
            $ Array.intersperse
                (Ink.text [ Ink.dimColor true ] " | ")
                (options <#> \comp -> comp { setChoice })
        )

exitInputHandler :: Effect Unit -> String -> Ink.Key -> Effect Unit
exitInputHandler exit input key
  | input == "q" = exit
  | Ink.keyIsEscape key = exit
  | otherwise = pure unit

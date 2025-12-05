module Main where

import Prelude

import Data.Array ((:))
import Data.Array as Array
import Data.Traversable (for)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Ink as Ink
import Node.Encoding (Encoding(..))
import Node.Stream (writeString)
import React.Basic.Hooks as React

main :: Effect Unit
main = do
  app <- mkApp
  Ink.render $ app {}

mkApp :: React.Component {}
mkApp = do
  options <- for [ "red", "green", "blue" ] \color -> do
    React.component "Color" \{ setChoice } -> React.do
      { isFocused } <- Ink.useFocus (color == "red")
      React.useEffect [ isFocused ] do
        when isFocused $ do
          setChoice color
        pure $ pure unit

      let
        baseAttrs =
          [ Ink.bold isFocused
          , Ink.underline isFocused
          , Ink.italic isFocused
          ]
        finalAttrs =
          if isFocused then (Ink.color color : baseAttrs) else baseAttrs

      pure $ Ink.text finalAttrs color

  React.component "App" \_ -> React.do
    { exit } <- Ink.useApp
    { stdout } <- Ink.useStdout
    choice /\ setChoice <- React.useState' "red"
    questionCount /\ setQuestionCount <- React.useState' 1

    Ink.useInput true $ \input key -> do
      exitInputHandler exit input key
      when (Ink.keyIsEnter key) do
        _ <- writeString stdout UTF8 (choice <> "\n\n")
        setQuestionCount $ questionCount + 1
      pure unit

    pure
      $ Ink.box
          []
      $ (Ink.text [ Ink.dimColor true, Ink.italic true ] $ show questionCount <> ". ")
          : Array.intersperse
              (Ink.text [ Ink.dimColor true ] " | ")
              (options <#> \comp -> comp { setChoice })

exitInputHandler :: Effect Unit -> String -> Ink.Key -> Effect Unit
exitInputHandler exit input key
  | input == "q" = exit
  | Ink.keyIsEscape key = exit
  | otherwise = pure unit

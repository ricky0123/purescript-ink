module Ink
  ( module Props.Box
  , module Props.Text
  , module Props.Setters
  , render
  , useInput
  , useApp
  , useFocus
  , text
  , box
  , Key
  , keyIsLeftArrow
  , keyIsRightArrow
  , keyIsUpArrow
  , keyIsDownArrow
  , keyIsEnter
  , keyIsEscape
  , UseInput
  , UseApp
  , UseFocus
  ) where

import Prelude

import Data.Array as Array
import Data.Maybe (Maybe)
import Effect (Effect)
import Internal.ForeignUtils (toUndefined)
import Props.Box (BoxPropRecord, BoxPropsComplete, defaultBoxProps, mapBoxProps)
import Props.Setters
  ( backgroundColor
  , bold
  , color
  , dimColor
  , flexDirection
  , height
  , inverse
  , italic
  , justifyContent
  , marginBottom
  , marginTop
  , padding
  , strikethrough
  , underline
  , width
  , wrap
  )
import Props.Text (TextPropRecord, TextPropsComplete, defaultTextProps, mapTextProps)
import React.Basic (JSX, ReactComponent, element)
import React.Basic.Hooks (Hook, unsafeHook)
import Record (merge)

render :: JSX -> Effect Unit
render = renderImpl

type UseInputHandler = String -> Key -> Effect Unit

useInput :: Boolean -> UseInputHandler -> Hook (UseInput Unit) Unit
useInput isActive handler = unsafeHook (useInputImpl isActive handler)

useApp :: Hook (UseApp Unit) { exit :: Effect Unit }
useApp = unsafeHook useAppImpl

useFocus :: Hook (UseFocus Unit) { isFocused :: Boolean }
useFocus = unsafeHook useFocusImpl

text :: Array (TextPropRecord Maybe -> TextPropRecord Maybe) -> String -> JSX
text opts children = element textComponent props
  where
  maybeProps = defaultTextProps # Array.foldl (<<<) identity opts
  props' = mapTextProps toUndefined maybeProps
  props = merge props' { children: [ textRaw children ] }

box
  :: Array (BoxPropRecord Maybe -> BoxPropRecord Maybe)
  -> Array JSX
  -> JSX
box opts children = element boxComponent props
  where
  maybeProps = defaultBoxProps # Array.foldl (<<<) identity opts
  props' = mapBoxProps toUndefined maybeProps
  props = merge props' { children }

foreign import renderImpl :: JSX -> Effect Unit

foreign import data UseInput :: Type -> Type -> Type
foreign import useInputImpl :: Boolean -> UseInputHandler -> Effect Unit

foreign import data UseApp :: Type -> Type -> Type
foreign import useAppImpl :: Effect { exit :: Effect Unit }

foreign import data UseFocus :: Type -> Type -> Type
foreign import useFocusImpl :: Effect { isFocused :: Boolean }

foreign import textRaw :: String -> JSX
foreign import textComponent :: ReactComponent TextPropsComplete
foreign import boxComponent :: ReactComponent BoxPropsComplete

foreign import data Key :: Type
foreign import keyIsLeftArrow :: Key -> Boolean
foreign import keyIsRightArrow :: Key -> Boolean
foreign import keyIsUpArrow :: Key -> Boolean
foreign import keyIsDownArrow :: Key -> Boolean
foreign import keyIsEnter :: Key -> Boolean
foreign import keyIsEscape :: Key -> Boolean

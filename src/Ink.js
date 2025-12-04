import React from 'react';
import { render, Text, Box, useInput, useApp, useFocus } from 'ink';

export const renderImpl = element => () => render(element)
export const useAppImpl = useApp
export const useFocusImpl = useFocus

export const textComponent = Text;
export const boxComponent = Box;
export const textRaw = str => str

export const useInputImpl = isActive => handler => () => {
  useInput((input, key) => handler(input)(key)(), { isActive });
};

export const keyIsUpArrow = key => key.upArrow
export const keyIsDownArrow = key => key.downArrow
export const keyIsLeftArrow = key => key.leftArrow
export const keyIsRightArrow = key => key.rightArrow
export const keyIsEnter = key => key.return
export const keyIsEscape = key => key.escape

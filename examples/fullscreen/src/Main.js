import { withFullScreen } from 'fullscreen-ink';

export const renderFullscreenImpl = element => () => {
  withFullScreen(element).start();
};

// ReactNativeMarkDownUI.types.ts
import type { StyleProp, ViewStyle } from 'react-native';

export type OnLoadEventPayload = {
  status: string;
};

export type ReactNativeMarkDownUIModuleEvents = {
  onLoad: (event: { nativeEvent: OnLoadEventPayload }) => void;
};

export type ReactNativeMarkDownUIProps = {
  content: string;
  onLoad?: (event: { nativeEvent: OnLoadEventPayload }) => void;
  style?: StyleProp<ViewStyle>;
};
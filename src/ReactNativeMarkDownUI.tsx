import { requireNativeView } from 'expo';
import * as React from 'react';
import { ReactNativeMarkDownUIProps } from './ReactNativeMarkDownUI.types';

const NativeView: React.ComponentType<ReactNativeMarkDownUIProps> = 
  requireNativeView('ReactNativeMarkDownUI');

export default function ReactNativeMarkDownUI(props: ReactNativeMarkDownUIProps) {
  return <NativeView {...props} />;
}

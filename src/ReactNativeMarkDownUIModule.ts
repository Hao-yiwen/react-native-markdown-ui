import { NativeModule, requireNativeModule } from 'expo';

import { ReactNativeMarkDownUIModuleEvents } from './ReactNativeMarkDownUI.types';

declare class ReactNativeMarkDownUIModule extends NativeModule<ReactNativeMarkDownUIModuleEvents> {
}

// This call loads the native module object from the JSI.
export default requireNativeModule<ReactNativeMarkDownUIModule>('ReactNativeMarkDownUI');

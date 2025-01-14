// Reexport the native module. On web, it will be resolved to ExpoSettingsModule.web.ts
// and on native platforms to ExpoSettingsModule.ts
export { default } from './ReactNativeMarkDownUIModule';
export { default as ReactNativeMarkDownUI } from './ReactNativeMarkDownUI';
export * from  './ReactNativeMarkDownUI.types';

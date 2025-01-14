import ExpoModulesCore

public class ReactNativeMarkDownUIModule: Module {
    public func definition() -> ModuleDefinition {
        Name("ReactNativeMarkDownUIModule")

        View(ReactNativeMarkDownUI.self) {
            Prop("content") { (view: ReactNativeMarkDownUI, content: String) in
                view.contentText = content
            }
            
            Events("onLoad")
        }
    }
}
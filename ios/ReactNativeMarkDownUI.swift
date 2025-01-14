import ExpoModulesCore
import SwiftUI
import MarkdownUI

class ReactNativeMarkDownUI: ExpoView {
    let hostingController: UIHostingController<MarkdownContentView>
    let onLoad = EventDispatcher()
    private let contentView = UIView()
    private var heightConstraint: NSLayoutConstraint?
    
    public var contentText: String = "" {
        didSet {
            updateContent(contentText)
        }
    }
    
    required init(appContext: AppContext? = nil) {
        let markdownView = MarkdownContentView(content: "")
        hostingController = UIHostingController(rootView: markdownView)
        
        super.init(appContext: appContext)
        
        // 配置视图层次
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        
        hostingController.view.backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(hostingController.view)
        
        // 设置约束
        NSLayoutConstraint.activate([
            // 容器视图约束 - 确保视图固定在顶部
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            // hosting view 约束 - 固定在容器顶部
            hostingController.view.topAnchor.constraint(equalTo: contentView.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        // 添加高度约束
        heightConstraint = contentView.heightAnchor.constraint(equalToConstant: 44)
        heightConstraint?.isActive = true
        
        // 设置视图优先级
        contentView.setContentHuggingPriority(.required, for: .vertical)
        contentView.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    private func updateContent(_ newContent: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // 更新 SwiftUI 视图内容
            self.hostingController.rootView = MarkdownContentView(content: newContent)
            
            // 先进行一次布局更新
            self.hostingController.view.setNeedsLayout()
            self.hostingController.view.layoutIfNeeded()
            
            // 计算实际需要的高度
            let sizeFitting = self.hostingController.view.systemLayoutSizeFitting(
                CGSize(
                    width: self.bounds.width,
                    height: UIView.layoutFittingExpandedSize.height
                ),
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .fittingSizeLevel
            )
            
            // 更新高度约束
            let newHeight = max(44, sizeFitting.height)
            if self.heightConstraint?.constant != newHeight {
                UIView.animate(withDuration: 0.1) {
                    self.heightConstraint?.constant = newHeight
                    self.layoutIfNeeded()
                }
            }
            
            // 发送加载完成事件
            self.onLoad(["status": "success"])
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 确保宽度正确
        hostingController.view.frame.size.width = bounds.width
    }
}

struct MarkdownContentView: View {
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Markdown {
                content
            }
            .markdownTheme(.gitHub)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .topLeading)
            
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}
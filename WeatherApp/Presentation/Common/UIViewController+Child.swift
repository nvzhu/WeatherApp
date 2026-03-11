import UIKit

extension UIViewController {

    func addChild(_ child: UIViewController, to container: UIView) {
        addChild(child)
        container.addSubview(child.view, with: { view, parent in
            view.pin(to: parent)
        })
        child.didMove(toParent: self)
    }

    func removeChildFromParent() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}

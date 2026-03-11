import UIKit

// MARK: - LayoutGuide

protocol LayoutGuide {
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var widthAnchor: NSLayoutDimension { get }
    var heightAnchor: NSLayoutDimension { get }
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
}

extension UIView: LayoutGuide {}
extension UILayoutGuide: LayoutGuide {}

// MARK: - UIView + Subview Helpers

extension UIView {

    @discardableResult
    func addSubview<T: UIView>(
        _ subview: T,
        with constraints: (_ child: T, _ parent: UIView) -> [NSLayoutConstraint]
    ) -> T {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints(subview, self))
        return subview
    }

    @discardableResult
    func addSubview<T: UIView>(
        _ subview: T,
        activate constraints: [NSLayoutConstraint]
    ) -> T {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
        return subview
    }
}

// MARK: - UIView + Pin

extension UIView {

    func pin(to guide: some LayoutGuide, insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        [
            topAnchor.constraint(equalTo: guide.topAnchor, constant: insets.top),
            leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -insets.right),
            bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -insets.bottom)
        ]
    }
}

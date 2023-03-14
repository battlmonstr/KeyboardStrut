import UIKit

public final class KeyboardStrutView: UIView {
    private var height: CGFloat = 0

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setContentCompressionResistancePriority(.required, for: .vertical)
        self.subscribeToNotifications()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setContentCompressionResistancePriority(.required, for: .vertical)
        self.subscribeToNotifications()
    }

    public override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: self.height)
    }

    private func subscribeToNotifications() {
        let center = NotificationCenter.default
        center.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        center.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }

    @objc
    private func keyboardWillShow(_ notification: Notification) {
        self.height = Self.keyboardHeightFromNotification(notification)
        let duration = Self.keyboardAnimationDurationFromNotification(notification)
        self.animateHeightChange(duration: duration)
    }

    @objc
    private func keyboardWillHide(_ notification: Notification) {
        self.height = 0
        let duration = Self.keyboardAnimationDurationFromNotification(notification)
        self.animateHeightChange(duration: duration)
    }

    private static func keyboardHeightFromNotification(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        guard let keyboardFrameValue = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return 0
        }
        let keyboardFrame: CGRect = keyboardFrameValue.cgRectValue
        return keyboardFrame.height
    }

    private static func keyboardAnimationDurationFromNotification(
        _ notification: Notification
    ) -> TimeInterval {
        let userInfo = notification.userInfo
        guard let durationNum = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else {
            return 0
        }
        return TimeInterval(durationNum.floatValue)
    }

    private func animateHeightChange(duration: TimeInterval) {
        guard let superview = self.superview else { return }
        superview.layoutIfNeeded()
        UIView.animate(withDuration: duration) {
            self.invalidateIntrinsicContentSize()
            superview.layoutIfNeeded()
        }
    }
}

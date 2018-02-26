import FoundationSwagger
import os
import XCTest

extension XCTestCase {

    private enum UITestingAssociationKeys {
        private static let OriginalRootViewControllerString = "abc123" //UUIDKeyString()
        static let OriginalRootViewControllerKey =
            ObjectAssociationKey(OriginalRootViewControllerString)
    }

    private var originalRootViewController: UIViewController? {
        get {
            return association(for: UITestingAssociationKeys.OriginalRootViewControllerKey)
                as? UIViewController
        }
        set {
            let key = UITestingAssociationKeys.OriginalRootViewControllerKey
            guard let controller = newValue else {
                return removeAssociation(for: key)
            }

            associate(controller, with: key)
        }
    }

    func replaceRootViewController(with controller: UIViewController) {
        guard let window = UIApplication.shared.keyWindow else {
            if #available(iOS 10.0, *) {
                os_log("No key window found")
            }
            else {
                print("No key window found")
            }

            return
        }

        originalRootViewController = window.rootViewController
        window.rootViewController = controller
    }

    func restoreRootViewController() {
        guard let controller = originalRootViewController else { return }

        UIApplication.shared.keyWindow?.rootViewController = controller
        originalRootViewController = nil
    }

}

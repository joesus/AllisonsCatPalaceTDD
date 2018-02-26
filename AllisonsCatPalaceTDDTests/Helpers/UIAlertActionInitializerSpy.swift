import FoundationSwagger
import TestSwagger

extension UIAlertAction: ObjectSpyable {

    private static let handlerString = UUIDKeyString()
    private static let handlerKey = ObjectAssociationKey(handlerString)
    private static let handlerReference = SpyEvidenceReference(key: handlerKey)

    /// Spy controller for manipulating the initialization of an alert action.
    enum InitializerSpyController: SpyController {
        public static let rootSpyableClass: AnyClass = UIAlertAction.self
        public static let vector = SpyVector.direct
        public static let coselectors = [
            SpyCoselectors(
                methodType: .class,
                original: NSSelectorFromString("actionWithTitle:style:handler:"),
                spy: #selector(UIAlertAction.spy_action(title:style:handler:))
            )
        ] as Set
        public static let evidence = Set<SpyEvidenceReference>()
        public static let forwardsInvocations = true
    }

    /// Spy method that replaces the true implementation of `init(title:style:handler:)`
    dynamic class func spy_action(
        title: String?,
        style: UIAlertActionStyle,
        handler: ((UIAlertAction) -> Void)?
        ) -> UIAlertAction {

        let action = spy_action(title: title, style: style, handler: handler)
        action.handler = handler
        return action
    }

    /// Provides the handler passed to `init(title:style:handler:)` if available.
    final var handler: ((UIAlertAction) -> Void)? {
        get {
            return loadEvidence(with: UIAlertAction.handlerReference) as? ((UIAlertAction) -> Void)
        }
        set {
            let reference = UIAlertAction.handlerReference
            guard let newHandler = newValue else {
                return removeEvidence(with: reference)
            }

            saveEvidence(newHandler, with: reference)
        }
    }

}

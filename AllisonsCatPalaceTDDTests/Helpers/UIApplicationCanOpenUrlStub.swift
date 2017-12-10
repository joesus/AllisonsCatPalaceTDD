import TestSwagger
import FoundationSwagger

extension UIApplication {

    typealias SchemePermissions = [String: Bool]

    func stubCanOpenUrl(
        with permissions: SchemePermissions,
        in context: NullaryVoidClosure
        ) {

        stubbedCanOpenUrlPermissions = permissions

        let surrogate = MethodSurrogate(
            forClass: UIApplication.self,
            ofType: .instance,
            originalSelector: #selector(UIApplication.canOpenURL(_:)),
            alternateSelector: #selector(UIApplication.stub_canOpenUrl(_:))
        )

        surrogate.withAlternateImplementation {
            context()
        }

        removeAssociation(for: UIApplication.stubbedCanOpenUrlPermissionsKey)
    }

    dynamic func stub_canOpenUrl(_ url: URL) -> Bool {
        for (scheme, canOpen) in stubbedCanOpenUrlPermissions {
            if url.scheme == scheme {
                return canOpen
            }
        }

        return true
    }

    private static let stubbedCanOpenUrlPermissionsString = UUIDKeyString()
    private static let stubbedCanOpenUrlPermissionsKey =
        ObjectAssociationKey(stubbedCanOpenUrlPermissionsString)

    private var stubbedCanOpenUrlPermissions: SchemePermissions {
        get {
            let permissions = association(for: UIApplication.stubbedCanOpenUrlPermissionsKey)
            return permissions as? SchemePermissions ?? [:]
        }
        set {
            associate(newValue, with: UIApplication.stubbedCanOpenUrlPermissionsKey)
        }
    }

}

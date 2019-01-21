// swiftlint:disable force_cast variable_name

import UIKit

class SegueTemplate: NSObject {

    let rawTemplate: AnyObject

    init(hiddenTemplate: AnyObject) {
        rawTemplate = hiddenTemplate

        super.init()
    }

    private static let storyboardSegueTemplateIdentifierKey = "identifier"

    var identifier: String? {
        return rawTemplate.value(
            forKey: SegueTemplate.storyboardSegueTemplateIdentifierKey
            ) as? String
    }

    private static let storyboardSegueTemplateDestinationStringKey
        = "_destinationViewControllerIdentifier"

    var destinationSceneIdentifier: String {
        return rawTemplate.value(
            forKey: SegueTemplate.storyboardSegueTemplateDestinationStringKey
            ) as! String
    }

}

extension UIViewController {

    func segueTemplate(identifiedBy segueIdentifier: String) -> SegueTemplate? {
        return segueTemplates?.first { $0.identifier == segueIdentifier }
    }

    private static let storyboardSegueTemplatesKey = "storyboardSegueTemplates"

    private var segueTemplates: [SegueTemplate]? {
        let rawTemplates = value(forKey: UIViewController.storyboardSegueTemplatesKey)
            as? [AnyObject]
        return rawTemplates?.map(SegueTemplate.init(hiddenTemplate:))
    }

}

extension UITableViewCell {

    private static let selectionSegueTemplateKey = "_selectionSegueTemplate"

    var selectionSegueTemplate: SegueTemplate? {
        guard let rawTemplate = value(forKey: UITableViewCell.selectionSegueTemplateKey) else {
            return nil
        }

        return SegueTemplate(hiddenTemplate: rawTemplate as AnyObject)
    }

}

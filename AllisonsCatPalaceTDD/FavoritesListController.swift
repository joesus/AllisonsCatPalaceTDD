//
//  FavoritesListController.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 2/12/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import UIKit
import RealmSwift

// This should be the protocol for the container
protocol RealmProtocol {
    func objects<T>(_ type: T.Type) -> Results<T>
}

extension Realm: RealmProtocol {}

struct InjectionMap {
    static var realm: RealmProtocol? = try? Realm()
}

protocol RealmInjected { }

extension RealmInjected {
    var realm: RealmProtocol? {
        return InjectionMap.realm
    }
}

class FavoritesListController: UITableViewController, RealmInjected {
    var animals = [Animal]() {
        didSet {
            DispatchQueue.main.async { [weak tableView] in
                tableView?.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let realm = realm else { return }

        animals = realm.objects(AnimalObject.self).flatMap { animalObject in
            return Animal(managedObject: animalObject)
        }

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return animals.isEmpty ? 0 : 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animals.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard animals.indices.contains(indexPath.row) else {
            fatalError("Something went horribly wrong")
        }

        let cat = animals[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatCell", for: indexPath)

        cell.textLabel?.text = cat.name

        guard let imageUrl = cat.imageLocations.small.first else {
            return cell
        }

        if let image = ImageProvider.imageForUrl(imageUrl) {
            cell.imageView?.image = image
        } else {
            ImageProvider.getImage(for: imageUrl) { potentialImage in
                guard potentialImage != nil else { return }

                if let indexPaths = tableView.indexPathsForVisibleRows,
                    indexPaths.contains(indexPath) {
                    DispatchQueue.main.async {
                        tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
            }
        }

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationController = segue.destination as? CatDetailController,
            let row = tableView.indexPathForSelectedRow?.row {
            destinationController.cat = animals[row]
            destinationController.title = animals[row].name
        }
    }
}

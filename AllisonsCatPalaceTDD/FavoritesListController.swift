//
//  FavoritesListController.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 2/12/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import UIKit

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
                DispatchQueue.main.async {
                    if let indexPaths = tableView.indexPathsForVisibleRows,
                        indexPaths.contains(indexPath) {
                            tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
            }
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard let realm = realm else { return }

        let animalToDelete = animals[indexPath.row]
        let objectToDelete = realm.objects(AnimalObject.self).first { animalObject in
            animalObject.identifier.value == animalToDelete.identifier
        }

        if let object = objectToDelete {
            try? realm.write {
                realm.delete(object)
            }
        }

        animals.remove(at: indexPath.row)

        if animals.count == 0 {
            tableView.beginUpdates()
            tableView.deleteSections([0], with: .automatic)
            tableView.endUpdates()
            return
        }

        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationController = segue.destination as? CatDetailController,
            let row = tableView.indexPathForSelectedRow?.row {
            destinationController.cat = animals[row]
            destinationController.title = animals[row].name
        }
    }
}

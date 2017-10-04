//
//  CatListController.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 2/12/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import UIKit

class CatListController: UITableViewController {
    var cats = [Animal]() {
        didSet {
            DispatchQueue.main.async { [weak tableView] in
                tableView?.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        AnimalRegistry.fetchAllAnimals { fetchedCats in
            self.cats = fetchedCats
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return cats.isEmpty ? 0 : 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cats.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard cats.indices.contains(indexPath.row) else {
            fatalError("Something went horribly wrong")
        }

        let cat = cats[indexPath.row]
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationController = segue.destination as? CatDetailController,
            let row = tableView.indexPathForSelectedRow?.row {
            destinationController.cat = cats[row]
            destinationController.title = cats[row].name
        }
    }
}

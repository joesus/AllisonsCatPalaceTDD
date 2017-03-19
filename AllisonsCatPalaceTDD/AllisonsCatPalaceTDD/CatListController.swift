//
//  CatListController.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 2/12/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import UIKit

class CatListController: UITableViewController {
    var cats = [Cat]() {
        didSet {
            DispatchQueue.main.async { [weak tableView] in
                tableView?.reloadData()
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return cats.isEmpty ? 0 : 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cats.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "CatCell", for: indexPath)
        let cat = cats[indexPath.row]
        cell.textLabel?.text = cat.name

        if let imageURL = cat.imageUrl {

            if let image = ImageProvider.imageForUrl(imageURL) {
                cell.imageView?.image = image
            } else {
                ImageProvider.getImage(for: imageURL) { potentialImage in
                    guard potentialImage != nil else { return }

                    if let indexPaths = tableView.indexPathsForVisibleRows,
                        indexPaths.contains(indexPath) {
                        DispatchQueue.main.async {
                            tableView.reloadRows(at: [indexPath], with: .automatic)
                        }
                    }
                }
            }
        }

        return cell
    }
}

//
//  CatDetailController.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 3/26/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import UIKit

class CatDetailController: UITableViewController {
    @IBOutlet weak var headerView: AnimalDetailHeaderView!

    var cat: Animal? {
        didSet {
            guard oldValue == nil, cat != nil else {
                cat = oldValue
                return
            }
            
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if headerView.animal == nil {
            headerView.animal = cat
        }
    }
}

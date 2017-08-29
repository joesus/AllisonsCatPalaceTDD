//
//  AnimalCardsViewController.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 8/27/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import UIKit
import Koloda

class AnimalCardsViewController: UIViewController {
    @IBOutlet weak var kolodaView: KolodaView!

    var animals = [Animal]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.kolodaView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        AnimalRegistry.fetchAllAnimals { fetchedCats in
            self.animals = fetchedCats
        }

        kolodaView.dataSource = self
        kolodaView.delegate = self
    }
}

extension AnimalCardsViewController: KolodaViewDelegate {
    func kolodaDidRunOutOfCards(koloda: KolodaView) {
//        Make another call to get more cats from the registry here
        print("Get more cards")

        
    }
//
//    func koloda(koloda: KolodaView, didSelectCardAt index: Int) {
//        UIApplication.shared.openURL(URL(string: "https://yalantis.com/")!)
//    }
}
//
extension AnimalCardsViewController: KolodaViewDataSource {
    func kolodaSpeedThatCardShouldDrag(_ koloda: Koloda.KolodaView) -> Koloda.DragSpeed {
        return .default
    }

    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return animals.count
    }

    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        guard let animalCardView = Bundle.main.loadNibNamed("AnimalCardView", owner: self, options: nil)?.first as? AnimalCardView else {
            return UIView()
        }

        // if the card is the 10th to last card, kick off a new fetch
        

        animalCardView.configure(with: animals[index])
        animalCardView.layer.masksToBounds = true
        animalCardView.layer.cornerRadius = kolodaView.frame.width / 10
        animalCardView.layer.borderWidth = 1.0
        animalCardView.layer.borderColor = UIColor.black.cgColor

        return animalCardView
    }

    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        if let view = Bundle.main.loadNibNamed("SwipeOverlayView",
                                               owner: nil, options: nil)?[0] as? OverlayView {
            view.layer.masksToBounds = true
            view.layer.cornerRadius = kolodaView.frame.width / 10
            return view
        }
        return nil
    }

    func kolodaSwipeThresholdRatioMargin(_ koloda: KolodaView) -> CGFloat? {
        return CGFloat(0.35)
    }
}


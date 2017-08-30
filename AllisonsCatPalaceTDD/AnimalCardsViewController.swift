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
    var registry: AnimalFetching.Type = AnimalRegistry.self

    var animals = [Animal]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.kolodaView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        registry.fetchAllAnimals { fetchedAnimals in
            self.animals = fetchedAnimals
        }

        kolodaView.dataSource = self
        kolodaView.delegate = self
    }
}

extension AnimalCardsViewController: KolodaViewDelegate {
//    func koloda(koloda: KolodaView, didSelectCardAt index: Int) {
//        transition to detail view
//    }
}

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

        // if the card is the 10th to last card, kick off a new fetch, add the new results to the existing. As long as the offset matches the number being fetched we don't get duplicates.
        if index == animals.count - 10 {
            registry.offset += 50
            registry.fetchAllAnimals { fetchedAnimals in
                self.animals += fetchedAnimals
            }
        }

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

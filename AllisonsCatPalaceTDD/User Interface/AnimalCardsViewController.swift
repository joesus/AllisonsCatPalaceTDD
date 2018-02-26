// swiftlint:disable fatal_error_message
//
//  AnimalCardsViewController.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 8/27/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Koloda
import RealmSwift
import UIKit

class AnimalCardsViewController: UIViewController {
    @IBOutlet fileprivate(set) weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet fileprivate(set) weak var deckView: KolodaView!
    var registry: AnimalFinding.Type = PetFinderAnimalRegistry.self

    var animals = [Animal]() {
        didSet {
            // Kick off all the requests and let the image provider handle them so they're in the cache when they're needed
            animals.forEach { animal in
                if let midSizeUrl = animal.imageLocations.medium.first {
                    ImageProvider.getImage(for: midSizeUrl, completion: { _ in })
                } else if let smallSizeUrl = animal.imageLocations.small.first {
                    ImageProvider.getImage(for: smallSizeUrl, completion: { _ in })
                } else if let largeSizeUrl = animal.imageLocations.large.first {
                    ImageProvider.getImage(for: largeSizeUrl, completion: { _ in })
                }
            }

            DispatchQueue.main.async { [weak self] in
                // Koloda view basically highjacks whatever screen is visible when it's reloaded so important to only do it when this controller is displayed
                guard self?.navigationController?.topViewController == self else { return }

                self?.deckView.reloadData()
            }
        }
    }

    var searchParameters: PetFinderSearchParameters!

    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.startAnimating()
        registry.offset = 0
        registry.findAnimals(
            matching: PetFinderSearchParameters(zipCode: ZipCode(rawValue: "80220")!),
            cursor: PaginationCursor(size: 20)
        ) { [weak self] fetchedAnimals in

            // Delay accounts for the built in animation time for loading the kolodaView
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                self?.activityIndicator.stopAnimating()
            }
            self?.animals = fetchedAnimals
        }

        deckView.dataSource = self
        deckView.delegate = self
    }
}

extension AnimalCardsViewController: KolodaViewDelegate {
    //    func koloda(koloda: KolodaView, didSelectCardAt index: Int) {
    //        transition to detail view
    //    }

    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        guard animals.indices.contains(index) else {
            fatalError()
        }

        let animal = animals[index]

        guard direction == .right,
            let realm = try? Realm()
            else {
                return
        }

        try? realm.write {
            realm.add(animal.managedObject, update: true)
        }
    }
}

extension AnimalCardsViewController: KolodaViewDataSource {
    func kolodaSpeedThatCardShouldDrag(_ koloda: Koloda.KolodaView) -> Koloda.DragSpeed {
        return .default
    }

    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return animals.count
    }

    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        guard let animalCardView = Bundle.main.loadNibNamed(
            "AnimalCardView",
            owner: self,
            options: nil
            )?.first as? AnimalCardView
            else {
                return UIView()
        }

        // if the card is the 10th to last card, kick off a new fetch, add the new results to the existing. As long as the offset matches the number being fetched we don't get duplicates.
        if index == animals.count - 10 {
//            registry.offset += 20
            registry.findAnimals(
                matching: PetFinderSearchParameters(zipCode: ZipCode(rawValue: "80220")!),
                cursor: PaginationCursor(size: 20)
            ) { fetchedAnimals in

                self.animals += fetchedAnimals
            }
        }

        animalCardView.configure(with: animals[index])
        animalCardView.layer.masksToBounds = true
        animalCardView.layer.cornerRadius = deckView.frame.width / 10
        animalCardView.layer.borderWidth = 1.0
        animalCardView.layer.borderColor = UIColor.black.cgColor

        return animalCardView
    }

    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        guard let view = Bundle.main.loadNibNamed(
            "SwipeOverlayView",
            owner: nil,
            options: nil
            )?[0] as? OverlayView else {
            return nil
        }
        view.layer.masksToBounds = true
        view.layer.cornerRadius = deckView.frame.width / 10
        return view
    }

    func kolodaSwipeThresholdRatioMargin(_ koloda: KolodaView) -> CGFloat? {
        return CGFloat(0.35)
    }
}

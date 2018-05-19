//
//  AnimalCardsViewController.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 8/27/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Koloda

class AnimalCardsViewController: UIViewController {
    @IBOutlet weak var deckView: KolodaView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    fileprivate var searchController: PetFinderSearchController!
    var searchCriteria: PetFinderSearchParameters!
    var registry: AnimalFinding.Type = PetFinderAnimalRegistry.self
    var imageProvider: ImageProviding.Type!

    private var searchInitiated = false

    override func viewDidLoad() {
        super.viewDidLoad()

        deckView.dataSource = self
        deckView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard !searchInitiated else { return }

        searchInitiated = true

        searchController = registry.searchController(for: searchCriteria) { _ in
        }
        searchController.getMoreResults()
    }
}

extension AnimalCardsViewController: KolodaViewDataSource, KolodaViewDelegate {
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return searchController?.results.count ?? 0
    }

    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }

    func kolodaSwipeThresholdRatioMargin(_ koloda: KolodaView) -> CGFloat? {
        return 0.35
    }

    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        guard let card = Bundle.main.loadNibNamed(
            "AnimalCardView",
            owner: self,
            options: nil
            )?
            .first as? AnimalCardView
            else {
                fatalError("Unable to dequeue animal card view")
        }

        card.imageProvider = imageProvider
        return card
    }

    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed(
            "SwipeOverlayView",
            owner: self,
            options: nil
            )?
            .first as? SwipeOverlayView
    }

}

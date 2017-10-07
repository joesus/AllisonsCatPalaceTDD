//
//  FavoritesListControllerTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 2/12/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import XCTest
import TestableUIKit
import RealmSwift
@testable import AllisonsCatPalaceTDD

class FavoritesListControllerTests: XCTestCase {

    var realm: Realm!
    var controller: FavoritesListController!
    var navController: UINavigationController!
    var tableView: UITableView!
    let firstCatIndexPath = IndexPath(row: 0, section: 0)

    override func setUp() {
        super.setUp()

        realm = realmForTest(withName: name!)
        reset(realm)
        InjectionMap.realm = realm

        navController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! UINavigationController
        
        replaceRootViewController(with: navController) // the main controller for the window is now the navController

        URLSessionTask.beginStubbingResume()

        guard let favoritesListController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FavoritesListController") as? FavoritesListController else {
            return XCTFail("Could not instantiate favorites list controller from main storyboard")
        }

        navController.addChildViewController(favoritesListController)
        controller = navController.topViewController as! FavoritesListController
        tableView = controller.tableView

    }

    override func tearDown() {
        restoreRootViewController()
        URLSessionTask.endStubbingResume()

        super.tearDown()
    }

    func testIsTableViewController() {
        XCTAssert(controller as Any is UITableViewController, "FavoritesListController should be a UITableViewController")
    }

    func testHasNoAnimalsByDefault() {
        XCTAssert(controller.animals.isEmpty, "FavoritesListController should have no animals by default, had: \(controller.animals.count) animals")
    }

    func testFetchesDataOnLoad() {
        addCatsToRealm()

        controller.viewDidLoad()

        XCTAssertEqual(cats.count, controller.animals.count,
                       "Controller should load correct number of animals from local storage")

        controller.animals.enumerated().forEach { index, animal in
            XCTAssertEqual(animal.identifier, cats[index].identifier,
                           "animal with identifier: \(animal.identifier) should be loaded from local storage")
        }
    }

    func testViewDidLoadCallsSuperViewDidLoad() {
        UITableViewController.ViewDidLoadSpyController.createSpy(on: controller)!.spy {
            controller.viewDidLoad()
            XCTAssert(controller.superclassViewDidLoadCalled, "ViewDidLoad should call viewDidLoad on UIViewController")
        }
    }

    func testReloadDataIsCalledWhenAnimalsAreUpdated() {
        let reloadedPredicate = NSPredicate { [controller] _,_ in
            controller!.tableView.reloadDataCalled
        }
        expectation(for: reloadedPredicate, evaluatedWith: [:], handler: nil)

        UITableView.ReloadDataSpyController.createSpy(on: tableView)!.spy {
            DispatchQueue.global(qos: .background).async { [weak controller] in
                let cat = Animal(name: "Test", identifier: 1)
                controller?.animals.append(cat)
            }

            waitForExpectations(timeout: 2, handler: nil)
            XCTAssert(tableView.reloadDataCalled,
                      "TableView should be reloaded when animals are updated")
            XCTAssert(tableView.reloadDataCalledOnMainThread!,
                      "Reload data should be called on the main thread when animals are updated on a background thread")
        }
    }

    func testReloadDataIsCalledWhenAnimalsAreCleared() {
        let reloadedPredicate = NSPredicate { [controller] _,_ in
            controller!.tableView.reloadDataCalled
        }
        expectation(for: reloadedPredicate, evaluatedWith: [:], handler: nil)

        UITableView.ReloadDataSpyController.createSpy(on: tableView)!.spy {
            DispatchQueue.global(qos: .background).async { [weak controller] in
                controller?.animals = []
            }

            waitForExpectations(timeout: 2, handler: nil)

            guard tableView.reloadDataCalled else {
                return XCTFail("TableView should be reloaded when animals are cleared")
            }

            XCTAssert(tableView.reloadDataCalledOnMainThread!,
                      "Reload data should be called on the main thread when animals are cleared on a background thread")
        }
    }

    func testEditAction() {
        addCatsToRealm()

        controller.viewDidLoad() // trigger a new fetch of the animals

        tableView.dataSource!.tableView!(tableView, commit: .delete, forRowAt: firstCatIndexPath)

        XCTAssertEqual(realm.objects(AnimalObject.self).count, cats.count - 1,
                       "Deleting a single row should delete a single animal from local storage")
    }

    func testDeletesCorrectAnimal() {
        addCatsToRealm()
        controller.viewDidLoad()

        let randomCatIndex = Int(arc4random_uniform(UInt32(controller.animals.count)))
        let randomCatId = controller.animals[randomCatIndex].identifier

        tableView.dataSource?.tableView?(tableView, commit: .delete, forRowAt: IndexPath(row: randomCatIndex, section: 0))

        XCTAssertFalse(controller.animals.contains(where: { $0.identifier == randomCatId }),
                       "Animal at corresponding deleted index path should be removed")
    }

    func testDeleteRemovesRow() {
        addCatsToRealm()
        controller.viewDidLoad()

        XCTAssertEqual(tableView.numberOfRows(inSection: 0), cats.count,
                       "Number of rows in tableview should equal the number of cats")

        tableView.dataSource?.tableView?(tableView, commit: .delete, forRowAt: firstCatIndexPath)

        XCTAssertEqual(tableView.numberOfRows(inSection: 0), cats.count - 1,
                       "Deleting a single row should remove a single row from the tableview")
    }

    func testDeletingFinalAnimalRemovesSection() {
        try? realm.write {
            realm.add(SampleCat.managedObject, update: true)
        }
        XCTAssertEqual(realm.objects(AnimalObject.self).count, 1,
                       "Single animal should be persisted correctly")
        controller.viewDidLoad()

        XCTAssertEqual(tableView.numberOfSections, 1,
                       "Tableview should have one section where there are animals to display")

        tableView.dataSource?.tableView?(tableView, commit: .delete, forRowAt: firstCatIndexPath)

        XCTAssertEqual(tableView.numberOfSections, 0,
                       "Tableview should have zero sections after removing final row")
    }

    func testPrepareForSeguePreparesDetailController() {
        controller.animals = [SampleCat]

        guard let destination = UIStoryboard(name: "Main", bundle: Bundle(for: CatDetailController.self)).instantiateViewController(withIdentifier: "CatDetailController") as? CatDetailController else {
            return XCTFail("Main storyboard should have a cat detail controller scene")
        }

        let segue = UIStoryboardSegue(identifier: "ShowCatDetail", source: controller, destination: destination)

        tableView.selectRow(at: firstCatIndexPath, animated: false, scrollPosition: .none)

        controller.prepare(for: segue, sender: nil)

        XCTAssertTrue(destination.cat === SampleCat,
                      "The cat representing the selected cell should be set on the destination view controller")
        XCTAssertEqual(destination.navigationItem.title, "SampleCat",
                       "The title of the detail page should be the name of the displayed cat")
    }

    func testPerformSeguePushesDetailController() {
        replaceRootViewController(with: controller)

        let predicateBlock: PredicateBlock = { _, _ in
            self.navController.topViewController is CatDetailController
        }
        expectation(for: NSPredicate(block: predicateBlock), evaluatedWith: self)

        UIViewController.PerformSegueSpyController.createSpy(on: controller)!.spy {
            controller.animals = [SampleCat]

            let cell = tableView.cellForRow(at: firstCatIndexPath) as? CatCell
            controller.performSegue(withIdentifier: "ShowCatDetail", sender: cell)

            waitForExpectations(timeout: 2, handler: nil)

            guard controller.performSegueCalled else {
                return XCTFail("Selecting a cell should trigger a segue")
            }
            XCTAssertEqual(controller.performSegueIdentifier, "ShowCatDetail",
                           "Segue identifier should identify the destination of the segue")
            //XCTAssertTrue(controller.performSegueSender! is FavoritesListController, "Pushed view controller should be a CatDetailController")
        }
    }

}

extension FavoritesListControllerTests {
    func addCatsToRealm(_ file: StaticString = #file, _ line: UInt = #line) {
        try? realm.write {
            cats.forEach {
                realm.add($0.managedObject, update: true)
            }
        }

        XCTAssertEqual(realm.objects(AnimalObject.self).count, cats.count,
                       "Correct number of animals should be persisted", file: file, line: line)
    }
}

//
//  AnimalBreedTests.swift
//  AllisonsCatPalaceTDDTests
//
//  Created by Joe Susnick on 9/23/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

@testable import AllisonsCatPalaceTDD
import RealmSwift
import XCTest

class AnimalBreedTests: XCTestCase {

    var realm: Realm!

    override func setUp() {
        super.setUp()

        realm = realmForTest(withName: self.name!)
        reset(realm)
    }

    func testInitializerWithEmptyString() {
        XCTAssertNil(AnimalBreed(petFinderRawValue: ""),
                     "Should not create an animal breed from an empty string")
    }

    func testInitializerWithSpecialCharacters() {
        XCTAssertNil(AnimalBreed(petFinderRawValue: "#%@@#*)%$(#@$%"),
                     "Should not create an animal breed from a special characters")
    }

    func testAllBreeds() {
        let allRawBreeds = ["Abyssinian", "Affenpinscher", "Afghan Hound", "African Grey", "Airedale Terrier", "Akbash", "Akita", "Alaskan Malamute", "Alpaca", "Amazon", "American", "American Bulldog", "American Curl", "American Eskimo Dog", "American Fuzzy Lop", "American Hairless Terrier", "American Sable", "American Shorthair", "American Staffordshire Terrier", "American Water Spaniel", "American Wirehair", "Anatolian Shepherd", "Angora Rabbit", "Appaloosa", "Appenzell Mountain Dog", "Applehead Siamese", "Arabian", "Australian Cattle Dog/Blue Heeler", "Australian Kelpie", "Australian Shepherd", "Australian Terrier", "Balinese", "Basenji", "Basset Hound", "Beagle", "Bearded Collie", "Beauceron", "Bedlington Terrier", "Belgian", "Belgian Hare", "Belgian Shepherd Dog Sheepdog", "Belgian Shepherd Laekenois", "Belgian Shepherd Malinois", "Belgian Shepherd Tervuren", "Bengal", "Bernese Mountain Dog", "Beveren", "Bichon Frise", "Birman", "Black Labrador Retriever", "Black Mouth Cur", "Black Russian Terrier", "Black and Tan Coonhound", "Bloodhound", "Blue Lacy", "Bluetick Coonhound", "Bobtail", "Boerboel", "Bolognese", "Bombay", "Border Collie", "Border Terrier", "Borzoi", "Boston Terrier", "Bouvier des Flanders", "Boxer", "Boykin Spaniel", "Briard", "Britannia Petite", "British Shorthair", "Brittany Spaniel", "Brotogeris", "Brussels Griffon", "Budgie/Budgerigar", "Bull Terrier", "Bullmastiff", "Bunny Rabbit", "Burmese", "Burmilla", "Button Quail", "Caique", "Cairn Terrier", "Calico", "Californian", "Canaan Dog", "Canadian Hairless", "Canary", "Cane Corso Mastiff", "Carolina Dog", "Catahoula Leopard Dog", "Cattle Dog", "Caucasian Sheepdog (Caucasian Ovtcharka)", "Cavalier King Charles Spaniel", "Champagne D\'Argent", "Chartreux", "Chausie", "Checkered Giant", "Chesapeake Bay Retriever", "Chicken", "Chihuahua", "Chinchilla", "Chinese Crested Dog", "Chinese Foo Dog", "Chinook", "Chocolate Labrador Retriever", "Chow Chow", "Cinnamon", "Cirneco dell\'Etna", "Clumber Spaniel", "Clydesdale", "Cockapoo", "Cockatiel", "Cockatoo", "Cocker Spaniel", "Collie", "Conure", "Coonhound", "Corgi", "Cornish Rex", "Coton de Tulear", "Cow", "Creme D\'Argent", "Curly Horse", "Curly-Coated Retriever", "Cymric", "Dachshund", "Dalmatian", "Dandi Dinmont Terrier", "Degu", "Devon Rex", "Dilute Calico", "Dilute Tortoiseshell", "Doberman Pinscher", "Dogo Argentino", "Dogue de Bordeaux", "Domestic Long Hair", "Domestic Long Hair - brown", "Domestic Long Hair - buff", "Domestic Long Hair - buff and white", "Domestic Long Hair - gray and white", "Domestic Long Hair - orange", "Domestic Long Hair - orange and white", "Domestic Long Hair-black", "Domestic Long Hair-black and white", "Domestic Long Hair-gray", "Domestic Long Hair-white", "Domestic Medium Hair", "Domestic Medium Hair - brown", "Domestic Medium Hair - buff", "Domestic Medium Hair - buff and white", "Domestic Medium Hair - gray and white", "Domestic Medium Hair - orange and white", "Domestic Medium Hair-black", "Domestic Medium Hair-black and white", "Domestic Medium Hair-gray", "Domestic Medium Hair-orange", "Domestic Medium Hair-white", "Domestic Short Hair", "Domestic Short Hair - brown", "Domestic Short Hair - buff", "Domestic Short Hair - buff and white", "Domestic Short Hair - gray and white", "Domestic Short Hair - orange and white", "Domestic Short Hair-black", "Domestic Short Hair-black and white", "Domestic Short Hair-gray", "Domestic Short Hair-mitted", "Domestic Short Hair-orange", "Domestic Short Hair-white", "Donkey/Mule", "Dove", "Draft", "Duck", "Dutch", "Dutch Shepherd", "Dwarf", "Dwarf Eared", "Eclectus", "Egyptian Mau", "Emu", "English Bulldog", "English Cocker Spaniel", "English Coonhound", "English Lop", "English Pointer", "English Setter", "English Shepherd", "English Spot", "English Springer Spaniel", "English Toy Spaniel", "Entlebucher", "Eskimo Dog", "Exotic Shorthair", "Extra-Toes Cat (Hemingway Polydactyl)", "Feist", "Ferret", "Field Spaniel", "Fila Brasileiro", "Finch", "Finnish Lapphund", "Finnish Spitz", "Fish", "Flat-coated Retriever", "Flemish Giant", "Florida White", "Fox Terrier", "Foxhound", "French Bulldog", "French-Lop", "Frog", "Gaited", "Galgo Spanish Greyhound", "Gecko", "Gerbil", "German Pinscher", "German Shepherd Dog", "German Shorthaired Pointer", "German Spitz", "German Wirehaired Pointer", "Giant Schnauzer", "Glen of Imaal Terrier", "Goat", "Golden Retriever", "Goose", "Gordon Setter", "Grade", "Great Dane", "Great Pyrenees", "Greater Swiss Mountain Dog", "Greyhound", "Guinea Pig", "Guinea fowl", "Hamster", "Harlequin", "Harrier", "Havana", "Havanese", "Hedgehog", "Hermit Crab", "Himalayan", "Holland Lop", "Hotot", "Hound", "Hovawart", "Husky", "Ibizan Hound", "Iguana", "Illyrian Sheepdog", "Irish Setter", "Irish Terrier", "Irish Water Spaniel", "Irish Wolfhound", "Italian Greyhound", "Italian Spinone", "Jack Russell Terrier", "Jack Russell Terrier (Parson Russell Terrier)", "Japanese Bobtail", "Japanese Chin", "Javanese", "Jersey Wooly", "Jindo", "Kai Dog", "Kakariki", "Karelian Bear Dog", "Keeshond", "Kerry Blue Terrier", "Kishu", "Klee Kai", "Komondor", "Korat", "Kuvasz", "Kyi Leo", "LaPerm", "Labrador Retriever", "Lakeland Terrier", "Lancashire Heeler", "Leonberger", "Lhasa Apso", "Lilac", "Lionhead", "Lipizzan", "Lizard", "Llama", "Lop Eared", "Lory/Lorikeet", "Lovebird", "Lowchen", "Macaw", "Maine Coon", "Maltese", "Manchester Terrier", "Manx", "Maremma Sheepdog", "Mastiff", "McNab", "Mini Rex", "Mini-Lop", "Miniature Horse", "Miniature Pinscher", "Missouri Foxtrotter", "Morgan", "Mountain Cur", "Mountain Dog", "Mouse", "Munchkin", "Munsterlander", "Mustang", "Mynah", "Neapolitan Mastiff", "Nebelung", "Netherland Dwarf", "New Guinea Singing Dog", "New Zealand", "Newfoundland Dog", "Norfolk Terrier", "Norwegian Buhund", "Norwegian Elkhound", "Norwegian Forest Cat", "Norwegian Lundehund", "Norwich Terrier", "Nova Scotia Duck-Tolling Retriever", "Ocicat", "Old English Sheepdog", "Oriental Long Hair", "Oriental Short Hair", "Oriental Tabby", "Ostrich", "Otterhound", "Paint/Pinto", "Palomino", "Papillon", "Parakeet (Other)", "Parrot (Other)", "Parrotlet", "Paso Fino", "Patterdale Terrier (Fell Terrier)", "Peacock/Pea fowl", "Pekingese", "Percheron", "Persian", "Peruvian Inca Orchid", "Peruvian Paso", "Petit Basset Griffon Vendeen", "Pharaoh Hound", "Pheasant", "Pig", "Pigeon", "Pionus", "Pit Bull Terrier", "Pixie-Bob", "Plott Hound", "Podengo Portugueso", "Poicephalus/Senegal", "Pointer", "Polish", "Polish Lowland Sheepdog", "Pomeranian", "Pony", "Poodle", "Portuguese Water Dog", "Pot Bellied", "Prairie Dog", "Presa Canario", "Pug", "Puli", "Pumi", "Quail", "Quaker Parakeet", "Quarterhorse", "Ragamuffin", "Ragdoll", "Rat", "Rat Terrier", "Redbone Coonhound", "Retriever", "Rex", "Rhea", "Rhinelander", "Rhodesian Ridgeback", "Ringneck/Psittacula", "Rosella", "Rottweiler", "Russian Blue", "Saddlebred", "Saint Bernard St. Bernard", "Saluki", "Samoyed", "Sarplaninac", "Satin", "Schipperke", "Schnauzer", "Scottish Deerhound", "Scottish Fold", "Scottish Terrier Scottie", "Sealyham Terrier", "Selkirk Rex", "Setter", "Shar Pei", "Sheep", "Sheep Dog", "Shepherd", "Shetland Pony", "Shetland Sheepdog Sheltie", "Shiba Inu", "Shih Tzu", "Siamese", "Siberian", "Siberian Husky", "Silky Terrier", "Silver", "Silver Fox", "Silver Marten", "Singapura", "Skunk", "Skye Terrier", "Sloughi", "Smooth Fox Terrier", "Snake", "Snowshoe", "Softbill (Other)", "Somali", "South Russian Ovtcharka", "Spaniel", "Sphynx (hairless cat)", "Spitz", "Staffordshire Bull Terrier", "Standard Poodle", "Standardbred", "Sugar Glider", "Sussex Spaniel", "Swedish Vallhund", "Tabby", "Tabby - Brown", "Tabby - Grey", "Tabby - Orange", "Tabby - black", "Tabby - buff", "Tabby - white", "Tan", "Tarantula", "Tennessee Walker", "Terrier", "Thai Ridgeback", "Thoroughbred", "Tibetan Mastiff", "Tibetan Spaniel", "Tibetan Terrier", "Tiger", "Tonkinese", "Torbie", "Tortoiseshell", "Tosa Inu", "Toy Fox Terrier", "Treeing Walker Coonhound", "Turkish Angora", "Turkish Van", "Turtle", "Tuxedo", "Unknown", "Vietnamese Pot Bellied", "Vizsla", "Warmblood", "Weimaraner", "Welsh Corgi", "Welsh Springer Spaniel", "Welsh Terrier", "West Highland White Terrier Westie", "Wheaten Terrier", "Whippet", "White German Shepherd", "Wire Fox Terrier", "Wire-haired Pointing Griffon", "Wirehaired Terrier", "Xoloitzcuintle/Mexican Hairless", "Yellow Labrador Retriever", "Yorkshire Terrier Yorkie"
        ]

        allRawBreeds.forEach { breed in
            XCTAssertNotNil(AnimalBreed(petFinderRawValue: breed),
                          "Raw value \(breed) should create a valid animal breed")
        }
    }

    func testManagedObject() {
        XCTAssertNil(AnimalBreedObject().value,
                     "AnimalBreedObject should have no value by default")

        let original = AnimalBreed.afghanHound
        let managed = original.managedObject

        XCTAssertEqual(original.rawValue, managed.value,
                       "Managed object should store correct raw value")
    }

    func testInitializingFromManagedObject() {
        let original = AnimalBreed.akita
        let managed = original.managedObject
        let objectFromManaged = AnimalBreed(managedObject: managed)
 
        XCTAssertEqual(objectFromManaged?.rawValue, original.rawValue)
    }

    func testSavingManagedObject() {
        let original = AnimalBreed.akita
        let managed = original.managedObject

        try! realm.write {
            realm.add(managed)
        }

        let fetchedManagedObject = realm.objects(AnimalBreedObject.self).last!

        let originalValueFromFetched = AnimalBreed(managedObject: fetchedManagedObject)

        XCTAssertEqual(original.rawValue, originalValueFromFetched?.rawValue)
    }
}

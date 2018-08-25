//
//  GenotypeBuilder.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 8/2/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

final class GenotypeBuilder {

    typealias ExternalGenotype = JsonObject

    static func build(from response: PetFinderResponse) -> AnimalGenotype? {
        return buildGenotypeFromExternalGenotype(response)
    }

    static func buildGenotypeFromExternalGenotype(_ json: ExternalGenotype) -> AnimalGenotype? {
        guard let speciesContainer = json[ExternalAnimalKeys.GenotypeKeys.animal] as? JsonObject,
            let speciesString = speciesContainer[ExternalAnimalKeys.elementContentKey] as? String,
            let species = PetfinderAnimalSpecies(petFinderRawValue: speciesString) else {
                return nil
        }

        guard let purityContainer = json[ExternalAnimalKeys.GenotypeKeys.mix] as? JsonObject,
            let purityString = purityContainer[ExternalAnimalKeys.elementContentKey] as? String,
            let purity = GeneticPurity(petFinderRawValue: purityString) else {
                return nil
        }

        guard let breedsContainer = json[ExternalAnimalKeys.GenotypeKeys.breeds] as? JsonObject,
            let breedsList = breedsContainer[ExternalAnimalKeys.GenotypeKeys.breed] as? JsonArray,
            !breedsList.flatMap({ $0[ExternalAnimalKeys.elementContentKey] as? String }).isEmpty else {
            return nil
        }
        let breeds = breedsList.flatMap { $0[ExternalAnimalKeys.elementContentKey] as? String }

        return AnimalGenotype(species: species, purity: purity, breeds: breeds)
    }

}

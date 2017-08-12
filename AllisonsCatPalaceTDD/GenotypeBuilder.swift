//
//  GenotypeBuilder.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 8/2/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

final class GenotypeBuilder {

    typealias ExternalGenotype = [String: Any]

    static func build(from data: Data) -> AnimalGenotype? {
        guard let externalGenotype = decodeExternalGenotype(from: data) else {
            return nil
        }
        return buildGenotypeFromExternalGenotype(externalGenotype)
    }

    private static func buildGenotypeFromExternalGenotype(_ json: ExternalGenotype) -> AnimalGenotype? {
        guard let speciesContainer = json[ExternalAnimalKeys.GenotypeKeys.animal] as? [String: Any],
            let speciesString = speciesContainer[ExternalAnimalKeys.elementContentKey] as? String,
            let species = AnimalSpecies(petFinderRawValue: speciesString) else {
                return nil
        }

        guard let purityContainer = json[ExternalAnimalKeys.GenotypeKeys.mix] as? [String: Any],
            let purityString = purityContainer[ExternalAnimalKeys.elementContentKey] as? String,
            let purity = GeneticPurity(petFinderRawValue: purityString) else {
                return nil
        }

        guard let breedsContainer = json[ExternalAnimalKeys.GenotypeKeys.breeds] as? [String: Any],
            let breedsList = breedsContainer[ExternalAnimalKeys.GenotypeKeys.breed] as? [[String: Any]],
            !breedsList.flatMap({ $0[ExternalAnimalKeys.elementContentKey] as? String}).isEmpty else {
            return nil
        }
        let breeds = breedsList.flatMap { $0[ExternalAnimalKeys.elementContentKey] as? String }

        return AnimalGenotype(species: species, purity: purity, breeds: breeds)
    }

    private static func decodeExternalGenotype(from data: Data) -> ExternalGenotype? {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        return json as? ExternalGenotype
    }

}

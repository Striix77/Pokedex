import Foundation

struct EvolutionCondition: Codable, Hashable {
    let minLevel: Int?
    let minHappiness: Int?
    let minAffection: Int?
    let timeOfDay: String?
    let needsOverworldRain: Bool?
    let turnUpsideDown: Bool?
    let item: EvolutionNamedEntry?
    let evolutionTrigger: EvolutionNamedEntry?
    let location: EvolutionNamedEntry?
    let move: EvolutionNamedEntry?
    let type: EvolutionTypeEntry?

    enum CodingKeys: String, CodingKey {
        case minLevel = "min_level"
        case minHappiness = "min_happiness"
        case minAffection = "min_affection"
        case timeOfDay = "time_of_day"
        case needsOverworldRain = "needs_overworld_rain"
        case turnUpsideDown = "turn_upside_down"
        case item
        case evolutionTrigger = "evolutiontrigger"
        case location
        case move
        case type
    }
}

struct EvolutionNamedEntry: Codable, Hashable {
    let name: String
}

struct EvolutionTypeEntry: Codable, Hashable {
    let id: Int
    let name: String
}

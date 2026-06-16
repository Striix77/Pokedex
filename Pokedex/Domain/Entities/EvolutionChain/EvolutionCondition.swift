import Foundation

struct EvolutionCondition: Codable, Hashable {
    let minLevel: Int?
    let minHappiness: Int?
    let minAffection: Int?
    let timeOfDay: String?
    let needsOverworldRain: Bool?
    let turnUpsideDown: Bool?
    let item: EvolutionNamedEntry?
    let evolutionTrigger: EvolutionTriggerEntry?
    let location: EvolutionNamedEntry?
    let move: EvolutionNamedEntry?
    let usedMove: EvolutionNamedEntry?
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
        case usedMove = "usedmove"
        case type
    }
}

extension EvolutionCondition {
    struct DisplayCondition: Hashable {
        let label: String
        let value: String
    }

    var displayConditions: [DisplayCondition] {
        var result: [DisplayCondition] = []
        if let level = minLevel { result.append(.init(label: "lv", value: "\(level)")) }
        if let item = item { result.append(.init(label: "itm", value: item.name)) }
        if let move = move { result.append(.init(label: "mov", value: move.name)) }
        if let location = location { result.append(.init(label: "loc", value: location.name)) }
        if let type = type { result.append(.init(label: "typ", value: type.name)) }
        if let happiness = minHappiness { result.append(.init(label: "hap", value: "\(happiness)")) }
        if let affection = minAffection { result.append(.init(label: "aff", value: "\(affection)")) }
        if let tod = timeOfDay, !tod.isEmpty { result.append(.init(label: "tim", value: tod)) }
        if needsOverworldRain == true { result.append(.init(label: "wea", value: "rain")) }
        if turnUpsideDown == true { result.append(.init(label: "ori", value: "upside down")) }
        return result
    }

    var shortDescription: String {
        switch evolutionTrigger?.name {
        case .useItem:
            return item.map { Self.format($0.name) } ?? "Item"
        case .trade:
            return (["Trade"] + [item.map { Self.format($0.name) }].compactMap { $0 }).joined(separator: " • ")
        case .megaEvolution:
            return item.map { Self.format($0.name) } ?? "Mega Stone"
        case .levelUp:
            var parts: [String] = [minLevel.map { "Lv \($0)" } ?? "Lv up"]
            if let item = item { parts.append(Self.format(item.name)) }
            if let move = move { parts.append("\(Self.format(move.name)) mov") }
            if let location = location { parts.append(Self.format(location.name)) }
            if let type = type { parts.append(type.name.capitalized) }
            if let happiness = minHappiness { parts.append("Hap \(happiness)+") }
            if let affection = minAffection { parts.append("Aff \(affection)+") }
            if let tod = timeOfDay, !tod.isEmpty { parts.append(tod.capitalized) }
            if needsOverworldRain == true { parts.append("Rain") }
            if turnUpsideDown == true { parts.append("Upside down") }
            return parts.joined(separator: " • ")
        case .spin: return "Spin"
        case .shed: return "Special"
        case .towerOfDarkness: return "Tower of Darkness"
        case .towerOfWaters: return "Tower of Waters"
        case .threeCriticalHits: return "3 Critical Hits"
        case .takeDamage: return "Take Damage"
        case .agileStyleMove: return "Agile Style"
        case .strongStyleMove: return "Strong Style"
        case .recoilDamage: return "Recoil"
        case .useMove: return usedMove.map { Self.format($0.name) } ?? "Use Move"
        case .other: return "Special"
        case nil: return ""
        }
    }

    var fullDescription: String {
        var extras: [String] = []
        let trigger = evolutionTrigger?.name
        if let item = item, trigger != .useItem && trigger != .megaEvolution {
            extras.append("while holding \(Self.format(item.name))")
        }
        if let move = move { extras.append("knowing \(Self.format(move.name))") }
        if let location = location { extras.append("near \(Self.format(location.name))") }
        if let type = type { extras.append("knowing a \(type.name)-type move") }
        if let happiness = minHappiness { extras.append("with \(happiness)+ happiness") }
        if let affection = minAffection { extras.append("with \(affection)+ affection") }
        if let tod = timeOfDay, !tod.isEmpty { extras.append("during \(tod)") }
        if needsOverworldRain == true { extras.append("while it's raining") }
        if turnUpsideDown == true { extras.append("while holding your device upside down") }

        let suffix = extras.isEmpty ? "" : " " + extras.joined(separator: ", ")

        switch trigger {
        case .useItem:
            return "Use a \(item.map { Self.format($0.name) } ?? "item")"
        case .trade:
            return "Trade\(suffix)"
        case .megaEvolution:
            return "Mega evolve using \(item.map { Self.format($0.name) } ?? "a mega stone")"
        case .levelUp:
            let base = minLevel.map { "Reach level \($0)" } ?? "Level up"
            return "\(base)\(suffix)"
        case .spin: return "Spin in place\(suffix)"
        case .shed: return "Evolve Nincada with an empty party slot and a Poké Ball"
        case .towerOfDarkness: return "Complete the Tower of Darkness"
        case .towerOfWaters: return "Complete the Tower of Waters"
        case .threeCriticalHits: return "Land 3 critical hits in one battle"
        case .takeDamage: return "Take 49+ damage without fainting, then pass through the stone arch"
        case .agileStyleMove: return "Use an agile style move\(suffix)"
        case .strongStyleMove: return "Use a strong style move\(suffix)"
        case .recoilDamage: return "Take recoil damage\(suffix)"
        case .useMove:
            let moveName = usedMove.map { Self.format($0.name) } ?? "a specific move"
            return "Use \(moveName) enough times\(suffix)"
        case .other: return "Special condition"
        case nil: return ""
        }
    }

    private static func format(_ name: String) -> String {
        name.split(separator: "-").map { $0.capitalized }.joined(separator: " ")
    }
}

struct EvolutionNamedEntry: Codable, Hashable {
    let name: String
}

struct EvolutionTriggerEntry: Codable, Hashable {
    let name: EvolutionTrigger
}

enum EvolutionTrigger: String, Codable, Hashable {
    case levelUp = "level-up"
    case useItem = "use-item"
    case trade
    case shed
    case spin
    case megaEvolution = "mega-evolution"
    case towerOfDarkness = "tower-of-darkness"
    case towerOfWaters = "tower-of-waters"
    case threeCriticalHits = "three-critical-hits"
    case takeDamage = "take-damage"
    case agileStyleMove = "agile-style-move"
    case strongStyleMove = "strong-style-move"
    case recoilDamage = "recoil-damage"
    case useMove = "use-move"
    case other

    init(from decoder: Decoder) throws {
        let rawValue = try decoder.singleValueContainer().decode(String.self)
        self = EvolutionTrigger(rawValue: rawValue) ?? .other
    }

    var icon: String {
        switch self {
        case .levelUp: return "arrow.up.circle"
        case .useItem: return "sparkles"
        case .trade: return "arrow.left.arrow.right"
        case .shed: return "circle.dashed"
        case .spin: return "arrow.2.circlepath"
        case .megaEvolution: return "bolt.circle.fill"
        case .towerOfDarkness: return "moon.stars.fill"
        case .towerOfWaters: return "drop.fill"
        case .threeCriticalHits: return "burst.fill"
        case .takeDamage: return "heart.slash"
        case .agileStyleMove: return "hare.fill"
        case .strongStyleMove: return "dumbbell.fill"
        case .recoilDamage: return "arrow.counterclockwise"
        case .useMove: return "figure.martial.arts"
        case .other: return "questionmark.circle"
        }
    }
}

struct EvolutionTypeEntry: Codable, Hashable {
    let id: Int
    let name: String
}

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
        case "use-item":
            return item.map { Self.format($0.name) } ?? "Item"
        case "trade":
            return (["Trade"] + [item.map { Self.format($0.name) }].compactMap { $0 }).joined(separator: " • ")
        case "mega-evolution":
            return item.map { Self.format($0.name) } ?? "Mega Stone"
        case "level-up":
            var parts: [String] = [minLevel.map { "Lv \($0)" } ?? "Lv up"]
            if let item = item               { parts.append(Self.format(item.name)) }
            if let move = move               { parts.append(Self.format(move.name)) }
            if let location = location       { parts.append(Self.format(location.name)) }
            if let type = type               { parts.append(type.name.capitalized) }
            if let happiness = minHappiness  { parts.append("Hap \(happiness)+") }
            if let affection = minAffection  { parts.append("Aff \(affection)+") }
            if let tod = timeOfDay, !tod.isEmpty { parts.append(tod.capitalized) }
            if needsOverworldRain == true    { parts.append("Rain") }
            if turnUpsideDown == true        { parts.append("Upside down") }
            return parts.joined(separator: " • ")
        default:
            return evolutionTrigger.map { Self.format($0.name) } ?? ""
        }
    }

    var fullDescription: String {
        var extras: [String] = []
        if let item = item, evolutionTrigger?.name != "use-item" && evolutionTrigger?.name != "mega-evolution" {
            extras.append("while holding \(Self.format(item.name))")
        }
        if let move = move               { extras.append("knowing \(Self.format(move.name))") }
        if let location = location       { extras.append("near \(Self.format(location.name))") }
        if let type = type               { extras.append("knowing a \(type.name)-type move") }
        if let happiness = minHappiness  { extras.append("with \(happiness)+ happiness") }
        if let affection = minAffection  { extras.append("with \(affection)+ affection") }
        if let tod = timeOfDay, !tod.isEmpty { extras.append("during \(tod)") }
        if needsOverworldRain == true    { extras.append("while it's raining") }
        if turnUpsideDown == true        { extras.append("while holding your device upside down") }

        let suffix = extras.isEmpty ? "" : " " + extras.joined(separator: ", ")

        switch evolutionTrigger?.name {
        case "use-item":
            return "Use a \(item.map { Self.format($0.name) } ?? "item")"
        case "trade":
            return "Trade\(suffix)"
        case "mega-evolution":
            return "Mega evolve using \(item.map { Self.format($0.name) } ?? "a mega stone")"
        case "level-up":
            let base = minLevel.map { "Reach level \($0)" } ?? "Level up"
            return "\(base)\(suffix)"
        case "spin":
            return "Spin in place\(suffix)"
        case "three-critical-hits":
            return "Land 3 critical hits in one battle"
        case "take-damage":
            return "Take 49+ damage without fainting, then pass through the stone arch"
        default:
            let base = evolutionTrigger.map { Self.format($0.name) } ?? "Evolve"
            return "\(base)\(suffix)"
        }
    }

    private static func format(_ name: String) -> String {
        name.split(separator: "-").map { $0.capitalized }.joined(separator: " ")
    }
}

struct EvolutionNamedEntry: Codable, Hashable {
    let name: String
}

struct EvolutionTypeEntry: Codable, Hashable {
    let id: Int
    let name: String
}

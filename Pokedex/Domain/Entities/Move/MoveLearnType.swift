import Foundation

enum MoveLearnType: String {
    case levelUp, tm, hm, egg

    var label: String {
        switch self {
        case .levelUp: return "Level-Up"
        case .tm: return "TM"
        case .hm: return "HM"
        case .egg: return "Egg"
        }
    }
}

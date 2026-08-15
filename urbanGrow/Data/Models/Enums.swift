import Foundation

enum PlantType: String, Codable, CaseIterable {
    case seledri = "Seledri"
    case daunBawangPrei = "Daun Bawang Prei"
    case jahe = "Jahe"

    var icon: String {
        switch self {
        case .seledri: return "leaf"
        case .daunBawangPrei: return "carrot"
        case .jahe: return "globe.asia.australia"
        }
    }

    var colorHex: String {
        switch self {
        case .seledri: return "#4CAF50"
        case .daunBawangPrei: return "#8BC34A"
        case .jahe: return "#FF9800"
        }
    }
}

enum TaskStatus: String, Codable {
    case pending = "pending"
    case completed = "completed"
    case skipped = "skipped"
    case delayed = "delayed"
}

enum CostCategory: String, Codable, CaseIterable {
    case infrastructure = "Infrastruktur"
    case operational = "Operasional"
    case seed = "Bibit"
    case fertilizer = "Pupuk"
    case soil = "Tanah/Media"
    case other = "Lainnya"
}

enum BatchStatus: String, Codable {
    case growing = "growing"
    case harvested = "harvested"
    case archived = "archived"
}

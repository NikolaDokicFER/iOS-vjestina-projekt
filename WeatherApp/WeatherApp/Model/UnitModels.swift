import Foundation

enum temperatureUnit: String, Codable {
    case C
    case F
}

enum windUnit: String, Codable {
    case mps
    case kmh
    case mph
    case knots
}

enum pressureUnit: String, Codable {
    case mbar
    case atm
    case mmhg
    case inhg
    case hpa
}

struct SettingsModel: Codable {
    let temperatureUnit: temperatureUnit
    let windUnit: windUnit
    let pressureUnit: pressureUnit
}

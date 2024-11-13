import UIKit

struct ColorPreset {
    let name: String
    let thaiName: String
    let color: UIColor
    let identifier: String
    
    static let softLight = ColorPreset(
        name: "Soft Light",
        thaiName: "แสงนุ่ม",
        color: UIColor(hex: "#FFE4E1"),
        identifier: "softLight"
    )
    
    static let coolLight = ColorPreset(
        name: "Cool Light",
        thaiName: "แสงเย็น",
        color: UIColor(hex: "#F0F8FF"),
        identifier: "coolLight"
    )
    
    static let warmPink = ColorPreset(
        name: "Warm Pink",
        thaiName: "ชมพูอุ่น",
        color: UIColor(hex: "#FFF0F5"),
        identifier: "warmPink"
    )
    
    static let natural = ColorPreset(
        name: "Natural",
        thaiName: "ธรรมชาติ",
        color: UIColor(hex: "#F5F5DC"),
        identifier: "natural"
    )
    
    static let lavender = ColorPreset(
        name: "Lavender",
        thaiName: "ลาเวนเดอร์",
        color: UIColor(hex: "#E6E6FA"),
        identifier: "lavender"
    )
    
    static let fresh = ColorPreset(
        name: "Fresh",
        thaiName: "สดใส",
        color: UIColor(hex: "#F0FFF0"),
        identifier: "fresh"
    )
    
    static let bright = ColorPreset(
        name: "Bright",
        thaiName: "สว่าง",
        color: UIColor(hex: "#FFF5EE"),
        identifier: "bright"
    )
    
    static let studio = ColorPreset(
        name: "Studio",
        thaiName: "สตูดิโอ",
        color: UIColor(hex: "#F8F8FF"),
        identifier: "studio"
    )
}

class PresetManager {
    static let shared = PresetManager()
    
    let presets: [ColorPreset] = [
        .softLight,
        .coolLight,
        .warmPink,
        .natural,
        .lavender,
        .fresh,
        .bright,
        .studio
    ]
    
    func getPreset(by identifier: String) -> ColorPreset? {
        return presets.first { $0.identifier == identifier }
    }
    
    func saveLastUsedPreset(_ preset: ColorPreset) {
        UserDefaults.standard.set(preset.identifier, forKey: "lastUsedPreset")
    }
    
    func getLastUsedPreset() -> ColorPreset? {
        guard let identifier = UserDefaults.standard.string(forKey: "lastUsedPreset") else {
            return presets.first
        }
        return getPreset(by: identifier)
    }
}

extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(a) / 255
        )
    }
} 
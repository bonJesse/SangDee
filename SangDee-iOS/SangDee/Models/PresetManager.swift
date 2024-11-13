import UIKit

struct ColorPreset {
    let name: String
    let thaiName: String
    let color: UIColor
}

class PresetManager {
    let presets: [ColorPreset] = [
        ColorPreset(name: "Soft Light", thaiName: "แสงนุ่ม", color: UIColor(hex: "#FFE4E1")),
        ColorPreset(name: "Cool Light", thaiName: "แสงเย็น", color: UIColor(hex: "#F0F8FF")),
        ColorPreset(name: "Warm Pink", thaiName: "ชมพูอุ่น", color: UIColor(hex: "#FFF0F5")),
        ColorPreset(name: "Natural", thaiName: "ธรรมชาติ", color: UIColor(hex: "#F5F5DC")),
        ColorPreset(name: "Lavender", thaiName: "ลาเวนเดอร์", color: UIColor(hex: "#E6E6FA")),
        ColorPreset(name: "Fresh", thaiName: "สดใส", color: UIColor(hex: "#F0FFF0")),
        ColorPreset(name: "Bright", thaiName: "สว่าง", color: UIColor(hex: "#FFF5EE")),
        ColorPreset(name: "Studio", thaiName: "สตูดิโอ", color: UIColor(hex: "#F8F8FF"))
    ]
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
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
} 
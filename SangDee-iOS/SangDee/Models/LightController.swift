import UIKit

class LightController {
    private var currentColor: UIColor = .white
    private var brightness: CGFloat = 0.5
    private var contrast: CGFloat = 1.0
    
    func setBrightness(_ value: CGFloat) {
        brightness = value
        updateLight()
    }
    
    func setContrast(_ value: CGFloat) {
        contrast = value
        updateLight()
    }
    
    func setColor(_ color: UIColor) {
        currentColor = color
        updateLight()
    }
    
    func applyPreset(_ preset: ColorPreset) {
        currentColor = preset.color
        updateLight()
    }
    
    private func updateLight() {
        // 实际的硬件控制逻辑将在这里实现
        print("Light updated - Color: \(currentColor), Brightness: \(brightness), Contrast: \(contrast)")
    }
} 
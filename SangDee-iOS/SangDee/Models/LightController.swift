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
    
    private func updateLight() {
        // 这里实现与硬件的通信逻辑
        // 目前仅打印状态
        print("Light updated - Color: \(currentColor), Brightness: \(brightness), Contrast: \(contrast)")
    }
} 
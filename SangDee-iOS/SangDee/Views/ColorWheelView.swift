import UIKit

protocol ColorWheelDelegate: AnyObject {
    func colorWheelDidSelect(color: UIColor)
}

class ColorWheelView: UIView {
    weak var delegate: ColorWheelDelegate?
    private var colorWheel: CALayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupColorWheel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupColorWheel()
    }
    
    private func setupColorWheel() {
        let wheelLayer = CALayer()
        wheelLayer.frame = bounds
        wheelLayer.cornerRadius = bounds.width / 2
        layer.addSublayer(wheelLayer)
        colorWheel = wheelLayer
        
        let touchGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(touchGesture)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        colorWheel?.frame = bounds
        colorWheel?.cornerRadius = bounds.width / 2
        drawColorWheel()
    }
    
    private func drawColorWheel() {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let radius = bounds.width / 2
        for angle in 0..<360 {
            let startAngle = CGFloat(angle) * .pi / 180
            let endAngle = CGFloat(angle + 2) * .pi / 180
            
            context.move(to: CGPoint(x: bounds.midX, y: bounds.midY))
            context.addArc(center: CGPoint(x: bounds.midX, y: bounds.midY),
                          radius: radius,
                          startAngle: startAngle,
                          endAngle: endAngle,
                          clockwise: false)
            
            let color = UIColor(hue: CGFloat(angle)/360,
                              saturation: 1,
                              brightness: 1,
                              alpha: 1)
            context.setFillColor(color.cgColor)
            context.fillPath()
        }
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self)
        let color = getColor(at: location)
        delegate?.colorWheelDidSelect(color: color)
    }
    
    private func getColor(at point: CGPoint) -> UIColor {
        let pixel = UnsafeMutablePointer<UInt8>.allocate(capacity: 4)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        guard let context = CGContext(data: pixel,
                                    width: 1,
                                    height: 1,
                                    bitsPerComponent: 8,
                                    bytesPerRow: 4,
                                    space: colorSpace,
                                    bitmapInfo: bitmapInfo.rawValue) else {
            return .white
        }
        
        context.translateBy(x: -point.x, y: -point.y)
        layer.render(in: context)
        
        let red = CGFloat(pixel[0]) / 255
        let green = CGFloat(pixel[1]) / 255
        let blue = CGFloat(pixel[2]) / 255
        
        pixel.deallocate()
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
} 
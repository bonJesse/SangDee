import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol RGBControlDelegate: AnyObject {
    func rgbControlDidChange(red: CGFloat, green: CGFloat, blue: CGFloat)
}

class RGBControlView: UIView {
    weak var delegate: RGBControlDelegate?
    private let disposeBag = DisposeBag()
    
    private let redSlider = UISlider()
    private let greenSlider = UISlider()
    private let blueSlider = UISlider()
    
    private let redLabel = UILabel()
    private let greenLabel = UILabel()
    private let blueLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupBindings()
    }
    
    private func setupViews() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        addSubview(stackView)
        
        [redSlider, greenSlider, blueSlider].forEach { slider in
            slider.minimumValue = 0
            slider.maximumValue = 255
            slider.value = 255
        }
        
        // Configure labels
        [redLabel, greenLabel, blueLabel].forEach { label in
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 12)
        }
        
        redLabel.text = "R แดง"
        greenLabel.text = "G เขียว"
        blueLabel.text = "B น้ำเงิน"
        
        // Add components to stack view
        [redSlider, greenSlider, blueSlider].enumerated().forEach { index, slider in
            let label = [redLabel, greenLabel, blueLabel][index]
            let container = UIStackView(arrangedSubviews: [label, slider])
            container.axis = .vertical
            container.spacing = 8
            stackView.addArrangedSubview(container)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        }
    }
    
    private func setupBindings() {
        Observable.combineLatest(
            redSlider.rx.value,
            greenSlider.rx.value,
            blueSlider.rx.value
        )
        .subscribe(onNext: { [weak self] red, green, blue in
            self?.delegate?.rgbControlDidChange(
                red: CGFloat(red/255),
                green: CGFloat(green/255),
                blue: CGFloat(blue/255)
            )
        })
        .disposed(by: disposeBag)
    }
    
    func setColor(_ color: UIColor) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: nil)
        
        redSlider.value = Float(red * 255)
        greenSlider.value = Float(green * 255)
        blueSlider.value = Float(blue * 255)
    }
} 
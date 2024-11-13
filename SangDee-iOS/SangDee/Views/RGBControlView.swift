import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol RGBControlDelegate: AnyObject {
    func rgbControlDidChange(red: CGFloat, green: CGFloat, blue: CGFloat)
}

class RGBControlView: UIView {
    
    // MARK: - UI Components
    private let redSlider = UISlider()
    private let greenSlider = UISlider()
    private let blueSlider = UISlider()
    
    private let redLabel = UILabel()
    private let greenLabel = UILabel()
    private let blueLabel = UILabel()
    
    private let redValueLabel = UILabel()
    private let greenValueLabel = UILabel()
    private let blueValueLabel = UILabel()
    
    // MARK: - Properties
    weak var delegate: RGBControlDelegate?
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupBindings()
    }
    
    // MARK: - Setup
    private func setupUI() {
        [redSlider, greenSlider, blueSlider].forEach { slider in
            slider.minimumValue = 0
            slider.maximumValue = 255
            slider.value = 255
        }
        
        redLabel.text = "R แดง"
        greenLabel.text = "G เขียว"
        blueLabel.text = "B น้ำเงิน"
        
        [redLabel, greenLabel, blueLabel].forEach { label in
            label.font = .systemFont(ofSize: 14)
            label.textColor = .label
        }
        
        [redValueLabel, greenValueLabel, blueValueLabel].forEach { label in
            label.font = .systemFont(ofSize: 12)
            label.textColor = .secondaryLabel
            label.textAlignment = .right
        }
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        
        [redSlider, greenSlider, blueSlider].enumerated().forEach { index, slider in
            let label = [redLabel, greenLabel, blueLabel][index]
            let valueLabel = [redValueLabel, greenValueLabel, blueValueLabel][index]
            
            let container = UIStackView(arrangedSubviews: [
                label,
                slider,
                valueLabel
            ])
            container.axis = .vertical
            container.spacing = 8
            stackView.addArrangedSubview(container)
        }
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupBindings() {
        Observable.combineLatest(
            redSlider.rx.value,
            greenSlider.rx.value,
            blueSlider.rx.value
        )
        .subscribe(onNext: { [weak self] red, green, blue in
            self?.redValueLabel.text = "\(Int(red))"
            self?.greenValueLabel.text = "\(Int(green))"
            self?.blueValueLabel.text = "\(Int(blue))"
            
            self?.delegate?.rgbControlDidChange(
                red: CGFloat(red/255),
                green: CGFloat(green/255),
                blue: CGFloat(blue/255)
            )
        })
        .disposed(by: disposeBag)
    }
    
    // MARK: - Public Methods
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
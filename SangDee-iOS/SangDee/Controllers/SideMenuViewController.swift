import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol SideMenuDelegate: AnyObject {
    func sideMenu(_ menu: SideMenuViewController, didUpdateColor color: UIColor)
    func sideMenu(_ menu: SideMenuViewController, didUpdateBrightness brightness: Float)
}

class SideMenuViewController: UIViewController {
    
    // MARK: - UI Components
    private let colorWheel = ColorWheelView()
    private let rgbControls = RGBControlView()
    private let brightnessSlider = UISlider()
    private let headerLabel = UILabel()
    private let thaiHeaderLabel = UILabel()
    
    // MARK: - Properties
    weak var delegate: SideMenuDelegate?
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupBindings()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        headerLabel.text = "Settings"
        headerLabel.font = .systemFont(ofSize: 24, weight: .bold)
        
        thaiHeaderLabel.text = "ตั้งค่า"
        thaiHeaderLabel.font = .systemFont(ofSize: 18)
        thaiHeaderLabel.textColor = .secondaryLabel
        
        brightnessSlider.minimumValue = 0
        brightnessSlider.maximumValue = 100
        brightnessSlider.value = 50
        
        colorWheel.delegate = self
        rgbControls.delegate = self
    }
    
    private func setupConstraints() {
        [headerLabel, thaiHeaderLabel, colorWheel, brightnessSlider, rgbControls].forEach {
            view.addSubview($0)
        }
        
        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
        }
        
        thaiHeaderLabel.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        
        colorWheel.snp.makeConstraints { make in
            make.top.equalTo(thaiHeaderLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.size.equalTo(200)
        }
        
        brightnessSlider.snp.makeConstraints { make in
            make.top.equalTo(colorWheel.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(20)
        }
        
        rgbControls.snp.makeConstraints { make in
            make.top.equalTo(brightnessSlider.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(150)
        }
    }
    
    private func setupBindings() {
        brightnessSlider.rx.value
            .bind { [weak self] value in
                self?.delegate?.sideMenu(self!, didUpdateBrightness: value)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - ColorWheel Delegate
extension SideMenuViewController: ColorWheelDelegate {
    func colorWheelDidSelect(color: UIColor) {
        rgbControls.setColor(color)
        delegate?.sideMenu(self, didUpdateColor: color)
    }
}

// MARK: - RGB Controls Delegate
extension SideMenuViewController: RGBControlDelegate {
    func rgbControlDidChange(red: CGFloat, green: CGFloat, blue: CGFloat) {
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        delegate?.sideMenu(self, didUpdateColor: color)
    }
} 
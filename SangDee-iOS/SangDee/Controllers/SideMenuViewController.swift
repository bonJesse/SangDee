import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol SideMenuDelegate: AnyObject {
    func sideMenu(_ menu: SideMenuViewController, didUpdateColor color: UIColor)
    func sideMenu(_ menu: SideMenuViewController, didUpdateContrast contrast: Float)
}

class SideMenuViewController: UIViewController {
    
    weak var delegate: SideMenuDelegate?
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    private let colorWheel = ColorWheelView()
    private let rgbControls = RGBControlView()
    private let contrastSlider = UISlider()
    private let headerLabel = UILabel()
    private let thaiHeaderLabel = UILabel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupBindings()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .white
        
        // Header setup
        headerLabel.text = "Settings"
        headerLabel.font = .systemFont(ofSize: 24, weight: .bold)
        
        thaiHeaderLabel.text = "ตั้งค่า"
        thaiHeaderLabel.font = .systemFont(ofSize: 18)
        thaiHeaderLabel.textColor = .gray
        
        // Contrast slider setup
        contrastSlider.minimumValue = 0
        contrastSlider.maximumValue = 200
        contrastSlider.value = 100
        
        // Color wheel setup
        colorWheel.delegate = self
        
        // RGB controls setup
        rgbControls.delegate = self
    }
    
    private func setupConstraints() {
        [headerLabel, thaiHeaderLabel, colorWheel, contrastSlider, rgbControls].forEach {
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
        
        contrastSlider.snp.makeConstraints { make in
            make.top.equalTo(colorWheel.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(20)
        }
        
        rgbControls.snp.makeConstraints { make in
            make.top.equalTo(contrastSlider.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(150)
        }
    }
    
    private func setupBindings() {
        contrastSlider.rx.value
            .subscribe(onNext: { [weak self] value in
                self?.delegate?.sideMenu(self!, didUpdateContrast: value)
            })
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
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SangDeeController: UIViewController {
    
    // MARK: - UI Components
    private let previewArea = UIView()
    private lazy var colorCardsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.register(ColorCardCell.self, forCellWithReuseIdentifier: ColorCardCell.identifier)
        return cv
    }()
    
    private let quickBrightnessSlider = UISlider()
    private let brightnessLabel = UILabel()
    private let thaiBrightnessLabel = UILabel()
    private let brightnessValueLabel = UILabel()
    private let cameraButton = UIButton()
    private let fullscreenButton = UIButton()
    
    // MARK: - Properties
    private let presetManager = PresetManager()
    private let lightController = LightController()
    private let disposeBag = DisposeBag()
    private let sideMenuViewController = SideMenuViewController()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupBindings()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = UIColor(named: "Background")
        
        // Navigation setup
        title = "SangDee"
        navigationController?.navigationBar.prefersLargeTitles = true
        let menuButton = UIBarButtonItem(image: UIImage(named: "menu"),
                                       style: .plain,
                                       target: self,
                                       action: #selector(showSideMenu))
        navigationItem.leftBarButtonItem = menuButton
        
        // Preview area setup
        previewArea.backgroundColor = .white
        previewArea.layer.cornerRadius = 20
        
        // Camera button setup
        cameraButton.setImage(UIImage(named: "camera"), for: .normal)
        cameraButton.backgroundColor = .white
        cameraButton.layer.cornerRadius = 20
        
        // Brightness controls setup
        brightnessLabel.text = "Brightness"
        brightnessLabel.font = .systemFont(ofSize: 16, weight: .medium)
        
        thaiBrightnessLabel.text = "ความสว่าง"
        thaiBrightnessLabel.font = .systemFont(ofSize: 14)
        thaiBrightnessLabel.textColor = .gray
        
        quickBrightnessSlider.minimumValue = 0
        quickBrightnessSlider.maximumValue = 100
        quickBrightnessSlider.value = 50
        
        brightnessValueLabel.text = "50%"
        brightnessValueLabel.font = .systemFont(ofSize: 12)
        brightnessValueLabel.textColor = .gray
        
        // Collection view setup
        colorCardsCollectionView.delegate = self
        colorCardsCollectionView.dataSource = self
        
        // Side menu setup
        sideMenuViewController.delegate = self
    }
    
    private func setupConstraints() {
        [previewArea, colorCardsCollectionView, brightnessLabel, thaiBrightnessLabel,
         quickBrightnessSlider, brightnessValueLabel, cameraButton].forEach {
            view.addSubview($0)
        }
        
        previewArea.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(0.5)
        }
        
        cameraButton.snp.makeConstraints { make in
            make.top.right.equalTo(previewArea).inset(20)
            make.size.equalTo(40)
        }
        
        colorCardsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(previewArea.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(80)
        }
        
        brightnessLabel.snp.makeConstraints { make in
            make.top.equalTo(colorCardsCollectionView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(16)
        }
        
        thaiBrightnessLabel.snp.makeConstraints { make in
            make.top.equalTo(brightnessLabel.snp.bottom).offset(4)
            make.left.equalTo(brightnessLabel)
        }
        
        quickBrightnessSlider.snp.makeConstraints { make in
            make.top.equalTo(thaiBrightnessLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(16)
        }
        
        brightnessValueLabel.snp.makeConstraints { make in
            make.top.equalTo(quickBrightnessSlider.snp.bottom).offset(4)
            make.right.equalTo(quickBrightnessSlider)
        }
    }
    
    private func setupBindings() {
        quickBrightnessSlider.rx.value
            .subscribe(onNext: { [weak self] value in
                self?.brightnessValueLabel.text = "\(Int(value))%"
                self?.lightController.setBrightness(CGFloat(value/100))
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Actions
    @objc private func showSideMenu() {
        let nav = UINavigationController(rootViewController: sideMenuViewController)
        nav.modalPresentationStyle = .formSheet
        present(nav, animated: true)
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension SangDeeController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presetManager.presets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCardCell.identifier, for: indexPath) as! ColorCardCell
        let preset = presetManager.presets[indexPath.item]
        cell.configure(with: preset)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let preset = presetManager.presets[indexPath.item]
        previewArea.backgroundColor = preset.color
        lightController.setColor(preset.color)
    }
}

// MARK: - SideMenu Delegate
extension SangDeeController: SideMenuDelegate {
    func sideMenu(_ menu: SideMenuViewController, didUpdateColor color: UIColor) {
        previewArea.backgroundColor = color
        lightController.setColor(color)
    }
    
    func sideMenu(_ menu: SideMenuViewController, didUpdateContrast contrast: Float) {
        lightController.setContrast(CGFloat(contrast/100))
    }
} 
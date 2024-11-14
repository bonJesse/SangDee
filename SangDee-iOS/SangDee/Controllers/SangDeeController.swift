import UIKit
import SnapKit
import RxSwift
import RxCocoa
import AVFoundation

class SangDeeController: UIViewController {
    
    // MARK: - UI Components
    private lazy var previewArea: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        return view
    }()
    
    private lazy var colorCardsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.minimumInteritemSpacing = 10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.register(ColorCardCell.self, forCellWithReuseIdentifier: ColorCardCell.identifier)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    private lazy var quickBrightnessSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.value = 50
        return slider
    }()
    
    private lazy var menuButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "line.horizontal.3")
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
        return button
    }()
    
    private lazy var cameraButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "camera")
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(toggleCamera), for: .touchUpInside)
        return button
    }()
    
    private lazy var fullscreenButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "arrow.up.left.and.arrow.down.right")
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(toggleFullscreen), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    private let presetManager = PresetManager()
    private let lightController = LightController()
    private let sideMenuVC = SideMenuViewController()
    private let disposeBag = DisposeBag()
    
    // MARK: - Camera Properties
    private var captureSession: AVCaptureSession?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private var isCameraActive = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupNavigationBar()
        setupBindings()
        
        quickBrightnessSlider.value = 100
        updatePreviewAreaBrightness(1.0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        videoPreviewLayer?.frame = previewArea.bounds
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopCamera()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        [previewArea, colorCardsCollectionView, quickBrightnessSlider, 
         cameraButton, fullscreenButton].forEach {
            view.addSubview($0)
        }
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        previewArea.addGestureRecognizer(doubleTapGesture)
        
        sideMenuVC.delegate = self
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
        title = "SangDee 1.0.3"
        
        if #available(iOS 16.0, *) {
            navigationItem.backButtonDisplayMode = .minimal
        }
    }
    
    private func setupConstraints() {
        previewArea.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(0.4)
        }
        
        colorCardsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(previewArea.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(80)
        }
        
        quickBrightnessSlider.snp.makeConstraints { make in
            make.top.equalTo(colorCardsCollectionView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
        }
        
        cameraButton.snp.makeConstraints { make in
            make.top.right.equalTo(previewArea).inset(16)
            make.size.equalTo(44)
        }
        
        fullscreenButton.snp.makeConstraints { make in
            make.top.left.equalTo(previewArea).inset(16)
            make.size.equalTo(44)
        }
    }
    
    private func setupBindings() {
        quickBrightnessSlider.rx.value
            .distinctUntilChanged()
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .map { CGFloat($0 / 100.0) }
            .bind { [weak self] value in
                self?.lightController.setBrightness(value)
                self?.updatePreviewAreaBrightness(value)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Actions
    @objc private func showMenu() {
        let nav = UINavigationController(rootViewController: sideMenuVC)
        nav.modalPresentationStyle = .formSheet
        
        if #available(iOS 18.0, *) {
            nav.sheetPresentationController?.prefersEdgeAttachedInCompactHeight = true
            nav.sheetPresentationController?.widthFollowsPreferredContentSizeWhenEdgeAttached = true
            nav.sheetPresentationController?.detents = [.medium(), .large()]
        }
        
        present(nav, animated: true)
    }
    
    @objc private func toggleCamera() {
        if isCameraActive {
            stopCamera()
        } else {
            startCamera()
        }
    }
    
    @objc private func toggleFullscreen() {
        // Fullscreen functionality will be implemented here
    }
    
    // MARK: - Camera Methods
    private func setupCamera() {
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            print("Failed to get front camera device")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = .resizeAspectFill
            videoPreviewLayer?.frame = previewArea.bounds
            
            if let previewLayer = videoPreviewLayer {
                previewArea.layer.addSublayer(previewLayer)
            }
        } catch {
            print("Error setting up camera: \(error.localizedDescription)")
        }
    }
    
    private func startCamera() {
        if captureSession == nil {
            setupCamera()
        }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession?.startRunning()
            
            DispatchQueue.main.async {
                self?.isCameraActive = true
                self?.cameraButton.tintColor = .systemBlue
                UIView.animate(withDuration: 0.3) {
                    self?.videoPreviewLayer?.opacity = 1.0
                }
            }
        }
    }
    
    private func stopCamera() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession?.stopRunning()
            
            DispatchQueue.main.async {
                self?.isCameraActive = false
                self?.cameraButton.tintColor = .label
                UIView.animate(withDuration: 0.3) {
                    self?.videoPreviewLayer?.opacity = 0.0
                }
            }
        }
    }
    
    private func updatePreviewAreaBrightness(_ value: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.previewArea.alpha = value
        }
    }
    
    // MARK: - Double Tap Gesture
    private var isControlsHidden = false
    
    @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        isControlsHidden.toggle()
        
        UIView.animate(withDuration: 0.3) {
            self.colorCardsCollectionView.alpha = self.isControlsHidden ? 0 : 1
            self.quickBrightnessSlider.alpha = self.isControlsHidden ? 0 : 1
            
            self.colorCardsCollectionView.snp.updateConstraints { make in
                make.top.equalTo(self.previewArea.snp.bottom).offset(self.isControlsHidden ? -100 : 20)
            }
            
            self.view.layoutIfNeeded()
        }
    }
    
    private func showControls() {
        guard isControlsHidden else { return }
        isControlsHidden = false
        
        UIView.animate(withDuration: 0.3) {
            self.colorCardsCollectionView.alpha = 1
            self.quickBrightnessSlider.alpha = 1
            
            self.colorCardsCollectionView.snp.updateConstraints { make in
                make.top.equalTo(self.previewArea.snp.bottom).offset(20)
            }
            
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension SangDeeController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presetManager.presets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCardCell.identifier, for: indexPath) as! ColorCardCell
        cell.configure(with: presetManager.presets[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let preset = presetManager.presets[indexPath.item]
        lightController.applyPreset(preset)
        previewArea.backgroundColor = preset.color
    }
}

// MARK: - SideMenu Delegate
extension SangDeeController: SideMenuDelegate {
    func sideMenu(_ menu: SideMenuViewController, didUpdateColor color: UIColor) {
        previewArea.backgroundColor = color
        lightController.setColor(color)
    }
    
    func sideMenu(_ menu: SideMenuViewController, didUpdateBrightness brightness: Float) {
        quickBrightnessSlider.value = brightness
        lightController.setBrightness(CGFloat(brightness / 100.0))
    }
} 
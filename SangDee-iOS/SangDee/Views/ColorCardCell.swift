import UIKit
import SnapKit

class ColorCardCell: UICollectionViewCell {
    static let identifier = "ColorCardCell"
    
    // MARK: - UI Components
    private let colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.clear.cgColor
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    private let thaiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        contentView.backgroundColor = .clear
        
        let stackView = UIStackView(arrangedSubviews: [nameLabel, thaiLabel])
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .center
        
        [colorView, stackView].forEach { contentView.addSubview($0) }
        
        colorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(4)
            make.bottom.equalToSuperview().inset(8)
        }
    }
    
    // MARK: - Configuration
    func configure(with preset: ColorPreset) {
        colorView.backgroundColor = preset.color
        nameLabel.text = preset.name
        thaiLabel.text = preset.thaiName
    }
    
    override var isSelected: Bool {
        didSet {
            colorView.layer.borderColor = isSelected ? UIColor.systemBlue.cgColor : UIColor.clear.cgColor
            if isSelected {
                UIView.animate(withDuration: 0.2) {
                    self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                }
            } else {
                UIView.animate(withDuration: 0.2) {
                    self.transform = .identity
                }
            }
        }
    }
} 
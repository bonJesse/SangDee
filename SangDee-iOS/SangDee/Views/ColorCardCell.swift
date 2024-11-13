import UIKit
import SnapKit

class ColorCardCell: UICollectionViewCell {
    static let identifier = "ColorCardCell"
    
    private let colorView = UIView()
    private let nameLabel = UILabel()
    private let thaiLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // Color View
        colorView.layer.cornerRadius = 12
        colorView.clipsToBounds = true
        contentView.addSubview(colorView)
        
        // Labels Stack
        let stackView = UIStackView(arrangedSubviews: [nameLabel, thaiLabel])
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .center
        contentView.addSubview(stackView)
        
        // Configure Labels
        nameLabel.font = .systemFont(ofSize: 12)
        thaiLabel.font = .systemFont(ofSize: 10)
        thaiLabel.textColor = .gray
        
        // Layout
        colorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(4)
            make.bottom.equalToSuperview().inset(8)
        }
    }
    
    func configure(with preset: ColorPreset) {
        colorView.backgroundColor = preset.color
        nameLabel.text = preset.name
        thaiLabel.text = preset.thaiName
    }
} 
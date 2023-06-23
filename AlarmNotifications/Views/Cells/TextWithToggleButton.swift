import UIKit

class TextWithToggleButton: UITableViewCell {
    
    private let label = UILabel()
    private let toggleButton = UISwitch()
    
    var toggleButtonState: Bool {
        get {
            return toggleButton.isOn
        }
        set {
            toggleButton.isOn = newValue
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(label)
        contentView.addSubview(toggleButton)
        label.translatesAutoresizingMaskIntoConstraints = false
        toggleButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 5/7),
            
            toggleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            toggleButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with text: String, toggleButtonState: Bool) {
        label.text = text
        self.toggleButtonState = toggleButtonState
    }
    
    func getToggleButtonState() -> Bool {
        return toggleButton.isOn
    }
}

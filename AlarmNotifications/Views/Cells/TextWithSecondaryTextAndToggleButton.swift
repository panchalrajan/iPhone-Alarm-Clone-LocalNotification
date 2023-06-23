import UIKit

protocol TextWithSecondaryTextAndToggleButtonDelegate: AnyObject {
    func toggleButtonStateChanged(newState: Bool, indexPath: IndexPath)
}


class TextWithSecondaryTextAndToggleButton: UITableViewCell {
    
    weak var delegate: TextWithSecondaryTextAndToggleButtonDelegate?
    
    let time: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let secLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let toggleButton: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()
    
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
        
        contentView.addSubview(time)
        contentView.addSubview(secLabel)
        contentView.addSubview(toggleButton)
        
        NSLayoutConstraint.activate([
            time.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            time.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            secLabel.topAnchor.constraint(equalTo: time.bottomAnchor, constant: 4),
            secLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            secLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            toggleButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            toggleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
        
        toggleButton.addTarget(self, action: #selector(toggleButtonStateChanged), for: .valueChanged)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(alarm : Alarm) {
        time.text = alarm.getTime().formatted(date: .omitted, time: .shortened)
        toggleButton.isOn = true
        
        let timeLabel = alarm.getLabel()
        var selectedDaysAbbreviated = ""
        let selectedDaysSet = Set(alarm.getRepeatation())
        if selectedDaysSet.isEmpty {
            selectedDaysAbbreviated = "Never"
        } else if selectedDaysSet == Set([.Sun, .Mon, .Tue, .Wed, .Thu, .Fri, .Sat]) {
            selectedDaysAbbreviated = "Everyday"
        } else if selectedDaysSet == Set([.Mon, .Tue, .Wed, .Thu, .Fri]) {
            selectedDaysAbbreviated = "Weekdays"
        } else if selectedDaysSet == Set([.Sat, .Sun]) {
            selectedDaysAbbreviated = "Weekend"
        } else {
            selectedDaysAbbreviated = alarm.getRepeatation().map { $0.abbreviatedName }.joined(separator: ", ")
        }
        
        secLabel.text = "\(timeLabel), (\(selectedDaysAbbreviated))"
    }
    
    func getToggleButtonState() -> Bool {
        return toggleButton.isOn
    }
    
    func setToggleButtonState(_ newState: Bool) {
        toggleButton.isOn = newState
    }
    
    @objc func toggleButtonStateChanged() {
        guard let tableView = superview as? UITableView,
              let indexPath = tableView.indexPath(for: self) else {
            return
        }
        delegate?.toggleButtonStateChanged(newState: toggleButton.isOn, indexPath: indexPath)
    }
}

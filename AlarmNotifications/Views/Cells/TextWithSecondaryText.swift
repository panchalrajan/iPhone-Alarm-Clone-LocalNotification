import UIKit

class TextWithSecondaryText: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        var content = defaultContentConfiguration()
        content.text = "Primary Text"
        content.secondaryText = "Never"
        self.contentConfiguration = content
        accessoryType = .disclosureIndicator
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(Text: String, secText: String) {
        var content = defaultContentConfiguration()
        content.text = Text
        content.secondaryText = secText
        self.contentConfiguration = content
    }
}


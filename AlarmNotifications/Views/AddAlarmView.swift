import UIKit

class AddAlarmView: UIView {
    
    let datePicker : UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    let tableView : UITableView = {
        let myTableView = UITableView(frame: CGRectZero, style: .insetGrouped)
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        return myTableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(datePicker)
        self.addSubview(tableView)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyConstraints() {
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: self.topAnchor),
            datePicker.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            datePicker.heightAnchor.constraint(equalToConstant: 216),
            
            tableView.topAnchor.constraint(equalTo: datePicker.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

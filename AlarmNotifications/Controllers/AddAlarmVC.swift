import UIKit
import UserNotifications

protocol AddAlarmVCDelegate: AnyObject {
    func addAlarm(_ alarm: Alarm)
}

class AddAlarmVC: UIViewController, UITableViewDelegate, UITableViewDataSource, AllDaysVCDelegate {
    
    weak var delegate: AddAlarmVCDelegate?
    var days : [Days] = []
    private var addAlarmView = AddAlarmView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        applyConstraints();
    }
    
    func setView() {
        self.title = "Add Alarm"
        view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.prefersLargeTitles = false
        let saveAlarmButton = UIBarButtonItem(title: "Save",
                                              style: .plain,
                                              target: self,
                                              action: #selector(saveAlarmButtonTapped))
        self.navigationItem.rightBarButtonItem = saveAlarmButton;
        
        self.view.addSubview(addAlarmView)
        addAlarmView.tableView.delegate = self
        addAlarmView.tableView.dataSource = self
        addAlarmView.tableView.register(TextFieldWithLabel.self, forCellReuseIdentifier: "TextFieldWithLabel")
        addAlarmView.tableView.register(TextWithToggleButton.self, forCellReuseIdentifier: "TextWithToggleButton")
        addAlarmView.tableView.register(TextWithSecondaryText.self, forCellReuseIdentifier: "TextWithSecondaryText")
        
    }
 
    func applyConstraints() {
        addAlarmView.translatesAutoresizingMaskIntoConstraints = false;
        NSLayoutConstraint.activate([
            addAlarmView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            addAlarmView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addAlarmView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            addAlarmView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func saveAlarmButtonTapped() {
        NotificationManager.shared.checkForNotificationPermission { isAuthorized in
            if isAuthorized {
                DispatchQueue.main.async {
                    self.setAlarm()
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                print("Not Ok")
            }
        }
    }
    
    func setAlarm() {
        guard let labelCell = addAlarmView.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TextFieldWithLabel,
              let snoozeCell = addAlarmView.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? TextWithToggleButton
        else { return }
        
        let time = self.addAlarmView.datePicker.date
        let label = labelCell.textField.text ?? ""
        let isSnoozeEnable = snoozeCell.getToggleButtonState()
        
        let alarm = Alarm(time: time, label: label, isSnoozedEnable: isSnoozeEnable, repeatation: days)
        NotificationManager.shared.scheduleLocalNotification(for: alarm)
        delegate?.addAlarm(alarm)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = addAlarmView.tableView.dequeueReusableCell(withIdentifier: "TextFieldWithLabel", for: indexPath) as! TextFieldWithLabel
            cell.configure(labelText: "Label")
            return cell
        case 1:
            let cell = addAlarmView.tableView.dequeueReusableCell(withIdentifier: "TextWithSecondaryText", for: indexPath) as! TextWithSecondaryText
            cell.configure(Text: "Repeat", secText: "Never")
            return cell
        case 2:
            let cell = addAlarmView.tableView.dequeueReusableCell(withIdentifier: "TextWithToggleButton", for: indexPath) as! TextWithToggleButton
            cell.configure(with: "Snooze", toggleButtonState: true)
            return cell
        default :
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            let allDaysVC = AllDaysVC()
            allDaysVC.delegate = self
            navigationController?.pushViewController(allDaysVC, animated: true)
        default:
            break
        }
    }

    func didSelectDays(_ selectedDays: [Days]) {
        guard let repeatationCell = addAlarmView.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? TextWithSecondaryText else { return }
        days = selectedDays
        let selectedDaysSet = Set(selectedDays)
        if selectedDaysSet.isEmpty {
            repeatationCell.configure(Text: "Repeat", secText: "Never")
        } else if selectedDaysSet == Set([.Sun, .Mon, .Tue, .Wed, .Thu, .Fri, .Sat]) {
            repeatationCell.configure(Text: "Repeat", secText: "Everyday")
        } else if selectedDaysSet == Set([.Mon, .Tue, .Wed, .Thu, .Fri]) {
            repeatationCell.configure(Text: "Repeat", secText: "Weekdays")
        } else if selectedDaysSet == Set([.Sat, .Sun]) {
            repeatationCell.configure(Text: "Repeat", secText: "Weekend")
        } else {
            let selectedDaysAbbreviated = selectedDays.map { $0.abbreviatedName }.joined(separator: ", ")
            repeatationCell.configure(Text: "Repeat", secText: selectedDaysAbbreviated)
        }
    }

}

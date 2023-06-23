import UIKit
import UserNotifications

class AllAlarmsVC: UIViewController {
    
    private var allAlarmsView = AllAlarmsView()
    private var allAlarmsArray: [Alarm] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        applyConstraints();
        NotificationManager.shared.requestForNotificationPermission()
        UNUserNotificationCenter.current().delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setView() {
        self.title = "Alarms"
        view.backgroundColor = .systemBackground
        
        let addAlarmButton = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(addAlarmButtonTapped))
        self.navigationItem.rightBarButtonItem = addAlarmButton;
        
        let showPendingNotificationButton = UIBarButtonItem(image: UIImage(systemName: "clock"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(showPendingNotificationButtonTapped))
        
        let deleteAllPendingNotificationButton = UIBarButtonItem(image: UIImage(systemName: "xmark.bin"),
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(deleteAllPendingNotificationButtonTapped))
        self.navigationItem.leftBarButtonItems = [showPendingNotificationButton,deleteAllPendingNotificationButton] ;
        
        allAlarmsView.tableView.delegate = self
        allAlarmsView.tableView.dataSource = self
        allAlarmsView.tableView.register(TextWithSecondaryTextAndToggleButton.self, forCellReuseIdentifier: "TextWithSecondaryTextAndToggleButton")

        self.view.addSubview(allAlarmsView)
    }
    
    func applyConstraints() {
        allAlarmsView.translatesAutoresizingMaskIntoConstraints = false;
        NSLayoutConstraint.activate([
            allAlarmsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            allAlarmsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            allAlarmsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            allAlarmsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func addAlarmButtonTapped() {
        let addAlarmVC = AddAlarmVC()
        addAlarmVC.delegate = self
        navigationController?.pushViewController(addAlarmVC, animated: true)
    }
    
    @objc func showPendingNotificationButtonTapped() {
        NotificationManager.shared.printAllPendingNotifications()
    }
    
    @objc func deleteAllPendingNotificationButtonTapped() {
        NotificationManager.shared.deleteAllPendingNotifications()
    }
  
    func disableFutureAlarm(index : Int) {
        guard let requiredCell = allAlarmsView.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? TextWithSecondaryTextAndToggleButton
        else { return }
        requiredCell.setToggleButtonState(false)
    }
}

extension AllAlarmsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = allAlarmsView.tableView.dequeueReusableCell(withIdentifier: "TextWithSecondaryTextAndToggleButton", for: indexPath) as! TextWithSecondaryTextAndToggleButton
        let alarm = allAlarmsArray[indexPath.row]
        cell.delegate = self
        cell.configure(alarm : alarm)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [self] action, sourceView, completionHandler in
            NotificationManager.shared.removeLocalNotification(for: allAlarmsArray[indexPath.row])
            allAlarmsArray.remove(at: indexPath.row)
            allAlarmsView.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe=false;
        return config
    }
}

extension AllAlarmsVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allAlarmsArray.count
    }
    
}

extension AllAlarmsVC: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let identifier = response.notification.request.identifier
        if let index = allAlarmsArray.firstIndex(where: { identifier.hasPrefix($0.getID()) }) {
            let alarm = allAlarmsArray[index]
            if alarm.getIsSnoozedEnable() {
                NotificationManager.shared.scheduleSnoozedAlarm(for: alarm)
            } else if alarm.getRepeatation().isEmpty {
                disableFutureAlarm(index: index)
                alarm.setIsEnabled(false)
            }
        }
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .banner, .sound])
    }
}

extension AllAlarmsVC: AddAlarmVCDelegate {
    func addAlarm(_ alarm: Alarm) {
        allAlarmsArray.append(alarm)
        allAlarmsView.tableView.reloadData()
    }
}

extension AllAlarmsVC: TextWithSecondaryTextAndToggleButtonDelegate {
    
    func toggleButtonStateChanged(newState: Bool, indexPath: IndexPath) {
        let alarm = allAlarmsArray[indexPath.row]
        if (!newState) {
            NotificationManager.shared.removeLocalNotification(for: alarm)
        } else {
            NotificationManager.shared.scheduleLocalNotification(for: alarm)
        }
    }
}

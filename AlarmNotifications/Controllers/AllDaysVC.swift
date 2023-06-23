import UIKit

protocol AllDaysVCDelegate: AnyObject {
    func didSelectDays(_ selectedDays: [Days])
}

class AllDaysVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: AllDaysVCDelegate?

    private var allDaysView = AllDaysView()
    var selectedDays : [Days] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        applyConstraints();
    }
    
    func setView() {
        self.title = "Select Days"
        view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.prefersLargeTitles = false
        let doneButton = UIBarButtonItem(title: "Done",
                                              style: .plain,
                                              target: self,
                                              action: #selector(doneButtonTapped))
        self.navigationItem.rightBarButtonItem = doneButton;
        
        self.view.addSubview(allDaysView)
        allDaysView.tableView.delegate = self
        allDaysView.tableView.dataSource = self
        allDaysView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DaysCellIdentifier")

    }
 
    func applyConstraints() {
        allDaysView.translatesAutoresizingMaskIntoConstraints = false;
        NSLayoutConstraint.activate([
            allDaysView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            allDaysView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            allDaysView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            allDaysView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func doneButtonTapped() {
        delegate?.didSelectDays(selectedDays)
        navigationController?.popViewController(animated: true)
    }

    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Days.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  allDaysView.tableView.dequeueReusableCell(withIdentifier: "DaysCellIdentifier", for: indexPath)
        let day = Days.allCases[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = day.rawValue
        cell.contentConfiguration = content
        cell.accessoryType = selectedDays.contains(day) ? .checkmark : .none

        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let day = Days.allCases[indexPath.row]
        if let index = selectedDays.firstIndex(of: day) {
            selectedDays.remove(at: index)
        } else {
            selectedDays.append(day)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
}

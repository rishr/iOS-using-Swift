import UIKit

class ScheduleTableViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    @IBOutlet weak private var addBarButtonItem: UIBarButtonItem! {
        didSet {
            addBarButtonItem.isEnabled = ModelManager.shared.train != nil
        }
    }
    
    var searchText: String? {
        didSet {
            if let text: String = searchText, text.isEmpty == false {
                presentSchedules = schedules.filter { $0.id?.lowercased().contains(text.lowercased()) ?? false }
            } else {
                presentSchedules = schedules
            }
        }
    }
    
    var schedules: [Schedule] = (ModelManager.shared.train?.schedules?.allObjects as? [Schedule]) ?? ModelManager.shared.schedules {
        didSet {
            if let text: String = searchText, text.isEmpty == false {
                presentSchedules = schedules.filter { $0.id?.lowercased().contains(text.lowercased()) ?? false }
            } else {
                presentSchedules = schedules
            }
        }
    }
    var presentSchedules: [Schedule] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // to hide keyboard with swip table view
        tableView.keyboardDismissMode = .interactive
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        schedules = (ModelManager.shared.train?.schedules?.allObjects as? [Schedule]) ?? ModelManager.shared.schedules
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presentSchedules.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ScheduleTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell", for: indexPath) as! ScheduleTableViewCell
        cell.set(schedule: presentSchedules[indexPath.row])
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller: ScheduleViewController = segue.destination as? ScheduleViewController {
            if let index: Int = tableView.indexPathForSelectedRow?.row {
                controller.schedule = schedules[index]
            }
        }
    }
}

extension ScheduleTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
    }
}

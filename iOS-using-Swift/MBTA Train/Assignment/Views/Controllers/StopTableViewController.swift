import UIKit

class StopTableViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    @IBOutlet weak private var addBarButtonItem: UIBarButtonItem! {
        didSet {
            addBarButtonItem.isEnabled = ModelManager.shared.schedule != nil
        }
    }
    
    var stops: [Stop] = (ModelManager.shared.schedule?.stops?.allObjects as? [Stop]) ?? ModelManager.shared.stops {
        didSet {
            if let text: String = searchBar.text, text.isEmpty == false {
                presentStops = stops.filter { $0.name?.lowercased().contains(text.lowercased()) ?? false }
            } else {
                presentStops = stops
            }
        }
    }
    var presentStops: [Stop] = [] {
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
        stops = (ModelManager.shared.schedule?.stops?.allObjects as? [Stop]) ?? ModelManager.shared.stops
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presentStops.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StopTableViewCell = tableView.dequeueReusableCell(withIdentifier: "StopCell", for: indexPath) as! StopTableViewCell
        cell.set(stop: presentStops[indexPath.row])
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller: StopViewController = segue.destination as? StopViewController {
            if let index: Int = tableView.indexPathForSelectedRow?.row {
                controller.stop = stops[index]
            }
        }
    }
}

extension StopTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty == false {
            presentStops = stops.filter { $0.name?.lowercased().contains(searchText.lowercased()) ?? false }
        } else {
            presentStops = stops
        }
    }
}

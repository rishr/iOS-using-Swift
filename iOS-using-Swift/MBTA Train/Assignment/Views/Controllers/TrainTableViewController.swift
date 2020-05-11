import UIKit

class TrainTableViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    var trains: [Train] = ModelManager.shared.trains {
        didSet {
            if let text: String = searchBar.text, text.isEmpty == false {
                presentTrains = trains.filter { $0.name?.lowercased().contains(text.lowercased()) ?? false }
            } else {
                presentTrains = trains
            }
        }
    }
    var presentTrains: [Train] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trains = ModelManager.shared.trains
    }
    
    private func setUpView() {
        // to hide keyboard with swip table view
        tableView.keyboardDismissMode = .interactive
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presentTrains.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TrainTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TrainCell", for: indexPath) as! TrainTableViewCell
        cell.set(train: presentTrains[indexPath.row])
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var train: Train?
        if let index: Int = tableView.indexPathForSelectedRow?.row {
            train = trains[index]
        }
        if let controller: TrainViewController = segue.destination as? TrainViewController {
            controller.train = train
        }
    }
}

extension TrainTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty == false {
            presentTrains = trains.filter { $0.name?.lowercased().contains(searchText.lowercased()) ?? false }
        } else {
            presentTrains = trains
        }
    }
}

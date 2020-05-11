

import UIKit

class TrainTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    func set(train: Train) {
        nameLabel.text = train.name
        idLabel.text = train.id
    }
}

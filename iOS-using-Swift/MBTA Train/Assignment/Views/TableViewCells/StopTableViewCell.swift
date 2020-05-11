

import UIKit

class StopTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    func set(stop: Stop) {
        nameLabel.text = stop.name
        addressLabel.text = stop.address
        locationLabel.text = "\(stop.latitude),\(stop.longitude)"
    }
}

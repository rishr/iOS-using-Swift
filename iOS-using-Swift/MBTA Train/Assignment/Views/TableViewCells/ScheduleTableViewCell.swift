

import UIKit

class ScheduleTableViewCell: UITableViewCell {
    @IBOutlet weak var idLabel: UILabel!
    
    func set(schedule: Schedule) {
        idLabel.text = schedule.id
    }
}

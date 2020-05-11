import UIKit

class ScheduleViewController: UIViewController {
    @IBOutlet weak var idTitleLabel: UILabel! {
        didSet {
            idTitleLabel.isHidden = schedule == nil
        }
    }
    @IBOutlet weak var idLabel: UILabel! {
        didSet {
            idLabel.text = schedule?.id
            idLabel.isHidden = schedule == nil
        }
    }
    @IBOutlet weak var arrivalTextField: UITextField! {
        didSet {
            arrivalTextField.inputView = datePicker
            arrivalTextField.inputAccessoryView = toolbar
            arrivalTextField.text = schedule?.arrival?.display
        }
    }
    @IBOutlet weak var departureTextField: UITextField! {
        didSet {
            departureTextField.inputView = datePicker
            departureTextField.inputAccessoryView = toolbar
            departureTextField.text = schedule?.departure?.display
        }
    }
    @IBOutlet weak var deleteButton: UIButton! {
        didSet {
            deleteButton.isHidden = schedule == nil
        }
    }
    @IBOutlet weak var stopsButton: UIButton! {
        didSet {
            stopsButton.isHidden = schedule == nil
        }
    }
    
    lazy var datePicker: UIDatePicker = {
        let picker: UIDatePicker = UIDatePicker()
        picker.datePickerMode = .time
        picker.date = Date()
        picker.addTarget(self, action: #selector(Self.dateChanged), for: .valueChanged)
        return picker
    }()
    lazy var toolbar: UIToolbar = {
        let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44))
        toolbar.items = [UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil),
                         UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(Self.clickDone))]
        return toolbar
    }()
    
    var schedule: Schedule? {
        didSet {
            ModelManager.shared.schedule = schedule
        }
    }
    var arrivalDate: Date? {
        didSet {
            arrivalTextField.text = arrivalDate?.display
        }
    }
    var departureDate: Date? {
        didSet {
            departureTextField.text = departureDate?.display
        }
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        if arrivalTextField.isEditing {
            arrivalDate = sender.date
        }
        if departureTextField.isEditing {
            departureDate = sender.date
        }
    }
    
    @objc func clickDone(_ sender: UIBarButtonItem) {
        arrivalTextField.resignFirstResponder()
        departureTextField.resignFirstResponder()
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        guard let arrival: Date = arrivalDate else {
            alert(text: "Arrival time should not be empty.")
            return
        }
        guard let departure: Date = departureDate else {
            alert(text: "Departure Time should not be empty.")
            return
        }
        if let id: String = schedule?.id {
            ModelManager.shared.updateSchedule(id: id, arrival: arrival, departure: departure)
        } else {
            ModelManager.shared.addSchedule(id: UUID().uuidString, arrival: arrival, departure: departure)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickDelete(_ sender: UIButton) {
        guard let id: String = schedule?.id else { return }
        ModelManager.shared.deleteSchedule(id: id)
        navigationController?.popViewController(animated: true)
    }
    
    func alert(text: String) {
        let alertController: UIAlertController = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

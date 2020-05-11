import UIKit

class StopViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField! {
        didSet {
            nameTextField.text = stop?.name
        }
    }
    @IBOutlet weak var latitudeTextField: UITextField! {
        didSet {
            latitudeTextField.text = stop?.latitude.description
        }
    }
    @IBOutlet weak var longitudeTextField: UITextField! {
        didSet {
            longitudeTextField.text = stop?.longitude.description
        }
    }
    @IBOutlet weak var addressTextField: UITextField! {
        didSet {
            addressTextField.text = stop?.address
        }
    }
    @IBOutlet weak var deleteButton: UIButton! {
        didSet {
            deleteButton.isHidden = stop == nil
        }
    }
    
    var stop: Stop?
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        guard let name: String = nameTextField.text, name.isEmpty == false else {
            alert(text: "Name should not be empty.")
            return
        }
        guard let longitudeText: String = longitudeTextField.text, let longitude: Double = Double(longitudeText) else {
            alert(text: "Longitude station should not be empty.")
            return
        }
        guard let latitudeText: String = latitudeTextField.text, let latitude: Double = Double(latitudeText) else {
            alert(text: "Latitdue should not be empty.")
            return
        }
        guard let address: String = addressTextField.text, address.isEmpty == false else {
            alert(text: "Address should not be empty.")
            return
        }
        if stop != nil {
            ModelManager.shared.updateStop(name: name, address: address, latitude: latitude, longitude: longitude)
        } else {
            ModelManager.shared.addStop(name: name, address: address, latitude: latitude, longitude: longitude)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickDelete(_ sender: UIButton) {
        guard let name: String = stop?.name else { return }
        ModelManager.shared.deleteStop(name: name)
        navigationController?.popViewController(animated: true)
    }
    
    func alert(text: String) {
        let alertController: UIAlertController = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
}

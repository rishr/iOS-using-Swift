import UIKit

class TrainViewController: UIViewController {
    @IBOutlet weak var idTitleLabel: UILabel! {
        didSet {
            idTitleLabel.isHidden = train == nil
        }
    }
    @IBOutlet weak var idLabel: UILabel! {
        didSet {
            idLabel.text = train?.id
            idLabel.isHidden = train == nil
        }
    }
    @IBOutlet weak var nameTextField: UITextField! {
        didSet {
            nameTextField.text = train?.name
        }
    }
    @IBOutlet weak var sourceTextField: UITextField! {
        didSet {
            sourceTextField.text = train?.source
        }
    }
    @IBOutlet weak var destinationTextField: UITextField! {
        didSet {
            destinationTextField.text = train?.destination
        }
    }
    @IBOutlet weak var deleteButton: UIButton! {
        didSet {
            deleteButton.isHidden = train == nil
        }
    }
    @IBOutlet weak var schedulesButton: UIButton! {
        didSet {
            schedulesButton.isHidden = train == nil
        }
    }
    
    var train: Train? {
        didSet {
            ModelManager.shared.train = train
        }
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        guard let name: String = nameTextField.text, name.isEmpty == false else {
            alert(text: "Name should not be empty.")
            return
        }
        guard let source: String = sourceTextField.text, source.isEmpty == false else {
            alert(text: "Source station should not be empty.")
            return
        }
        guard let destination: String = destinationTextField.text, destination.isEmpty == false else {
            alert(text: "Destination station should not be empty.")
            return
        }
        if let id: String = train?.id {
            ModelManager.shared.updateTrain(id: id, name: name, source: source, destination: destination)
        } else {
            ModelManager.shared.addTrain(id: UUID().uuidString, name: name, source: source, destination: destination)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickDelete(_ sender: UIButton) {
        guard let id: String = train?.id else { return }
        ModelManager.shared.deleteTrain(id: id)
        navigationController?.popViewController(animated: true)
    }
    
    func alert(text: String) {
        let alertController: UIAlertController = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

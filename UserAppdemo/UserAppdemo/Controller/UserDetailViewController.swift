

import UIKit
import CoreData

class UserDetailViewController: UIViewController {
    
    @IBOutlet weak var userDetailTableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!

    var user: Users?
    lazy var viewModel = UserDetailViewModel(viewDelegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    func setupView() {
        self.title = "Detail"
        userDetailTableView.register(UINib(nibName: "UserProfilePicTableViewCell", bundle: nil), forCellReuseIdentifier: "UserProfilePicTableViewCell")
        userDetailTableView.register(UINib(nibName: "UserDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "UserDetailTableViewCell")

        self.userDetailTableView.delegate = self
        self.userDetailTableView.dataSource = self
        if let _ = user {
            self.saveButton.setTitle("Save", for: .normal)
        } else {
            self.saveButton.setTitle("Add", for: .normal)
        }
        
        self.saveButton.setCornerRadius()
    }

    @IBAction func saveClicked(_ sender: UIButton) {
        if user == nil {
            let userRequestModel = UserRequestModel(fullName: self.user?.fullName ?? "",
                                                    email: self.user?.email ?? "",
                                                    phone: self.user?.phone ?? "",
                                                    address: self.user?.address ?? "",
                                                    birthdDate: self.user?.birthDate ?? "",
                                                    gender: self.user?.gender ?? "",
                                                    designation: self.user?.designation ?? "",
                                                    salary: Int(self.user?.salary ?? 0))
            self.viewModel.addNewUser(userRequestModel: userRequestModel)
        } else {
            let userRequestModel = UserRequestModel(fullName: self.user?.fullName ?? "",
                                                    email: self.user?.email ?? "",
                                                    phone: self.user?.phone ?? "",
                                                    address: self.user?.address ?? "",
                                                    birthdDate: self.user?.birthDate ?? "",
                                                    gender: self.user?.gender ?? "",
                                                    designation: self.user?.designation ?? "",
                                                    salary: Int(self.user?.salary ?? 0))
            self.viewModel.addNewUser(userRequestModel: userRequestModel)
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension UserDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let userProfilePicCell = tableView.dequeueReusableCell(withIdentifier: "UserProfilePicTableViewCell") as? UserProfilePicTableViewCell
            if let user = self.user {
                userProfilePicCell?.setupCell(user: user)
            }
            return userProfilePicCell ?? UITableViewCell()
        }
        
        let userDetailCell = tableView.dequeueReusableCell(withIdentifier: "UserDetailTableViewCell") as? UserDetailTableViewCell
        userDetailCell?.detailTextField.tag = indexPath.row
        userDetailCell?.detailTextField.delegate = self
        
        if let user = self.user {
            switch indexPath.row {
            case 0:
                userDetailCell?.setupCell(detailPlaceholder: "Full Name", detailText: user.fullName ?? "")
            case 1:
                userDetailCell?.setupCell(detailPlaceholder: "Email", detailText: user.email ?? "")
            case 2:
                userDetailCell?.setupCell(detailPlaceholder: "Phone Number", detailText: user.phone ?? "")
            case 3:
                userDetailCell?.setupCell(detailPlaceholder: "Address", detailText: user.address ?? "")
            case 4:
                userDetailCell?.setupCell(detailPlaceholder: "BirthDate", detailText: user.birthDate ?? "")
            case 5:
                userDetailCell?.setupCell(detailPlaceholder: "Gender", detailText: user.gender ?? "")
            case 6:
                userDetailCell?.setupCell(detailPlaceholder: "Designation", detailText: user.designation ?? "")
            case 7:
                userDetailCell?.setupCell(detailPlaceholder: "Salary", detailText: "\(user.salary)")
            default:
                break
            }
        } else {
            switch indexPath.row {
            case 0:
                userDetailCell?.setupCell(detailPlaceholder: "Full Name", detailText: "")
            case 1:
                userDetailCell?.setupCell(detailPlaceholder: "Email", detailText: "")
            case 2:
                userDetailCell?.setupCell(detailPlaceholder: "Phone Number", detailText: "")
            case 3:
                userDetailCell?.setupCell(detailPlaceholder: "Address", detailText:  "")
            case 4:
                userDetailCell?.setupCell(detailPlaceholder: "BirthDate", detailText: "")
            case 5:
                userDetailCell?.setupCell(detailPlaceholder: "Gender", detailText: "")
            case 6:
                userDetailCell?.setupCell(detailPlaceholder: "Designation", detailText: "")
            case 7:
                userDetailCell?.setupCell(detailPlaceholder: "Salary", detailText: "")
            default:
                break
            }
        }
        return userDetailCell ?? UITableViewCell()
    }
}

extension UserDetailViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.user == nil {
            let managedContext = CoreDataManager.sharedInstance.getManagedContext()

            let entity = NSEntityDescription.entity(forEntityName: Constants.CoreData.Entity.userList, in: managedContext)!
            self.user = (NSManagedObject(entity: entity, insertInto: managedContext) as! Users)
        }
        switch textField.tag {
        case 0:
            self.user?.fullName = textField.text ?? ""
        case 1:
            self.user?.email = textField.text ?? ""
        case 2:
            self.user?.phone = textField.text ?? ""
        case 3:
            self.user?.address = textField.text ?? ""
        case 4:
            self.user?.birthDate = textField.text ?? ""
        case 5:
            self.user?.gender = textField.text ?? ""
        case 6:
            self.user?.designation = textField.text ?? ""
        case 7:
            self.user?.salary = Int64(textField.text ?? "0") ?? 0
        default:
            break
        }
    }
}

extension UserDetailViewController: UserDetailDelegate {
    func addNewUser() {
        let alertController = UIAlertController(title: "Alert", message: "New user added successfully", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

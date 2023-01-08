
import UIKit

class UserListViewController: UIViewController {
     
    @IBOutlet weak var userTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    lazy var viewModel = UserListViewModel(viewDelegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.fetchLocalData()
    }
    
    func setupView() {
        userTableView.register(UINib(nibName: "UserListTableViewCell", bundle: nil), forCellReuseIdentifier: "UserListTableViewCell")
        userTableView.delegate = self
        userTableView.dataSource = self
        searchBar.delegate = self
    }
    
    @IBAction func addUserClicked(_ sender: UIBarButtonItem) {
        if let userDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "UserDetailViewController") as? UserDetailViewController {
            userDetailViewController.user = nil
            self.navigationController?.pushViewController(userDetailViewController, animated: true)
        }
    }
}

extension UserListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            self.viewModel.fetchLocalData(isSearch: true)
            self.viewModel.users = self.viewModel.users.filter { $0.fullName?.contains(searchText.lowercased()) as? Bool ?? false}
            self.userTableView.reloadData()
        } else {
            self.viewModel.fetchLocalData()
        }
    }
}

extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserListTableViewCell") as? UserListTableViewCell
        cell?.setupCell(user: viewModel.users[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let userDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "UserDetailViewController") as? UserDetailViewController {
            userDetailViewController.user = self.viewModel.users[indexPath.row]
            self.navigationController?.pushViewController(userDetailViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            CoreDataManager.sharedInstance.deleteWithPredicate(entityName: Constants.CoreData.Entity.userList, predicate: NSPredicate(format: "userId = \(self.viewModel.users[indexPath.row].userId)"))
            self.viewModel.fetchLocalData()
        }
    }
}

extension UserListViewController: UserListDelegate {
    func getUserList() {
        self.userTableView.reloadData()
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            self.userTableView.reloadData()
        }))
        self.present(alertController, animated: true, completion: nil)
    }

}


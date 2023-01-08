
import Foundation
import CoreData
import Alamofire

protocol UserListDelegate: AnyObject {
    func getUserList()
    func showAlert(message: String)
}

class UserListViewModel {
    weak private var viewDelegate: UserListDelegate?
    var users: [Users] = [Users]()
    
    init(viewDelegate: UserListDelegate) {
        self.viewDelegate = viewDelegate
        
        if NetworkReachabilityManager()!.isReachable {
            self.getUserList()
        } else {
            self.fetchLocalData()
            self.viewDelegate?.showAlert(message: Constants.Message.noInternetMessage)
        }
    }
    
    func getUserList() {
        if !NetworkReachabilityManager()!.isReachable {
            self.fetchLocalData()
            self.viewDelegate?.showAlert(message: Constants.Message.noInternetMessage)
            return
        }
        
        NetworkManager.makeRequest(HTTPRouter.getUserList, mode: UserDataModel.self) { (result) in
            switch result {
            case .success(let responseData):
                if let usersList = responseData.data, usersList.count > 0 {
                    for object in usersList {
                        object.saveUserObject()
                    }
                    self.fetchLocalData()
                }
            case .failure(let errorMessage):
                self.viewDelegate?.showAlert(message: errorMessage.localizedDescription)
            }
        }
    }
    
    func fetchLocalData(isSearch: Bool = false) {
        if let savedObjects = CoreDataManager.sharedInstance.fetch(entityName: Constants.CoreData.Entity.userList) as? [Users], savedObjects.count > 0 {
            self.users = savedObjects
            if !isSearch {
                self.viewDelegate?.getUserList()
            }
        }
    }
}


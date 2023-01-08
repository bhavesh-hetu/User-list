
import Foundation
import Alamofire

protocol UserDetailDelegate: AnyObject {
    func addNewUser()
    func showAlert(message: String)
}

class UserDetailViewModel {
    weak private var viewDelegate: UserDetailDelegate?
    
    init(viewDelegate: UserDetailDelegate) {
        self.viewDelegate = viewDelegate
        
        if !NetworkReachabilityManager()!.isReachable {
            self.viewDelegate?.showAlert(message: Constants.Message.noInternetMessage)
        }
    }
    
    func addNewUser(userRequestModel: UserRequestModel) {
        if !NetworkReachabilityManager()!.isReachable {
            self.viewDelegate?.showAlert(message: Constants.Message.noInternetMessage)
            return
        }
        
        NetworkManager.makeRequest(HTTPRouter.createUser(user: userRequestModel), mode: UserDataModel.self) { (result) in
            switch result {
            case .success(let responseData):
                self.viewDelegate?.addNewUser()
            case .failure(let errorMessage):
                self.viewDelegate?.showAlert(message: errorMessage.localizedDescription)
            }
        }
    }
}

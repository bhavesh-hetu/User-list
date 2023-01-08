
import Foundation
import Alamofire

enum HTTPRouter: URLRequestConvertible {
        
    case getUserList
    case createUser(user: UserRequestModel)
    
    var path: String {
        switch self {
        case .getUserList,
             .createUser:
            return "user"
        }
    }
    
    var method: String {
        switch self {
        case .getUserList:
            return "GET"
        case .createUser:
            return "POST"
        }
    }
    
    var parameter: [String : Any]? {
        switch self {
        case .createUser(let user):
            return ["full_name": user.fullName ?? "",
                    "email": user.email ?? "",
                    "phone": user.phone ?? "",
                    "address": user.address ?? "",
                    "dob": user.birthdDate ?? "",
                    "gender": user.gender ?? "",
                    "designation": user.designation ?? "",
                    "salary": user.salary ?? 0]
        default:
            return nil
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: "\(Constants.Server.baseUrl)" + "\(self.path)")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = self.method
        urlRequest.timeoutInterval = 180
        
        switch self {
        case . getUserList:
            return try URLEncoding.queryString.encode(urlRequest, with: parameter)
        case .createUser:
            return try JSONEncoding.prettyPrinted.encode(urlRequest, with: parameter)
        }
        
    }
}

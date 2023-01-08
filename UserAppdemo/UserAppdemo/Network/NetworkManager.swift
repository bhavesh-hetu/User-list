
import Foundation
import Alamofire

public enum NetworkError: Error {
    case genericError(Int?, String?)
    case internetConnectionError
}

extension NetworkError: LocalizedError {
    public var errorTypes: (Int?, String?) {
        switch self {
        case .internetConnectionError:
            return (0, Constants.Message.noInternetMessage)
        case .genericError(let errorCode, let errorString):
            return (errorCode, errorString)
        }
    }
}

class NetworkManager {
    public static func makeRequest<T: Codable>(_ urlRequest: URLRequestConvertible, mode: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) {
        let request = AF.request(urlRequest).validate().responseString { response in
            switch response.result {
            case .success(let jsonString):
                let jsonData: Data = jsonString.data(using: .utf8)!
                let dict = self.convertStringToDictionary(text: jsonString)
                print("response: ", dict)
                
                let decoder = JSONDecoder()
                do {
                    let decodedJson = try decoder.decode(T.self, from: jsonData)
                    completion(.success(decodedJson))
                } catch {
                    print("response error: ", error.localizedDescription)
                    completion(.failure(.genericError(200, error.localizedDescription)))
                }
            case .failure(let failError):
                print("error response", response)
                do {
                    if let responseData = response.data,
                       let errorResponse = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String : Any] {
                        print("ErrorRespose", errorResponse)
                        completion(.failure(.genericError(response.response?.statusCode, errorResponse["message"] as? String)))
                    }
                } catch {
                    if let descriptionMessage = failError.errorDescription?.contains("The internet connection appears to be offline") {
                        completion(.failure(.genericError(response.response?.statusCode, Constants.Message.noInternetMessage)))
                    }
                    completion(.failure(.genericError(response.response?.statusCode, error.localizedDescription)))
                }
            }
        }
    }
    
    public static func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
}


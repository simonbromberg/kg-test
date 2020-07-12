import Foundation
import Alamofire
import GoogleSignIn

class NetworkingManager {
    
    private static var headers: HTTPHeaders? {
        guard let accessToken = GIDSignIn.sharedInstance()?.currentUser.authentication.accessToken else {
            return nil
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Accept": "application/json"
        ]
        return headers
    }
    
    static func getUserMessages(labels: [String], completion: @escaping ([[Email]]) -> ()) {
        if labels.isEmpty {
            internalGetMessages(label: nil) {
                completion([$0])
            }
        } else {
            // LOAD MESSAGES FOR LABELS QUESTION
            //
            // This implementation is incomplete.
            // Using the array of labels and the internalGetMessages function below, make requests to get all messages that have at least one of the labels in the array.
            // If the array is empty, make one request to get messages with no labels.
            completion([[]])
        }
    }

    private static func internalGetMessages(label: String?, completion: @escaping ([Email]) -> ()) {
        guard let headers = headers else {
            completion([])
            return
        }
        
        var parameters: Parameters = [String: Any]()
        parameters["labelIds"] = label

        AF.request("https://www.googleapis.com/gmail/v1/users/me/messages", parameters: parameters, encoding: URLEncoding(arrayEncoding: .noBrackets), headers: headers)
            .validateToken()
            .responseJSON { (response) in
                if let json = try? response.result.get() as? [String: Any], let messages = json["messages"] as? [[String:String]] {
                    getMessageData(messageIDs: messages.compactMap { $0["id"] }) {
                        completion($0)
                    }
                } else {
                    completion([])
                }
        }
    }
    
    private static func getMessageData(messageIDs: [String], completion: @escaping ([Email]) -> ()) {
        guard let headers = headers else {
            completion([])
            return
        }
        var emails = [Email]()
        let emailDataDispatchGroup = DispatchGroup()
        
        messageIDs.forEach {
            emailDataDispatchGroup.enter()
            AF.request("https://www.googleapis.com/gmail/v1/users/me/messages/\($0)", headers: headers)
                .validateToken()
                .responseDecodable { (response: DataResponse<Email, AFError>) in
                    switch response.result {
                    case .success(let email):
                        emails.append(email)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    emailDataDispatchGroup.leave()
            }
        }
        
        emailDataDispatchGroup.notify(queue: .main) {
            completion(emails)
        }
    }

    static func saveLabelsForEmails(emailIDs: [String], newLabels: [String], removeLabels:[String], completion: @escaping (Bool) -> ()) {
        guard let headers = headers else {
            completion(false)
            return
        }

        let parameters: Parameters = [
            "ids": emailIDs,
            "addLabelIds": newLabels,
            "removeLabelIds": removeLabels
        ]

        AF.request("https://www.googleapis.com/gmail/v1/users/me/messages/batchModify", method: .post, parameters: parameters, encoding: JSONEncoding.default,  headers: headers)
            .validateToken()
            .response { (response) in
                switch response.result {
                case .success(_):
                    completion(true)
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(false)
                }
        }
    }

    static func getAllUserLabels(completion: @escaping ([Label]) -> ()) {
        guard let headers = headers else {
            completion([])
            return
        }
        AF.request("https://www.googleapis.com/gmail/v1/users/me/labels", headers: headers)
            .validateToken()
            .responseDecodable { (response: DataResponse<LabelsReponse, AFError>) in
                switch response.result {
                case .success (let labelsResponse):
                    completion(labelsResponse.labels)
                case .failure (let error):
                    print(error.localizedDescription)
                    completion([])
                }
        }
    }

    static func addNewUserDefinedLabel(_ labelName: String, completion: @escaping (Bool) -> ()) {
        guard let headers = headers else {
            completion(false)
            return
        }

        let parameters: Parameters = ["name": labelName]

        AF.request("https://www.googleapis.com/gmail/v1/users/me/labels", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validateToken()
            .responseDecodable { (response: DataResponse<Label, AFError>) in
                switch response.result {
                case .success (_):
                    completion(true)
                case .failure (let error):
                    print(error.localizedDescription)
                    completion(false)
                }
        }
    }
}

extension NSNotification.Name {
    static let authTokenExpired = Notification.Name(rawValue: "authTokenExpired")
}

extension DataRequest {
    func validateToken() -> Self {
        return validate { request, response, data in
            if response.statusCode == 401 {
                NotificationCenter.default.post(name: .authTokenExpired, object: nil)
                let error: AFError = AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: 401))
                return .failure(error)
            } else {
                return .success(())
            }
        }
    }
}

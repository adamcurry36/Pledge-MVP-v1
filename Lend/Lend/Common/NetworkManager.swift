//
//  NetworkManager.swift
//  Lend
//
//  Created by ОК on 09.03.2021.
//

import Foundation

class NetworkManager {
    typealias RequestCallback = (NetworkManager.Result)->Void
    
    enum Result {
        case success(message: String)
        case failure(error: String)
    }
    
    static let bearedToken = "Bearer oM7Wd3HmJuW25irv712oKKq1JqXc3x4TBjPTHEBqjN00CSbEtzf96ZcGCgQP"
    static let baseUrl = "http://143.110.179.62"
    static let internalError = "Network error"
    let subscriptionPaymentUrl = "\(NetworkManager.baseUrl)/stripe/api/subscription-payment"
    let oneTimePaymentUrl = "\(NetworkManager.baseUrl)/stripe/api/one-time-payment"
    
    static let shared: NetworkManager = NetworkManager()
    
    func subscriptionPayment(amount: Float, token: String, isOneTimeMode: Bool, completion: @escaping RequestCallback) {
        guard let user = UserManager.shared.user else { return completion(Result.failure(error: NetworkManager.internalError)) }
        
        let currency = "USD"
        let userId = FirestoreManager.shared.currentUser?.uid ?? "NULL"
        
        var parameters: [String: Any] = ["email": user.email,
                                   "amount": amount,
                                   "currency": currency,
                                   "source": token,
                                   "organization": userId]//TZ: change organiasationId to userId
        
        if let firstName = user.firstName {
            parameters["first_name"] = firstName
        }
        if let lastName = user.lastName {
            parameters["last_name"] = lastName
        }
        print("parameters = \(parameters)")
        
        let url = URL(string: isOneTimeMode ? oneTimePaymentUrl : subscriptionPaymentUrl)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let postString = self.getPostString(params: parameters)
        request.httpBody = postString.data(using: .utf8)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(NetworkManager.bearedToken, forHTTPHeaderField: "Authorization")
        
        let completionBlock: RequestCallback = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }

        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                guard error == nil else {
                    return completionBlock(.failure(error: error!.localizedDescription))
                }

                guard let data = data else {
                    return completionBlock(.failure(error: NetworkManager.internalError))
                }

                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                        print("json = \(json)")
                        if let success = json["success"] as? Int, success == 1 {
                            let message = json["message"] as? String ?? ""
                            completionBlock(.success(message: message))
                        } else {
                            completionBlock(.failure(error: NetworkManager.internalError))
                        }
                    }
                } catch let error {
                    return completionBlock(.failure(error: error.localizedDescription))
                }
            })
            task.resume()

    }
    
    private func getPostString(params:[String:Any]) -> String {
        var data = [String]()
        for(key, value) in params
        {
            data.append(key + "=\(value)")
        }
        return data.map { String($0) }.joined(separator: "&")
    }
    
}

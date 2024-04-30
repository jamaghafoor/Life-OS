////
////  NetworkManager.swift
////  thumbsUp
////
////  Created by Aniket Vaddoriya on 11/04/22.
////
//
//import Foundation
//import Alamofire
//import SwiftUI
//
//struct NetworkManagerOld {
//    //	static func cancelAllRequests() {
//    //		AF.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
//    //			dataTasks.forEach { $0.cancel() }
//    //			uploadTasks.forEach { $0.cancel() }
//    //			downloadTasks.forEach { $0.cancel() }
//    //		}
//    //	}
//
//    static var getHeaderParams : HTTPHeaders {
//        let dict =  [WebServices.HeaderKey : WebServices.HeaderValue]
//        return HTTPHeaders(dict)
//    }
//
//    static func callWebService<T : Codable>(url : String ,
//                                            httpMethod : HTTPMethod = .post,
//                                            params: Parameters? = [:],
//                                            callbackSuccess : @escaping (T) -> (),
//                                            callbackFailure : @escaping (_ err : Error) -> () = { _ in }) {
//
//        AF.request(url, method: httpMethod, parameters: params,headers: getHeaderParams)
//            .responseString { response in
//                print(response.request ?? "")  // original URL request
//                print("parameters = \(String(describing: params))")
//                switch response.result {
//                case .success(let value):
//                    print("success: \(String(describing: value.parseJSONString))")
//                    if let data = response.data {
//                        do {
//                            let jsonData = try JSONDecoder().decode(T.self, from: data)
//                            callbackSuccess(jsonData)
//                        }
//                        catch let error as NSError {
//                            print(error.localizedDescription)
//                            callbackFailure(error)
//                            break;
//                        }
//                    }
//                case .failure(let error):
//                    print(error)
//                }
//            }
//    }
//}
//
//
//
//extension String {
//
//    var parseJSONString: AnyObject? {
//
//        let data = self.data(using: .utf8, allowLossyConversion: false)
//
//        if let jsonData = data {
//            let json = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as AnyObject
//            return json
//        } else {
//            return nil
//        }
//    }
//}

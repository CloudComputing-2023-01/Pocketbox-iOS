//
//  ApiLogger.swift
//  PocketBox
//
//  Created by MBSoo on 2023/06/11.

import Foundation
import Alamofire

final class ApiLogger: EventMonitor {
    let queue = DispatchQueue(label: "ApiLogger")
    
    // Event called when any type of Request is resumed.
    func requestDidResume(_ request: Request) {
        print("ApiLogger - Resuming: \(request)")
    }
    
    // Event called whenever a DataRequest has parsed a response.
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        debugPrint("ApiLogger - Finished: \(response)")
    }
}

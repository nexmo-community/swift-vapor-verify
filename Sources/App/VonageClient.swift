#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import NIO
import Vapor
import Foundation

public struct Vonage {
    private let apiKey: String
    private let apiSecret: String
    
    public init(apiKey: String, apiSecret: String) {
        self.apiKey = apiKey
        self.apiSecret = apiSecret
    }
    
    public func requestVerification(with body: RequestVerificationBody, client: Client) -> EventLoopFuture<ClientResponse> {
        return client.post(URI(scheme: "https", host: "api.nexmo.com", path: "/verify/json")) { req in
            try req.content.encode(RequestVerificationBody(body: body, apiKey: apiKey, apiSecret: apiSecret), as: .json)
        }
    }
    
    public func checkVerification(with body: CheckVerificationBody, client: Client) -> EventLoopFuture<ClientResponse> {
        return client.post(URI(scheme: "https", host: "api.nexmo.com", path: "/verify/check/json")) { req in
            try req.content.encode(CheckVerificationBody(body: body, apiKey: apiKey, apiSecret: apiSecret), as: .json)
        }
    }
    
    /*
     These structs are used as both the input into the server and its output. The non-optional properties
     and properties which don't have a default value are supplied when a request is made to the server.
     
     The custom initialiser is used to take in the version of the struct from the request to the server,
     enrich it with the api key and secret then use the new struct for making a call to the Vonage APIs.
     */
    public struct RequestVerificationBody: Content {
        let number: String
        let brand: String = "SwiftVerify"
        var apiKey: String?
        var apiSecret: String?
        
        init(body: RequestVerificationBody, apiKey: String, apiSecret: String) {
            self.number = body.number
            self.apiKey = apiKey
            self.apiSecret = apiSecret
        }
        
        private enum CodingKeys: String, CodingKey {
            case number
            case brand
            case apiKey = "api_key"
            case apiSecret = "api_secret"
        }
    }
    
    public struct CheckVerificationBody: Content {
        let requestID: String
        let code: String
        var apiKey: String?
        var apiSecret: String?
        
        init(body: CheckVerificationBody, apiKey: String, apiSecret: String) {
            self.requestID = body.requestID
            self.code = body.code
            self.apiKey = apiKey
            self.apiSecret = apiSecret
        }
        
        private enum CodingKeys: String, CodingKey {
            case requestID = "request_id"
            case code
            case apiKey = "api_key"
            case apiSecret = "api_secret"
        }
    }
}

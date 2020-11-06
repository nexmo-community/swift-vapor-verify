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
    
    public struct RequestVerificationBody: Content {
        let number: String
        let brand: String = "SwiftVerify"
        let workflowID: Int = 6
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
            case workflowID = "workflow_id"
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

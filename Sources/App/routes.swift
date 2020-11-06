import Vapor

func routes(_ app: Application) throws {
    let client = Vonage(apiKey: "API_KEY", apiSecret: "API_SECRET")
    
    app.post("request") { req -> EventLoopFuture<ClientResponse> in
        let body = try req.content.decode(Vonage.RequestVerificationBody.self)
        return client.requestVerification(with: body, client: req.client)
    }

    app.post("check") { req -> EventLoopFuture<ClientResponse> in
        let body = try req.content.decode(Vonage.CheckVerificationBody.self)
        return client.checkVerification(with: body, client: req.client)
    }
}

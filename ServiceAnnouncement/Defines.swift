import Foundation

enum AppError: Error {
    case invalidStatusCode
}

let iso8601Formatter: ISO8601DateFormatter = {
    let f = ISO8601DateFormatter()
    f.formatOptions = [
        .withInternetDateTime,
        .withFractionalSeconds // Required for parsing milliseconds date string.
    ]
    return f
}()

let microCMSJSONDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .custom({ decoder in
        let container = try decoder.singleValueContainer()
        let dateString = try container.decode(String.self)
        if let date = iso8601Formatter.date(from: dateString) {
            return date
        }
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
    })
    return decoder
}()

@available(*, unavailable, message: "Replace API Key with your API Key, and Remove @available")
let microCMSAPIKey = (key: "X-MICROCMS-API-KEY", value: "xxxxxxxxxxxxxxxxxx")

@available(*, unavailable, message: "Replace this with your service domain, and Remove @available")
let microCMSServiceDomain = "xxxxxx"

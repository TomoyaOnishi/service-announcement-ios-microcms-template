import Foundation

struct ResponseContainer<T: Codable>: Codable {
    var contents: [T]
    let totalCount: Int
}

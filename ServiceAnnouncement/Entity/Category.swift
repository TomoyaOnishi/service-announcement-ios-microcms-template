import Foundation

struct Category: Codable {
    let id: String
    let name: String
}

extension Category: Identifiable, Equatable, Hashable { }

import Foundation

struct Announcement: Codable {
    let id: String
    let title: String
    let description: String
    let updatedAt: Date
    let category: Category
}

extension Announcement: Identifiable, Equatable, Hashable { }

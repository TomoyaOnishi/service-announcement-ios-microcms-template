import Foundation

@MainActor
final class Model: ObservableObject {
    
    @Published var contentsResponse: ResponseContainer<Announcement>?
    @Published var categoriesResponse: ResponseContainer<Category>?
    @Published var isFetching: Bool = false
    @Published var filteredCategories: [Category] = []
    
    var isFilteredByCategory: Bool { !filteredCategories.isEmpty }
    
    func fetchFirstContents() async {
        isFetching = true
        defer { isFetching = false }
        
        do {
            async let fetchContentsTask = fetchAnnouncements(offset: 0)
            async let fetchCategoriesTask = fetchCategories()
            
            contentsResponse = try await fetchContentsTask
            categoriesResponse = try await fetchCategoriesTask
        } catch {
            print("fetch first contents error: ", error.localizedDescription)
        }
    }
    
    private func fetchAnnouncements(offset: Int) async throws -> ResponseContainer<Announcement> {
        var components = URLComponents(string: "https://\(microCMSServiceDomain).microcms.io/api/v1/announcements")!
        components.queryItems = [
            .init(name: "offset", value: String(offset)),
            .init(name: "limit", value: "10"),
        ]
        
        if isFilteredByCategory {
            components.queryItems?.append(URLQueryItem(name: "filters", value: buildFiltersQuery()))
        }
        
        var request = URLRequest(url: components.url!)
        request.addValue(microCMSAPIKey.value, forHTTPHeaderField: microCMSAPIKey.key)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try microCMSJSONDecoder.decode(ResponseContainer<Announcement>.self, from: data)
    }
    
    private func fetchCategories() async throws -> ResponseContainer<Category> {
        var components = URLComponents(string: "https://ios-service-announcement.microcms.io/api/v1/categories")!
        components.queryItems = [
            .init(name: "limit", value: "100"),
        ]
        
        var request = URLRequest(url: components.url!)
        request.addValue(microCMSAPIKey.value, forHTTPHeaderField: microCMSAPIKey.key)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try microCMSJSONDecoder.decode(ResponseContainer<Category>.self, from: data)
    }
    
    func fetchFilteredNews() async {
        do {
            contentsResponse = nil
            contentsResponse = try await fetchAnnouncements(offset: 0)
        } catch {
            print(error)
        }
    }
    
    func fetchNextNews() async {
        do {
            if let contentsResponse {
                let response = try await fetchAnnouncements(offset: contentsResponse.contents.count)
                self.contentsResponse?.contents.append(contentsOf: response.contents)
            }
        } catch {
            print(error)
        }
    }
    
    private func buildFiltersQuery() -> String {
        var filterPredicates: [String] = []
        if !filteredCategories.isEmpty {
            filterPredicates.append(filteredCategories.map { "category[equals]\($0.id)" }.joined(separator: "[or]"))
        }
        let andPredicate = filterPredicates.joined(separator: "[and]")
        return andPredicate
    }
    
    func clearFilters() {
        filteredCategories = []
        contentsResponse = nil
        
        Task {
            await fetchFirstContents()
        }
    }
}

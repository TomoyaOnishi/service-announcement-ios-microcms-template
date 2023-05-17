import SwiftUI

struct ContentListView: View {
    @EnvironmentObject var model: Model
    
    enum Presentation: Identifiable {
        var id: Self { self }
        case categoryFilter
        case dateFilter
    }
    @State var presentation: Presentation?
    
    @State var selectedContent: Announcement?
    
    var body: some View {
        NavigationSplitView(sidebar: {
            List(selection: $selectedContent) {
                if !model.isFetching, let contentsResponse = model.contentsResponse {
                    ForEach(contentsResponse.contents) { content in
                        NavigationLink(value: content, label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(content.category.name)
                                            .font(.caption)
                                            .bold()
                                            .padding(6)
                                            .frame(width: 90)
                                            .background(content.category.color)
                                            .foregroundColor(.white)
                                            .cornerRadius(4)
                                        
                                        Text(content.updatedAt, format: .dateTime)
                                            .foregroundColor(.gray)
                                            .font(.caption)
                                            .bold()
                                    }
                                    Text(content.title)
                                        .lineLimit(1)
                                }
                            }
                        })
                        .onAppear {
                            if content == contentsResponse.contents.last,
                               contentsResponse.totalCount != contentsResponse.contents.count {
                                Task {
                                    await model.fetchNextNews()
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle(Text("microCMS for お知らせ"))
            .toolbar {
                ToolbarItem {
                    Button {
                        presentation = .categoryFilter
                    } label: {
                        Label("フィルター", systemImage: model.isFilteredByCategory ?  "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                    }
                }
            }
        }, detail: {
            if let selectedContent {
                ContentDetailView(content: selectedContent)
            }
        })
        .task {
            await model.fetchFirstContents()
        }
        .sheet(item: $presentation) { newValue in
            switch newValue {
            case .categoryFilter:
                CategoryFilterView(
                    categories: model.categoriesResponse?.contents ?? [],
                    selectedCategories: Set(model.filteredCategories),
                    onCommit: { (selected: [Category]) in
                        Task { @MainActor in
                            model.filteredCategories = selected
                            await model.fetchFilteredNews()
                        }
                    }
                )
                #if os(macOS)
                .frame(width: 320, height: 320)
                #endif
            case .dateFilter:
                EmptyView()
            }
        }
    }
    
    @ViewBuilder var circularProgressView: some View {
        if model.isFetching {
            ProgressView()
                .progressViewStyle(.circular)
        } else {
            EmptyView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let previewContents: [Announcement] = (0..<10).map { index in
            Announcement(id: "\(index)",
                         title: "タイトル\(index)",
                         description: "内容\(index)",
                         updatedAt: Date(),
                         category: Category(id: "event", name: "イベント")
            )
        }
        let model = Model()
        model.contentsResponse = .init(contents: previewContents, totalCount: 10)
        
        return Group {
            ContentListView().environment(\.colorScheme, .light)
            ContentListView().environment(\.colorScheme, .dark)
        }
        .environmentObject(model).environment(\.locale, Locale(identifier: "ja"))
    }
}

extension Category {
    var color: Color {
        switch id {
        case "event": return .orange
        case "service-disruption": return .red
        case "release": return .green
        default: return .blue
        }
    }
}

import SwiftUI

struct CategoryFilterView: View {
    let categories: [Category]
    @State var selectedCategories: Set<Category> = []
    let onCommit: ([Category]) -> Void

    @Environment(\.dismiss) var dismissAction

    var body: some View {
        NavigationStack {
            Form {
                ForEach(categories) { (category: Category) in
                    let isSelected = selectedCategories.contains(category)
                    Button {
                        if isSelected {
                            selectedCategories.remove(category)
                        } else {
                            selectedCategories.insert(category)
                        }
                    } label: {
                        if isSelected {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                                Text(category.name)
                            }
                        } else {
                            HStack {
                                Image(systemName: "circle")
                                    .foregroundColor(.blue)
                                Text(category.name)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                    .contentShape(Rectangle())
                    #if os(macOS)
                    .font(.system(size: 20))
                    .padding(8)
                    #endif
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismissAction()
                    } label: {
                        Text("キャンセル")
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        onCommit(Array(selectedCategories))
                        dismissAction()
                    } label: {
                        Text("完了")
                            .bold()
                    }
                }
            }
        }
    }
}

struct CategoryFilterView_Previews: PreviewProvider {
    static var previews: some View {
        let previewCategories = [
            Category(id: "event", name: "イベント"),
            Category(id: "service-disruption", name: "障害情報"),
            Category(id: "release", name: "更新情報"),
            Category(id: "maintenance", name: "メンテナンス"),
        ]
        CategoryFilterView(categories: previewCategories, onCommit: { _ in }).environment(\.locale, Locale(identifier: "ja"))
    }
}

import SwiftUI

struct ContentDetailView: View {
    let content: Announcement
    var body: some View {
        ScrollView {
            Text(content.title)
                .font(.title3)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(3)
                .padding()
            
            Text(content.category.name)
                .font(.caption)
                .bold()
                .padding(6)
                .frame(width: 90)
                .background(content.category.color)
                .foregroundColor(.white)
                .cornerRadius(4)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            
            Text(content.description)
                .font(.body)
                .padding()
        }
    }
}

struct ContentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentDetailView(content: Announcement(id: "test-id",
                                                    title: "【重要】サービスメンテナンスのお知らせ",
                                                    description: """
平素よりXXXをご利用いただきありがとうございます。

下記の期間、サービスのメンテナンスを実施いたします。

【メンテナンス期間】
2023年5月1日（日） 12:00 〜 2023年5月1日（日） 18:00

メンテナンス期間中は、XXX の各機能がご利用いただけません。ご利用になる場合は、メンテナンス終了後に改めてお試しください。
お客様にはご迷惑をおかけいたしますが、何卒ご理解くださいますようお願い申し上げます。

何かご不明な点がございましたら、お気軽にお問い合わせください。今後とも、XXXをよろしくお願い申し上げます。

""",
                                                    updatedAt: Date(),
                                                    category: Category(id: "event", name: "イベント")))
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
        }
        .environment(\.locale, Locale(identifier: "ja"))
    }
}

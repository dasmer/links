import SwiftUI

struct ContentView: View {

    // MARK: - Properties
    @State private var showingAlert = false
    @State var showingCreateSheet = false

    @State private var links: [LinkItem] = {
        guard let encodedData = UserDefaults.standard.array(forKey: "LinksKey") as? [Data] else {
            return []
        }
        return encodedData.map { try! JSONDecoder().decode(LinkItem.self, from: $0) }
    }() {
        didSet {
            let data = links.map { try! JSONEncoder().encode($0) }
            UserDefaults.standard.set(data, forKey: "LinksKey")
        }
    }

    var list: some View {
        List {
            ForEach(links, id: \.self) { link in
                VStack(alignment: .leading) {
                    Link(link.name, destination: URL(string: link.urlString)!)
                    Text(link.urlString).font(.caption)
                }
                .onLongPressGesture {
                    UIPasteboard.general.string = link.urlString
                    self.showingAlert = true
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Link copied"),
                          message: Text(link.urlString),
                          dismissButton: .default(Text("OK")))
                }
            }
            .onDelete(perform: delete)
        }.navigationBarTitle("Links", displayMode: .inline)
        .listStyle(PlainListStyle())
    }


    var body: some View {
        NavigationView {
            list
                .navigationBarItems(trailing:
                                        Button(action: {
                                            self.showingCreateSheet.toggle()
                                        }) {
                                            Text("Create Link")
                                        }.sheet(isPresented: $showingCreateSheet) {
                                            CreateLinkView(addAction: { linkItem in
                                                links.append(linkItem)
                                            })
                                        }
                )
        }
    }

    func delete(at offsets: IndexSet) {
        links.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

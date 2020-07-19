import SwiftUI

struct CreateLinkView: View {
    @State var name: String = ""
    @State var urlString: String = ""
    @Environment(\.presentationMode) var presentationMode

    var addAction: ((LinkItem) -> () )


    var body: some View {
        NavigationView {
            Form {
                TextField("Name",
                          text: $name).autocapitalization(.none).disableAutocorrection(true)
                TextField("URL",
                          text: $urlString).autocapitalization(.none).disableAutocorrection(true)
            }
            .navigationBarTitle("Time", displayMode: .inline)
            .navigationBarItems(leading:
                                    Button(action: {
                                        self.presentationMode.wrappedValue.dismiss()
                                    }) {
                                        Text("Dismiss")
                                    }, trailing:
                                        Button(action: {
                                            let item = LinkItem(name: name, urlString: urlString)
                                            addAction(item)
                                            self.presentationMode.wrappedValue.dismiss()
                                        }) {
                                            Text("Add")
                                        }
            )
        }
    }
}
struct CreateLinkView_Previews: PreviewProvider {
    static var previews: some View {
        CreateLinkView(addAction: {_ in })
    }
}

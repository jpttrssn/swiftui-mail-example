//
//  ContentView.swift
//  mail-swift-ui
//
//  Created by Jon Pettersson on 2020-11-29.
//

import SwiftUI

struct ContentView: View {
    @State var selectedFolder: String? = "Inbox"
    @State var selectedMail: String? = nil
    
    var body: some View {
        NavigationView {
            Sidebar(selectedFolder: $selectedFolder, selectedMail: $selectedMail)
            if selectedFolder == nil {
                Text("No Folder Selected")
                    .font(.title)
                    .toolbar(content: {
                        ToolbarItemGroup(placement: .primaryAction) {
                            Spacer()
                        }
                    })
            }
            if selectedMail == nil {
                Text("No Message Selected")
                    .font(.title)
                    .toolbar(content: {
                        ToolbarItemGroup(placement: .primaryAction) {
                            Button(action: {}) {
                                Image(systemName: "envelope")
                            }
                            Button(action: {}) {
                                Image(systemName: "square.and.pencil")
                            }
                        }
                    })
            }
        }
    }
}

struct Sidebar: View {
    @State var smartMailboxHover = false
    @Binding var selectedFolder: String?
    @Binding var selectedMail: String?
    
    var body: some View {
        List() {
            Section(header: Text("Favourites")) {
                NavigationLink(destination: Inbox(folder: "Inbox", selectedMail: $selectedMail), tag: "Inbox", selection: $selectedFolder) {
                    Label("Inbox", systemImage: "tray")
                }
                NavigationLink(destination: Inbox(folder: "Sent", selectedMail: $selectedMail), tag: "Sent", selection: $selectedFolder) {
                    Label("Sent", systemImage: "paperplane")
                }
                NavigationLink(destination: Inbox(folder: "Drafts", selectedMail: $selectedMail), tag: "Drafts", selection: $selectedFolder) {
                    Label("Drafts", systemImage: "doc")
                }
            }
            Section(header: HStack {
                    Text("Smart Mailboxes")
                    Spacer()
                    if smartMailboxHover {
                        Button(action: {}) {
                            Image(systemName: "plus.circle")
                        }.buttonStyle(PlainButtonStyle())
                    }
                }
                .onHover(perform: { hovering in
                    smartMailboxHover = hovering
                })
            
            ) {
                NavigationLink(destination: Inbox(selectedMail: $selectedMail)) {
                    Label("Today", systemImage: "gearshape")
                        .accentColor(.gray)
                }
            }
        }
        .listStyle(SidebarListStyle())
        .frame(minWidth: 100, idealWidth: 150, maxWidth: 200, maxHeight: .infinity)
    }
}

struct Inbox: View {
    @State var folder: String = "Inbox"
    @Binding var selectedMail: String?
    
    var body: some View {
        List(mailStore[folder, default: []], id: \.self, selection: $selectedMail) { mail in
            NavigationLink(destination: Detail(mail: mail)) {
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(mail.name)")
                            .font(.headline)
                            .frame(maxHeight: 30)
                        Spacer()
                        Text("\(mail.date, formatter: dateFormatter)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    HStack {
                        Text("\(mail.title)")
                        Spacer()
                        Image(systemName: "paperclip")
                            .foregroundColor(.gray)
                    }
                    .font(.subheadline)
                    .frame(maxHeight: 10)
                    Text("\(mail.body)")
                        .font(.body)
                        .foregroundColor(.gray)
                        .frame(maxHeight: 50)
                    Divider()
                        .frame(alignment: .bottom)
                }
            }.padding([.leading, .trailing])
        }
        .frame(minWidth: 300, idealWidth: 300)
        .navigationTitle(folder)
        .toolbar(content: {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {}) {
                    Image(systemName: "line.horizontal.3.decrease.circle")
                }
            }
        })
        .listStyle(InsetListStyle())
    }
        
        
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
}

struct Detail: View {
    @State var mail: Mail
    
    var body: some View {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(mail.name)")
                            .font(.headline)
                        Spacer()
                        Text("\(mail.date, formatter: dateFormatter)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Text("\(mail.title)")
                        .font(.subheadline)
                    HStack {
                        Text("To:")
                        Text("\(mail.address)")
                    }
                    HStack {
                        Text("Reply-To:")
                        Text("customer.service@example.com")
                    }
                    Divider()
                }
                Text("\(mail.body)")
                Spacer()
            }
            .padding()
            .navigationTitle(mail.title)
            .toolbar(content: {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button(action: {}) {
                        Image(systemName: "envelope")
                    }
                    Button(action: {}) {
                        Image(systemName: "square.and.pencil")
                    }
                    Spacer()
                    HStack {
                        Button(action: {}) {
                            Image(systemName: "archivebox")
                        }
                        Divider()
                        Button(action: {}) {
                            Image(systemName: "trash")
                        }
                        Divider()
                        Button(action: {}) {
                            Image(systemName: "xmark.bin")
                        }
                    }
                }
            })
    }
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }()
}

struct Mail: Hashable {
    var title: String
    var body: String
    var name: String
    var address: String
    var date: Date
}

let mailStore: [String:[Mail]] = [
    "Inbox":[
        Mail.init(title: "My first Mail", body: """
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non felis consequat, ultrices enim id, fringilla arcu. Phasellus mauris augue, egestas id mauris ut, fermentum varius nulla. Mauris in dignissim lacus. Maecenas tincidunt ex ac nibh tincidunt fringilla. Duis tortor purus, iaculis ut sollicitudin sit amet, faucibus vitae nunc. Nulla sed ullamcorper lacus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Quisque a mattis arcu. Cras vestibulum mattis turpis eu mollis. Nullam bibendum finibus eros, vel blandit lorem dictum sit amet. Nunc sodales semper ligula, sed tempor metus pulvinar eu. Vivamus tristique efficitur odio, at mollis lacus pharetra non. Maecenas cursus tellus ligula, eu venenatis lorem facilisis nec. Cras ultrices ipsum vel dolor tempus lacinia. Praesent sed augue nisi. Suspendisse rutrum nec arcu in dignissim.

""", name: "Dude McFarlen", address: "dude@example.net", date: Date(timeIntervalSinceNow: -60)),
        Mail.init(title: "Welcome to Mail", body: """
Nullam pulvinar arcu ut porttitor pretium. Etiam malesuada, lacus sed rhoncus pharetra, lectus mauris vulputate neque, vel finibus purus lacus sed sapien. Ut vestibulum elit id elementum tristique. Praesent aliquet purus sed leo auctor ullamcorper ut sit amet leo. Quisque feugiat vulputate purus, a malesuada eros congue ac. Vivamus rhoncus augue id mi sodales, et elementum eros rhoncus. Fusce turpis orci, fermentum vitae nisl non, lacinia consequat turpis. Etiam sed pulvinar tellus. Ut convallis at arcu quis aliquet. Quisque ipsum neque, tincidunt sed augue id, gravida porttitor nibh.
""", name: "Mail Man", address: "mail@example.net", date: Date(timeIntervalSinceNow: -60*120))
    ],
    "Sent":[
        Mail.init(title: "Sent this one", body: """
Maecenas sit amet ullamcorper orci. Nulla ultrices orci vel tincidunt ultrices. Vivamus a nisl quam. Cras vitae tellus risus. Fusce fringilla vitae felis ut bibendum. Quisque finibus ligula at orci hendrerit placerat. Nulla lobortis arcu id quam tempus egestas. Nam quis nunc non tortor feugiat sollicitudin non ut diam. Sed eu imperdiet nisl. Integer tincidunt, ante id lobortis bibendum, eros nulla varius purus, nec bibendum elit purus at nisi. Ut vehicula id velit vel vestibulum. Aenean volutpat elementum dolor at rhoncus. In ac lectus laoreet, venenatis nisi efficitur, blandit purus. Vivamus sagittis nisl sit amet porta gravida. Cras eget orci metus. Duis et sapien vel sapien pellentesque bibendum.
""", name: "Apple Support", address: "support@apple.com", date: Date(timeIntervalSinceNow: -60))
    ],
    "Drafts":[
        Mail.init(title: "A draft", body: "Hey, mom", name: "Your Mom", address: "your.mom@example.net", date: Date(timeIntervalSinceNow: -60))
    ]
]

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

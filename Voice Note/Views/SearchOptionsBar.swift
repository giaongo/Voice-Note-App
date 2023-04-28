import SwiftUI

struct SearchOptionsBar: View {
    @Binding var searchQuery: String
    var onSearchQuery: () -> Void
    var onCancelSearch: () -> Void
    @State private var searchOptionBarText: String = ""

    @State private var isEditing = false
    
    let buttonColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
        
    var body: some View {
        HStack {
            
            TextField("Search ...", text: $searchQuery)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color(buttonColor))
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if isEditing {
                            Button(action: {
                                self.searchQuery = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(Color(buttonColor))
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
                .onTapGesture {
                    withAnimation{
                        isEditing.toggle()
                    }
                }.onChange(of: searchQuery, perform: {value in
                        //Searching places
                        searchQuery = value
                        onSearchQuery()
                    })
            
            if isEditing {
                Button(action: {
                    print("Cancel Pressed")
                    onCancelSearch()
                    withAnimation {
                        isEditing.toggle()
                        self.searchQuery = ""
                    }
                    // Dismiss the keyboard
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .buttonStyle(.borderedProminent)
                .tint(Color(.systemGray6))
                .foregroundColor(Color(buttonColor))
                .animation(.linear(duration: 0.2))
            }
            else {
                Button {
                    print("Options menu")
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 25))
                        .foregroundColor(Color(buttonColor))
                        .rotationEffect(.degrees(90))
                        .padding([.bottom, .top], 7)
                }
                .padding(.horizontal, 10)
                .buttonStyle(.borderedProminent)
                .tint(Color(.systemGray6))
            }
        }
    }
}

/*struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        //SearchOptionsBar(searchQuery: .constant(""))
    }
}*/

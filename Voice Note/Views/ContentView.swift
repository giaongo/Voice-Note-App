import SwiftUI

struct ContentView: View {
    @State var increaseHeight: Bool = false
    @State var toast:ToastView? = nil
    @State var showSheet: Bool = false
    @State var tagSelect = "house"
    private var temperatureDataService = TemperatureDataService.sharedLocationService

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection:$tagSelect) {
                MapScreen().tag("house").ignoresSafeArea()
                Color.purple.tag("mic.fill").ignoresSafeArea()
                RecordingListView().tag("list.dash").ignoresSafeArea()
            }
            BottomBarView(toast: $toast,showSheet: $showSheet, tagSelect: $tagSelect)
        }
        .task {
            await temperatureDataService.fetchLatestTemperatures()
        }
        .toastView(toast: $toast)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView().environmentObject(VoiceNoteViewModel()).environmentObject(SpeechRecognizer())
        }
    }
}

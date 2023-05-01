import SwiftUI

struct ContentView: View {
    @State var increaseHeight: Bool = false
    @State var toast:ToastView? = nil
    @State var showSheet: Bool = false
    @State var tagSelect = "house"
    @State private var showLanguageSelection = true
    
    private var temperatureDataService = TemperatureDataService.sharedLocationService
    @EnvironmentObject private var speechRecognizer: SpeechRecognizer

    var body: some View {
            ZStack(alignment: .bottom) {
                TabView(selection: $tagSelect) {
                    MapScreen().tag("house").ignoresSafeArea()
                   
                    RecordingListView().tag("list.dash").ignoresSafeArea()
                }
                BottomBarView(toast: $toast, showSheet: $showSheet, tagSelect: $tagSelect)
            }
            .task {
                await temperatureDataService.fetchLatestTemperatures()
            }
            .toastView(toast: $toast)
            .sheet(isPresented: $showLanguageSelection) {
                LanguageSelectionView(isPresented: $showLanguageSelection)
                    .environmentObject(speechRecognizer)
            }
        }
    }

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            NavigationView {
                ContentView().environmentObject(VoiceNoteViewModel()).environmentObject(SpeechRecognizer())
            }
        }
    }
  







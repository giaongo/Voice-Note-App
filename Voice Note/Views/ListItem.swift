import SwiftUI
import MapKit

struct ListItem: View {
    @ObservedObject var voiceNote: VoiceNote
    @State private var isOptionMenu = false
    @State private var isDeleteAlert = false
    @State private var defaultSelect = "None"
    @State private var showDetail = false

    let buttonColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)

    @State var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
            latitudinalMeters: 2000,
            longitudinalMeters: 2000
    )

    var body: some View {
        NavigationLink{
            Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: [voiceNote]) { voiceNote in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: voiceNote.location?.latitude ?? 0, longitude: voiceNote.location?.longitude ?? 0)) {
                    Image(systemName: "waveform.circle")
                            .font(.system(size: 36))
                            .padding(10)
                            .background(Color(.systemGray6))
                            .clipShape(Circle())
                            .foregroundColor(Color(buttonColor))
                            .onTapGesture{
                                showDetail.toggle()
                            }
                }
            }.sheet(isPresented: $showDetail) {
                if let id = voiceNote.id {
                    DetailView(voiceNoteUUID: id)
                }
            }.onAppear{
                        region.center = CLLocationCoordinate2D(latitude: voiceNote.location?.latitude ?? 0,
                                longitude: voiceNote.location?.longitude ?? 0)
                        showDetail.toggle()
                    }
        } label: {
            VStack(alignment: .leading) {
                Spacer()
                Text(voiceNote.title ?? "").bold()
                Spacer()
                Text(voiceNote.text ?? "")
                Spacer()
                HStack(alignment: .center/*, spacing: 5*/) {
                    Text("Min: \(String(voiceNote.weather?.temperature?.minimum ?? 0))")
                    Text("Max: \(String(voiceNote.weather?.temperature?.maximum ?? 0))")
                    Spacer()
                    Text("\(Date.init().formatted(.iso8601.day().month().year()))")
                }
            }
        }
    }
}

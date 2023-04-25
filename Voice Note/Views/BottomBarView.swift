//
//  BottomBarView.swift
//  Voice Note
//
//  Created by Giao Ngo on 2.4.2023.
//

import SwiftUI
import NaturalLanguage

struct BottomBarView: View {
    @EnvironmentObject var voiceNoteViewModel: VoiceNoteViewModel
    @EnvironmentObject var speechRecognizer: SpeechRecognizer
    @Environment(\.coreData) var coreDataService: CoreDataService
    @Environment(\.managedObjectContext) var managedObjectContext

    @State var showConfirmationAlert: Bool = false
    @Binding var toast:ToastView?
    @Binding var showSheet: Bool
    @Binding var tagSelect: String
    let buttonColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
    let backgroundModalView = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 0.4915060081)
    
    var body: some View {
        VStack(spacing:0) {
            if showSheet {
                SlidingModalView(showSheet: $showSheet, toast: $toast)
            }
            // Custom bottom tab bar
            HStack {
                Spacer()
                
                // Home button
                Button {
                    tagSelect = "house"
                } label: {
                    VStack {
                        Image(systemName: "house")
                            .font(.system(size: 25))
                            .foregroundColor(Color(buttonColor))
                            .padding(.bottom, 15)
                    }
                }
                
                Spacer()
                
                // Microphone button
                VStack {
                    Button {
                        !voiceNoteViewModel.confirmTheVoiceNote ? clickAudioButton() : confirmToAddTheRecording()
                    } label: {
                        Image(systemName: "\(voiceNoteViewModel.isRecording ? "square.fill" : voiceNoteViewModel.confirmTheVoiceNote ? "checkmark" : "mic.fill")")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                    }
                    .tag("mic.fill")
                    .padding(.all, 20)
                    .background(
                        Circle()
                            .fill(Color(buttonColor))
                    )
                    .offset(y: -50)
                    .alert("Please confirm to save!", isPresented: $showConfirmationAlert) {
                        HStack {
                            Button("SAVE") {
                                saveVoiceNote()
                                voiceNoteViewModel.confirmTheVoiceNote = false
                                showSheet = false
                                toast = ToastView(type: .success, title: "Save Success", message: "Note saved successfully") {
                                    print("canceled pressed")
                                }
                            }
                            Button("CANCEL", role: .cancel) {
                                print("Cancel pressed")
                            }
                        }
                    }
                    
                    // Pause audio button
                    if voiceNoteViewModel.isMicPressed {
                        Button(action: {
                            if voiceNoteViewModel.isRecordingPaused {
                                voiceNoteViewModel.resumeRecording()
                            } else {
                                voiceNoteViewModel.pauseRecording()
                            }
                        }, label: {
                            Image(systemName: "\(voiceNoteViewModel.isRecordingPaused ? "play.fill" : "pause.fill")")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                        }).disabled(!voiceNoteViewModel.isRecording)
                            .padding(.all, 20)
                            .background(
                                Circle()
                                    .fill(Color(buttonColor))
                            )
                            .offset(y: -50)
                    }
                }
                
                Spacer()
                
                // Note list button
                Button {
                    tagSelect = "list.dash"
                } label: {
                    VStack {
                        Image(systemName: "list.dash")
                            .font(.system(size: 25))
                            .foregroundColor(Color(buttonColor))
                            .padding(.bottom, 15)
                    }
                }
                Spacer()
            }
            .background(
                VStack {
                    Divider()
                        .overlay(.black)
                    Spacer()
                }
                    .background(.white)
                    .frame(height: 100)
            )
        }.ignoresSafeArea(.all)
        
        
    }
    func extractKeywords(from text: String) -> [String] {
        let tagger = NLTagger(tagSchemes: [.lexicalClass])
        tagger.string = text
        let options: NLTagger.Options = [.omitWhitespace, .omitPunctuation, .joinNames]

        let tags = tagger.tags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .lexicalClass, options: options)

        let keywords = tags.compactMap { (tag, tokenRange) -> String? in
            if tag == .noun || tag == .verb || tag == .adjective {
                return String(text[tokenRange])
            }
            return nil
        }

        return keywords
    }

    func saveVoiceNote() {
        guard let url = voiceNoteViewModel.fileUrlList.last else {
            return
        }

        let durationInSeconds = voiceNoteViewModel.getDuration(for: url)
        let extractedKeywords = extractKeywords(from: speechRecognizer.transcriptionText)
        let title = extractedKeywords.first ?? "Note"



        let newVoiceNote = VoiceNote(context: managedObjectContext)
        newVoiceNote.id = UUID()
        newVoiceNote.text = speechRecognizer.transcriptionText
        newVoiceNote.title = title
        newVoiceNote.fileUrl = url
        newVoiceNote.createdAt = Date()
        newVoiceNote.duration = durationInSeconds
        newVoiceNote.location = Location(context: managedObjectContext)
        newVoiceNote.location?.latitude = 24.444
        newVoiceNote.location?.longitude = 64.444
        newVoiceNote.weather = Weather(context: managedObjectContext)
        newVoiceNote.weather?.temperature = Temperature(context: managedObjectContext)
        newVoiceNote.weather?.temperature?.average = 34
        newVoiceNote.weather?.temperature?.maximum = 44
        newVoiceNote.weather?.temperature?.minimum = 24

        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving voice note: \(error)")
        }
    }


    private func clickAudioButton() {
        voiceNoteViewModel.isRecording.toggle()
        voiceNoteViewModel.isMicPressed.toggle()
        if voiceNoteViewModel.isRecording {
            withAnimation {
                showSheet = true
            }
            speechRecognizer.reset()
            speechRecognizer.transcriptionText = ""
            voiceNoteViewModel.startRecording()
            
        } else {
            voiceNoteViewModel.stopRecording()
        }
    }
    
    private func confirmToAddTheRecording(){
        showConfirmationAlert = true
    }
}

struct BottomBarView_Previews: PreviewProvider {
    static var previews: some View {
        BottomBarView(
            toast: .constant(ToastView(type: .success, title: "Save Success", message: "Note saved successfully") {
                print("canceled pressed")
            }), showSheet: .constant(false),tagSelect: .constant("house"))
        .environmentObject(VoiceNoteViewModel())
        .environmentObject(SpeechRecognizer())
    }
}

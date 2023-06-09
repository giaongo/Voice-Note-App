import Foundation
import AVFoundation
import Combine
import CoreData
import NaturalLanguage

/**
    The ViewModel includes functionalities for  recording, playing back audio, and measuring power levels during the recording duration.
 */
class VoiceNoteViewModel: NSObject, ObservableObject, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    private var recordingPausedAt: TimeInterval = 0
    private var triggerMeteringInterval: TimeInterval = 0.01
    private var audioRecordingDuration: TimeInterval = 10.00
    private var timer: Timer?
    private var currentSample: Int = 0
    static let numberOfSample: Int = 14
    
    @Published var isRecording: Bool = false
    @Published var isRecordingPaused: Bool = false
    @Published var fileUrlList = [URL]()
    @Published var isMicPressed: Bool = false
    @Published var soundSamples: [Float] = [Float](repeating:.zero, count: VoiceNoteViewModel.numberOfSample)
    @Published var audioIsPlaying:Bool = false
    @Published var confirmTheVoiceNote: Bool = false
    @Published var voiceNotes: [URL] = []

    private var managedObjectContext = CoreDataService.localStorage.getManageObjectContext()
    private let temperatureService = TemperatureDataService.sharedLocationService


    override init () {
        super.init()
    }
    
    deinit {
        stopRecording()
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        isRecording = false
        confirmTheVoiceNote = true
        isMicPressed = false
    }
    
    /**
     Tells the delegate to set the isPlaying to false when the audio finishes playing.
     */
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        audioIsPlaying = false
    }
    
    func fetchVoiceNotes() {
            let fileManager = FileManager.default
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!

            do {
                let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
                voiceNotes = fileURLs.filter { $0.pathExtension == "m4a" }
            } catch {
                print("Error while fetching voice notes: \(error.localizedDescription)")
            }
        }
    
    func startRecording() {
        let recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Recording Setup Error: \(error.localizedDescription)")
        }
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YY 'at' HH:mm:ss"
        let formattedDate = dateFormatter.string(from: currentDate)
        let audioFileName = path.appendingPathComponent("VoiceNote:\(formattedDate).m4a")
        fileUrlList.append(audioFileName)
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFileName, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.prepareToRecord()
            audioRecorder?.record(forDuration: audioRecordingDuration)
            self.enableMicrophoneMonitoring()
            isRecording = true
        } catch {
            print("Error Setting Up Recorder \(error.localizedDescription)")
        }
    }
    func getDuration(for file: URL) -> TimeInterval {
        guard let player = try? AVAudioPlayer(contentsOf: file) else {
            return 0
        }
        return player.duration
    }

    
    func pauseRecording() {
        guard let recorder = audioRecorder else { return }
        recordingPausedAt = recorder.currentTime
        isRecordingPaused = true
        recorder.pause()
        objectWillChange.send()
    }
    
    func resumeRecording() {
        guard let recorder = audioRecorder else { return }
        isRecordingPaused = false
        recorder.record(atTime: recordingPausedAt)
        objectWillChange.send()
    }
    
    func stopRecording() {
        self.disableMicrophoneMonitoring()
        audioRecorder?.stop()
        isRecordingPaused = false
        objectWillChange.send()
    }

    /**
     This method gets the creation file date of the audio file
     */
    private func getFileDate(for file: URL) -> Date {
        if let attributes = try? FileManager.default.attributesOfItem(atPath: file.path) as [FileAttributeKey: Any],
           let creationDate = attributes[FileAttributeKey.creationDate] as? Date {
            return creationDate
        } else {
            return Date()
        }
    }
    
    /**
     This method refreshes and returns the average power of chanel 0 of audio recorder through every 0.01s time interval
     */
    private func enableMicrophoneMonitoring() {
        timer = Timer.scheduledTimer(withTimeInterval: triggerMeteringInterval, repeats: true, block: { timer in
            self.audioRecorder?.updateMeters()
            self.soundSamples[self.currentSample] = self.audioRecorder?.averagePower(forChannel: 0) ?? 0.0
            self.currentSample = (self.currentSample + 1) % VoiceNoteViewModel.numberOfSample
        })
    }
    
    /**
     Stops the timer from ever firing again and requests its removal from its run loop.
     */
    private func disableMicrophoneMonitoring() {
        timer?.invalidate()
    }
    
    func startPlaying (recordingUrl:URL?) {
        guard let recordingUrl = recordingUrl else {
            return
        }
        let audioPlayingSession = AVAudioSession.sharedInstance()
        do {
            try audioPlayingSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            audioPlayer = try AVAudioPlayer(contentsOf: recordingUrl)
            if let audioPlayer = audioPlayer {
                audioPlayer.delegate = self
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            }
            audioIsPlaying = true
        } catch {
            print("Error playing recording \(error.localizedDescription)")
        }
    }
    
    func stopPlaying(recordingUrl: URL?) {
        guard recordingUrl != nil else {
            return
        }
        audioPlayer?.stop()
        audioIsPlaying = false
    }

    func saveVoiceNote(UrlLocation url: URL, transcribedText text: String) async {
        do {
            let durationInSeconds = getDuration(for: url)
            let extractedKeywords = extractKeywords(from: text)
            let title = extractedKeywords.first ?? "Note"
            let currentLocation = LocationService.sharedLocationService.currentLocation

            let newVoiceNote = VoiceNote(context: managedObjectContext)

            let id = UUID()
            newVoiceNote.id = id
            newVoiceNote.text = text
            newVoiceNote.title = title
            newVoiceNote.fileUrl = url
            newVoiceNote.createdAt = Date()
            newVoiceNote.duration = durationInSeconds
            newVoiceNote.location = Location(context: managedObjectContext)
            newVoiceNote.location?.id = id
            newVoiceNote.location?.latitude = currentLocation.coordinate.latitude
            newVoiceNote.location?.longitude = currentLocation.coordinate.longitude

            guard let location = newVoiceNote.location else { return }
            let temperature = try await temperatureService.loadCurrentTemperature(atLocation: location)

            newVoiceNote.weather = Weather(context: managedObjectContext)
            newVoiceNote.weather?.temperature = Temperature(context: managedObjectContext)
            newVoiceNote.weather?.temperature = temperature

            do {
                try managedObjectContext.save()
            } catch {
                let nsError = error as NSError
                print("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        } catch {
            print("error fetching temperature. Error: \(error.localizedDescription)")
        }
    }

    /**
        This method extracts and returns list of keywords from  text transcription
     */
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

    func deleteRecording(url: URL) {
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("Error deleting recording \(error.localizedDescription)")
        }
    }
    
    func fetchTemperature(latitude: Double, longitude: Double, completion: @escaping (Double?) -> Void) {
            let apiKey = "c55b372ffdf9f6dcc3f535d009f52246"
            let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric")!

            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error fetching temperature: \(error)")
                    completion(nil)
                    return
                }

                guard let data = data else {
                    print("No data received.")
                    completion(nil)
                    return
                }

                do {
                    let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                    completion(weatherData.main.temp)
                } catch {
                    print("Error decoding JSON: \(error)")
                    completion(nil)
                }
            }
            task.resume()
        }
    
    struct WeatherData: Codable {
        let main: Main
    }

    struct Main: Codable {
        let temp: Double
    }
}

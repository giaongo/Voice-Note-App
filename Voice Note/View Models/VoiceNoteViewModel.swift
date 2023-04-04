import Foundation
import AVFoundation

class VoiceNoteViewModel: ObservableObject {
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    private var recordingPausedAt: TimeInterval = 0
    
    @Published var isRecording: Bool = false
    @Published var recordingList = [Recording]()
    @Published var fileUrlList = [URL]()
    
    init() {
        self.fetchAllRecordings()
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
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()
            
        } catch {
            print("Error Setting Up Recorder \(error.localizedDescription)")
        }
    }
    
    func pauseRecording() {
        guard let recorder = audioRecorder else { return }
        recordingPausedAt = recorder.currentTime
        recorder.pause()
        objectWillChange.send()
    }
    
    func resumeRecording() {
        guard let recorder = audioRecorder else { return }
        recorder.record(atTime: recordingPausedAt)
        objectWillChange.send()
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        objectWillChange.send()
    }
    
    private func fetchAllRecordings() {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let recordingsContent = try FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
            for url in recordingsContent {
                recordingList.append(Recording(fileUrl: url, createdAt: getFileDate(for: url), isPlaying: false, duration: getDuration(for: url)))
            }
        } catch {
            print("Error fetching all recordings \(error.localizedDescription)")
        }
    }
    
    private func getFileDate(for file: URL) -> Date {
        if let attributes = try? FileManager.default.attributesOfItem(atPath: file.path) as [FileAttributeKey: Any],
           let creationDate = attributes[FileAttributeKey.creationDate] as? Date {
            return creationDate
        } else {
            return Date()
        }
    }
    
    private func getDuration(for file: URL) -> TimeInterval {
        guard let player = try? AVAudioPlayer(contentsOf: file) else {
            return 0
        }
        return player.duration
    }
}

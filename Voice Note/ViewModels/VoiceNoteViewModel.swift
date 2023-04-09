//
// Created by Anwar Ulhaq on 1.4.2023, developed by Giao Ngo
// Learning resource on AVAudioRecorder and AVAudioPlayer:
// https://mdcode2021.medium.com/audio-recording-in-swiftui-mvvm-with-avfoundation-an-ios-app-6e6c8ddb00cc
// https://developer.apple.com/documentation/avfaudio/avaudiorecorder/1387176-averagepower
//

import Foundation
import AVFoundation

class VoiceNoteViewModel: NSObject, ObservableObject, AVAudioPlayerDelegate {
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    private var recordingPausedAt: TimeInterval = 0
    private var triggerMeteringInterval: TimeInterval = 0.01
    private var audioRecordingDuration: TimeInterval = 10.00
    private var timer: Timer?
    private var currentSample: Int = 0
    static let numberOfSample: Int = 15
    
    @Published var isRecording: Bool = false
    @Published var isRecordingPaused: Bool = false
    @Published var recordingList = [Recording]()
    @Published var fileUrlList = [URL]()
    @Published var isMicPressed: Bool = false
    @Published var soundSamples: [Float] = [Float](repeating:.zero, count: VoiceNoteViewModel.numberOfSample)
    @Published var audioIsPlaying:Bool = false
    @Published var confirmTheVoiceNote: Bool = false
    
    override init () {
        super.init()
        self.fetchAllRecordings()
    }
    
    deinit {
        stopRecording()
    }
    
    /**
     Tells the delegate to set the isPlaying to false when the audio finishes playing.
     */
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("function is called")
        if let newestRecordUrl = fileUrlList.last {
            var currentRecording = findTheCurrentRecording(recordingUrl: newestRecordUrl)
            currentRecording?.isPlaying = false
            audioIsPlaying = false
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
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.prepareToRecord()
            audioRecorder?.record(forDuration: audioRecordingDuration)
            self.enableMicrophoneMonitoring()
            isRecording = true
        } catch {
            print("Error Setting Up Recorder \(error.localizedDescription)")
        }
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
        self.disableMicriphoneMonitoring()
        audioRecorder?.stop()
        isRecording = false
        isRecordingPaused = false
        objectWillChange.send()
    }
    
    /**
     This method fetches all of the recordings from documentDirectory
     */
    private func fetchAllRecordings() {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let recordingsContent = try FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
            for url in recordingsContent {
                recordingList.append(Recording(id: UUID(), fileUrl: url, createdAt: getFileDate(for: url), isPlaying: false, duration: getDuration(for: url)))
            }
        } catch {
            print("Error fetching all recordings \(error.localizedDescription)")
        }
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
    
    private func getDuration(for file: URL) -> TimeInterval {
        guard let player = try? AVAudioPlayer(contentsOf: file) else {
            return 0
        }
        return player.duration
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
    private func disableMicriphoneMonitoring() {
        timer?.invalidate()
    }
    
    func startPlaying (recordingUrl:URL) {
        let audioPlayingSession = AVAudioSession.sharedInstance()
        do {
            try audioPlayingSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            audioPlayer = try AVAudioPlayer(contentsOf: recordingUrl)
            if let audioPlayer = audioPlayer {
                audioPlayer.delegate = self
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            }
            var currentRecording = findTheCurrentRecording(recordingUrl: recordingUrl)
            currentRecording?.isPlaying = true
            audioIsPlaying = true
        } catch {
            print("Error playing recording \(error.localizedDescription)")
        }
    }
    
    func stopPlaying(recordingUrl: URL) {
        audioPlayer?.stop()
        var currentRecording = findTheCurrentRecording(recordingUrl: recordingUrl)
        currentRecording?.isPlaying = false
        audioIsPlaying = false
    }
    func findTheCurrentRecording(recordingUrl: URL) -> Recording? {
        let foundRecording = recordingList.filter { recording in
            recording.fileUrl == recordingUrl
        }
        return foundRecording.count > 0 ? foundRecording[0] : nil
    }
}

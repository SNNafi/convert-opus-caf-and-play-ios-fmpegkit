//
//  ContentView.swift
//  PlayOpus
//
//  Created by Shahriar Nasim Nafi on 25/1/23.
//

import SwiftUI
// import MobileVLCKit
import ffmpegkit
import AVFoundation

struct ContentView: View {
    
   // let player = VLCMediaPlayer()
    @State var avPlayer: AVPlayer?
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            play()
        }
        
    }
    
    func play() {
        let opusPath = Bundle.main.path(forResource: "ayat_ul_kursi_16K_2C_16K", ofType: "opus")!
//        let media = VLCMedia(path: opusPath)
//        player.media = media
//        player.play()
        let fileManager = FileManager.default
        let folderURL = try! fileManager
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("audios", isDirectory: true)
        try! fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true)
        let cafFileURL = folderURL.appendingPathComponent("ayat_ul_kursi_16K_2C.caf")
        print(cafFileURL.absoluteURL)
        if !FileManager.default.fileExists(atPath: cafFileURL.path) {
            let session = FFmpegKit.execute("-i \"\(opusPath)\" -acodec copy \"\(cafFileURL.path)\"")
            if let code = session?.getReturnCode(), ReturnCode.isSuccess(code) {
                print("Success")
                print(session?.getCompleteCallback())
            } else {
                print(session?.getCompleteCallback())
            }
        }
        
        
        if FileManager.default.fileExists(atPath: cafFileURL.path) {
            avPlayer = AVPlayer(url: cafFileURL)
            avPlayer?.play()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

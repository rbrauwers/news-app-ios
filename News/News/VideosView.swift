//
//  VideosView.swift
//  News
//
//  Created by Rodrigo Brauwers on 15/01/24.
//

import Foundation
import AVKit
import SwiftUI

@available(iOS 17.0, *)
struct VideosList: View {
    
    private let videosData = [
        VideoData(id: 1, url: "https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_30mb.mp4"),
        VideoData(id: 2, url: "https://file-examples.com/wp-content/storage/2017/04/file_example_MP4_1920_18MG.mp4"),
        VideoData(id: 3, url: "https://download.samplelib.com/mp4/sample-5s.mp4"),
        VideoData(id: 4, url: "https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_30mb.mp4"),
        VideoData(id: 5, url: "https://file-examples.com/wp-content/storage/2017/04/file_example_MP4_1920_18MG.mp4"),
        VideoData(id: 6, url: "https://download.samplelib.com/mp4/sample-5s.mp4")
    ]
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 0.0) {
                ForEach(videosData) { videoData in
                    VideoView(videoData: videoData)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
    }
}

private struct VideoData : Identifiable {
    var id: Int
    let url: String
}

@available(iOS 17.0, *)
private struct VideoView: View {
    
    @State private var player: AVPlayer? = nil
    
    let videoData: VideoData
    
    var body: some View {
        //ZStack(alignment: .top) {
        ZStack {
            VideoPlayer(player: player)
                .onAppear {
                    if player == nil {
                        let _url = URL(string: videoData.url)!
                        player = AVPlayer(url: _url)
                        player?.isMuted = true
                    }
                    
                    player?.play()
                }
                .onDisappear {
                    player?.pause()
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 300, maxHeight: 300)

            Text("Video \(videoData.id)")
                .font(.title)
                .foregroundStyle(.orange)
        }
        .frame(minWidth: .zero, maxWidth: .infinity, minHeight: 300, maxHeight: 300)
    }
    
}

@available(iOS 17.0, *)
#Preview {
    VideosList()
}

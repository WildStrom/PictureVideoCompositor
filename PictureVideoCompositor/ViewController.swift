//
//  ViewController.swift
//  PictureVideoCompositor
//
//  Created by wildstorm on 2018/12/1.
//  Copyright © 2018年 stormWind. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import AVKit
import VFCabbage

class ViewController: UIViewController {

    var trackItems:Array<TrackItem> = Array()
    
    let resourceCnt = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTrackItems()
        
        initSubviews()
    }
    
    func initSubviews() {
        let playButton:UIButton = UIButton.init()
        self.view.addSubview(playButton)
        
        playButton.frame = CGRect.init(x: 150, y: 200, width: 100, height: 50)
        playButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        playButton.setTitle("播放", for: UIControl.State.normal)
        playButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        playButton.addTarget(self, action: #selector(onPlayTapped), for: UIControl.Event.touchUpInside)
       
        let exportButton:UIButton = UIButton.init()
        self.view.addSubview(exportButton)
        exportButton.frame = CGRect.init(x: 150, y: 300, width: 100, height: 50)
        exportButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        exportButton.setTitle("导出", for: UIControl.State.normal)
        exportButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        exportButton.addTarget(self, action: #selector(onExportTapped), for: UIControl.Event.touchUpInside)
    }

    @objc func onExportTapped() {
        
    }
    
    @objc func onPlayTapped() {
       let controller = AVPlayerViewController()
       controller.player = AVPlayer.init(playerItem: pictureTransitionPlayerItem())
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func loadTrackItems() {
        var index = 1
        while index <= resourceCnt {
            let imageTrackItem:TrackItem = {
                let url = Bundle.main.url(forResource: "\(index)", withExtension: "jpeg")
                let image = CIImage.init(contentsOf: url!)
                let resource = ImageResource.init(image: image!)
                resource.selectedTimeRange = CMTimeRangeMake(start:  CMTime(seconds: 0, preferredTimescale: 600), duration:  CMTime(seconds: 5, preferredTimescale: 600))
        
                let trackItem = TrackItem(resource: resource)
                trackItem.configuration.videoConfiguration.baseContentMode = .aspectFit
                return trackItem
            }()
            
            let transitionDuration = CMTime(seconds:2, preferredTimescale: 600)
            imageTrackItem.videoTransition = CrossDissolveTransition(duration: transitionDuration)
            imageTrackItem.audioTransition = FadeInOutAudioTransition(duration: transitionDuration)
            
            trackItems.append(imageTrackItem)
            index = index + 1
        }
    }
    
    func pictureTransitionPlayerItem() ->AVPlayerItem? {
        
        let timeline = Timeline()
        timeline.videoChannel = self.trackItems
        timeline.audioChannel = self.trackItems
        
        Timeline.reloadAudioStartTime(providers: timeline.audioChannel)
        Timeline.reloadVideoStartTime(providers: timeline.videoChannel)
        
        let compositionGenerator = CompositionGenerator(timeline:timeline)
        compositionGenerator.renderSize = CGSize(width: 320, height: 320)
        let playerItem = compositionGenerator.buildPlayerItem()
        return playerItem
    }
}


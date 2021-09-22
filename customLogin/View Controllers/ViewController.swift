//
//  ViewController.swift
//  customLogin
//
//  Created by Choyunje on 2021/09/16.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    
    var videoPlayer:AVPlayer?
    
    // 플레이어의 시각적 출력을 관리함.
    var videoPlayerLayer:AVPlayerLayer?
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 설정된 비디오 플레이어를 배경에 표시합니다.
        setUpVideo()
    }
    
    func setUpElements() {
        
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(loginButton)
        
    }
    
    func setUpVideo() {
        // 번들안에 있는 리소스의 경로를 불러오기
        let bundlePath = Bundle.main.path(forResource: "Clouds", ofType: "mp4")
        
       
        guard bundlePath != nil else {
            return
        }
        // 비디오로부터 url 생성하기
        let url = URL(fileURLWithPath: bundlePath!)

        // 비디어 플레이어 항목 생성하기
        let item = AVPlayerItem(url: url)
        
        // 플레이어 생성하기
        videoPlayer = AVPlayer(playerItem: item)
        
        // 레이어 생성하기
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer!)
        
        // 사이즈와 프레임 조정하기
        videoPlayerLayer?.frame = CGRect(x:
        -self.view.frame.size.width*1.5, y: 0, width:
             self.view.frame.size.width*4, height: self.view.frame.size.height)
        view.layer.insertSublayer(videoPlayerLayer!, at: 0)
        
        // 뷰를 추가하고 실행하기
        videoPlayer?.playImmediately(atRate: 0.8)
        
    }


}


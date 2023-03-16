//
//  HomeViewController.swift
//  musicPlayer
//
//  Created by Betty Pan on 2021/3/19.
//

import UIKit
import AVFoundation

class HomeViewController: UIViewController {
    
    @IBOutlet var newSongChartAlbumBtns: [UIButton]!
    @IBOutlet var newSongChartSongTitleLabels: [UILabel]!
    @IBOutlet var newSongChartSingerLabels: [UILabel]!
    
    
    @IBOutlet var recentlyPlayedPlayBtns: [UIButton]!
    @IBOutlet var recentlyPlayedImages: [UIImageView]!
    @IBOutlet var recentlyPlayedSongLabels: [UILabel]!
    @IBOutlet var recentlyPlayedSingerLabels: [UILabel]!
    
    
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var singerLabel: UILabel!
    
    
    @IBOutlet weak var durationControlSlider: UISlider!
    @IBOutlet weak var timePassLabel: UILabel!
    @IBOutlet weak var timeRemainLabel: UILabel!
    
    @IBOutlet weak var playBtn: UIButton!
    
    var player = AVPlayer()
    var recentlyPlayedArr = [Int]() //歷史播放清單
    var currentSongIndex = 1
    var songDuration:Double = 0
    
    let songs:[SongData] = [
        SongData(songTitle: "HAVE A NICE DAY", singer: "魏如萱", albumImage: UIImage(named: "魏如萱.jpg"),songUrl: Bundle.main.url(forResource: "haveANiceDay", withExtension: "mp3")!),
        SongData(songTitle: "ON THE GROUND", singer: "ROSÉ", albumImage: UIImage(named: "ROSÉ.jpg"),songUrl: Bundle.main.url(forResource: "onTheGround", withExtension: "mp3")!),
        SongData(songTitle: "BEAUTIFUL MISTAKES", singer: "Maroon 5, Megan Thee Stallion", albumImage: UIImage(named: "Maroon5,MeganTheeStallion.jpg"),songUrl: Bundle.main.url(forResource: "beautiful-mistakes", withExtension: "mp3")!),
        SongData(songTitle: "愛我的時候", singer: "周興哲", albumImage: UIImage(named: "截圖.png"),songUrl: Bundle.main.url(forResource: "愛我的時候", withExtension: "mp3")!),
        SongData(songTitle: "甘蔗掰掰", singer: "艾薇", albumImage: UIImage(named: "不要吵架.jpg"),songUrl: Bundle.main.url(forResource: "甘蔗掰掰", withExtension: "mp3")!)
    
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setChartViewInfo()
        setSongDurationLabel()
        
        //隱藏recentlyPlayed PlayBtns
        for i in recentlyPlayedPlayBtns{
            i.isHidden = true
        }
        
        //循環播放音樂
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: .main) { (_) in
            self.playNextSong()
        }
    }
    
    //排行榜導入歌曲資訊
    func setChartViewInfo() {
        for (i,_) in songs.enumerated() {
            newSongChartAlbumBtns[i].setImage(songs[i].albumImage, for: .normal)
            newSongChartSongTitleLabels[i].text = songs[i].songTitle
            newSongChartSingerLabels[i].text = songs[i].singer
        }
    }
    //設置音樂時間label,slider.Value
    func setSongDurationLabel() {
        player.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 1), queue: DispatchQueue.main) { (CMTime) in 
            if self.player.timeControlStatus == .playing {
                //set Slider
                let currentTime = self.player.currentTime().seconds
                self.durationControlSlider.value = Float(currentTime)
                //set Label
                self.timePassLabel.text = self.timeFormat(time: currentTime)
                self.timeRemainLabel.text = "-\(self.timeFormat(time: self.songDuration - currentTime))"
            }
        }
    }
    //音樂時間轉換（總秒數轉 "分鐘:秒數"）
    func timeFormat(time:Double)->String{
        let resultTime = Int(time).quotientAndRemainder(dividingBy: 60)
        return "\(resultTime.quotient):\(String(format: "%.2d", resultTime.remainder))"
    }
    
    //播放歌曲(單曲)
    func playSong(index:Int) {
        let playerItem = AVPlayerItem(url: songs[index].songUrl)
        player.replaceCurrentItem(with: playerItem)
        songDuration = playerItem.asset.duration.seconds //取得音樂時間
        player.play()
        
        albumImageView.image = songs[index].albumImage
        songLabel.text = songs[index].songTitle
        singerLabel.text = songs[index].singer
        
        setSliderMinMax()
    }
    //設置Slider MaximumValue
    func setSliderMinMax() {
//        durationControlSlider.maximumValue = Float(songDuration)
        durationControlSlider.isContinuous = true
        //.isContinuous: T:滑動間，音樂停止 F:滑動時，音樂持續播放直到滑動完後執行動作。
    }
    //播放下一首歌歌曲
    func playNextSong(){
        currentSongIndex += 1
        if currentSongIndex == recentlyPlayedArr.count {
            currentSongIndex = 0
        }
        
        let playerItem = AVPlayerItem(url: songs[recentlyPlayedArr[currentSongIndex]].songUrl)
        player.replaceCurrentItem(with: playerItem)
        player.play()
        
        albumImageView.image = songs[recentlyPlayedArr[currentSongIndex]].albumImage
        songLabel.text = songs[recentlyPlayedArr[currentSongIndex]].songTitle
        singerLabel.text = songs[recentlyPlayedArr[currentSongIndex]].singer
    }
    //播放前一首歌曲
    func playPrevSong(){
        currentSongIndex -= 1
        if currentSongIndex == -1 {
            currentSongIndex = recentlyPlayedArr.count-1
        }
        
        let playerItem = AVPlayerItem(url: songs[recentlyPlayedArr[currentSongIndex]].songUrl)
        player.replaceCurrentItem(with: playerItem)
        player.play()
        
        albumImageView.image = songs[recentlyPlayedArr[currentSongIndex]].albumImage
        songLabel.text = songs[recentlyPlayedArr[currentSongIndex]].songTitle
        singerLabel.text = songs[recentlyPlayedArr[currentSongIndex]].singer
        
    }
    //設置歷史播放清單
    func addSongIntoRecentlyPlayed() {
        for (i,_) in recentlyPlayedArr.enumerated(){
            recentlyPlayedImages[i].image = songs[recentlyPlayedArr[i]].albumImage
            recentlyPlayedSongLabels[i].text = songs[recentlyPlayedArr[i]].songTitle
            recentlyPlayedSingerLabels[i].text = songs[recentlyPlayedArr[i]].singer
            recentlyPlayedPlayBtns[i].isHidden = false
        }
    }
    //控制音樂：播放/暫停
    func playPause() {
        if player.timeControlStatus == .playing{
            player.pause()
            playBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }else{
            player.play()
            playBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    
    
    @IBAction func playSongFromChart(_ sender: UIButton) {
        if let number = newSongChartAlbumBtns.firstIndex(of: sender) {
            if recentlyPlayedArr.count == 5 {
                recentlyPlayedArr.removeLast()
            }
            
            playSong(index: number)
            recentlyPlayedArr.insert(number, at: 0) //每次增加都從第0開始
            addSongIntoRecentlyPlayed()
            
            playBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            
            for i in recentlyPlayedPlayBtns{
                i.setImage(UIImage(systemName: "play.circle"), for: .normal)
            }
        }
    }
    
    @IBAction func playSongFromRecentlyPlayed(_ sender: UIButton) {
        if let num = recentlyPlayedPlayBtns.firstIndex(of: sender){
            playSong(index:recentlyPlayedArr[num]) //讀取歷史播放array裡資訊
            
            //迴圈: 設置播放/暫停image（按下之按鍵為pause圖示，其餘為play圖示）
            for (i,_) in recentlyPlayedArr.enumerated(){
                if i == num {
                    recentlyPlayedPlayBtns[i].setImage(UIImage(systemName: "pause.circle"), for: .normal)
                }else{
                    recentlyPlayedPlayBtns[i].setImage(UIImage(systemName: "play.circle"), for: .normal)
                }
            }
            playBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    
    @IBAction func doPlayPause(_ sender: Any) {
        playPause()
    }
    
    @IBAction func nextSong(_ sender: Any) {
        playNextSong()
    }
    
    @IBAction func prevSong(_ sender: Any) {
        playPrevSong()
    }
    
    @IBAction func controlSongDuration(_ sender: UISlider) {
        let time = CMTime(value: CMTimeValue(sender.value), timescale: 1)
        player.seek(to: time) //seek(找尋): 找尋音樂區段
    }
    
    
}

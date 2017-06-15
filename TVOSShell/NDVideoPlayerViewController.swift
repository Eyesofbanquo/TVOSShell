//
//  NDVideoPlayerViewController.swift
//  TVOSShell
//
//  Created by Markim on 6/12/17.
//  Copyright © 2017 Markim. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NDVideoPlayerViewController: UIViewController {
  
  @IBOutlet weak var play: NDVideoPlayerControl!
  @IBOutlet weak var restart: NDVideoPlayerControl!
  @IBOutlet weak var favorite: NDVideoPlayerControl!
  
  @IBOutlet weak var backgroundImage: UIImageView!
  
  @IBOutlet weak var video_title: UILabel!
  @IBOutlet weak var date: UILabel!
  @IBOutlet weak var duration: UILabel!
  @IBOutlet weak var video_description: UILabel!
  
  var time: (Int, Int)!
  
  var video: Video!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    time = video.getTime()
    
    if time.0 > 0 {
      duration.text = "\(time.0) minutes and \(time.1) seconds"
    } else {
      duration.text = "\(time.1) seconds"
    }
    
    
    let index = video.date.index(video.date.startIndex, offsetBy: 19)
    let dateString = video.date.substring(to: index)
    print(dateString)
    
    
    let RFC3339DateFormatter = DateFormatter()
    RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
    RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    
    let date = RFC3339DateFormatter.date(from: dateString)
    RFC3339DateFormatter.dateFormat = "MMM d, yyyy"
    let newDate = RFC3339DateFormatter.string(from: date!)
    
    self.video_title.text = video.title
    self.date.text = newDate
    self.video_description.text = video.caption
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  private func createVideoURL() -> String{
    let urlString = "https://stage-swatv.wieck.com/api/v1/videos/\(video.id)/720p"
    
    var urlComponents:URLComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "stage-swatv.wieck.com"
    urlComponents.path = "/api/v1/videos/\(video.id)"
    let videoURL = urlComponents.url!
    
    var videoURLString: String?
    
    Alamofire.request(urlComponents).responseJSON(completionHandler: {
      response in
      switch response.result {
      case .success(_):
        let json = JSON(data: response.data!)
        let downloads = json["downloads"]
        if downloads["source"] != JSON.null {
          videoURLString = downloads["source"]["uri"].stringValue
        } else if downloads["720p"] != JSON.null {
          videoURLString = downloads["720p"]["uri"].stringValue
        }
      case .failure(_):
        break
      }
    })
    
    guard let vString = videoURLString else { return "" }
    return vString
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}

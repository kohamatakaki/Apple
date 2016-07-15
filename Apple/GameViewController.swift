//
//  GameViewController.swift
//  Apple
//
//  Created by 小浜天紀 on 2016/06/10.
//  Copyright © 2016年 小浜天紀. All rights reserved.
//

import UIKit
import CoreMotion

class GameViewController: UIViewController {
    @IBOutlet var kagoImageView: UIImageView!
    @IBOutlet var caughtAppleLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    var timer: NSTimer!
    var gametime: Float = 10.0
    
    var appleLabel: UILabel!
    var appleImageView: UIImageView!
    var caughtAppleCount: Int = 0
    var appleTime: CGFloat = 0.0
    
    var motionManager = CMMotionManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector
            (GameViewController.down(_:)), userInfo: nil, repeats: true)
        
        timeLabel.text = String(time)
        
        appleImageView = UIImageView(frame: CGRectMake(100, 100, 50, 50))
        appleImageView.image = UIImage(named: "fruit_ringo.png")
        self.view.addSubview(appleImageView)
        
        self.startAccelerometer()

        // Do any additional setup after loading the view.
    }
    
    //加速度を取得する関数
    func startAccelerometer() {
        let screenSize = UIScreen.mainScreen().bounds.size
        var speedX: Double = 0.0
        let posY = self.kagoImageView.frame.origin.y + self.kagoImageView.bounds.height/2
        
        motionManager = CMMotionManager()
        motionManager.accelerometerUpdateInterval = 0.02
        
        
        //取得開始
        motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!,
            withHandler: {(data: CMAccelerometerData?, error: NSError?) -> Void in
                
                guard let data = data else {
                    return
                }
                
                speedX += data.acceleration.x
                
                var posX = self.kagoImageView.center.x + (CGFloat(speedX) / 3)
                
                if posX <= self.kagoImageView.frame.width / 2 {
                    speedX = -1 * speedX / 2
                    posX = self.kagoImageView.frame.width / 2
                }
                if posX >= screenSize.width - self.kagoImageView.frame.width / 2 {
                    speedX = -1 * speedX / 2
                    posX = screenSize.width - self.kagoImageView.frame.width / 2
                }
                
                if CGRectIntersectsRect(self.appleImageView.frame,self.kagoImageView.frame) {
                    self.caughtAppleCount += 1
                    self.caughtAppleLabel.text = String(self.caughtAppleCount)
                    self.reset()
                }
                
                self.kagoImageView.center = CGPointMake(posX, posY)
        })
    
    }
    
    func down(timer: NSTimer) {
        gametime -= 0.01
        appleTime += 0.01
        
        let str = String(format: "%.1f", gametime)
        timeLabel.text = String(str)
        
        if gametime <= 0 {
            timeLabel.text = String(0.0)
            timer.invalidate()
            performSegueToResult()
            
            let resultViewController: ResultViewController = self.storyboard?.instantiateViewControllerWithIdentifier("resultVC") as! ResultViewController ;resultViewController.caughtAppleCount = self.caughtAppleCount
            self.presentViewController(resultViewController, animated: true, completion: nil)
        }
        
        appleImageView.center.y = CGFloat(9.8*appleTime*appleTime*15+100)
        
        if self.appleImageView.frame.origin.y >= self.view.frame.size.height {
            reset()
        }
    }
    
    func performSegueToResult() {
        performSegueWithIdentifier("ResultVC", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ResultVC" {
            let resultViewController = segue.destinationViewController as!
            ResultViewController
            resultViewController.caughtAppleCount = self.caughtAppleCount
        }
    }
    
    func reset() {
        self.appleImageView.removeFromSuperview()
        appleTime = 0.00
        appleImageView.center.y = CGFloat(9.8*appleTime*appleTime*15+100)
        appleImageView.center.x = CGFloat(CGFloat(arc4random_uniform(UInt32(self.view.bounds.width + 50))))
        self.view.addSubview(self.appleImageView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*r
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

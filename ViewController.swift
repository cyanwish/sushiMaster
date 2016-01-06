//
//  ViewController.swift
//  swift_uebung_2
//
//  Created by  on 13.10.15.
//  Copyright © 2015 htw-berlin.de. All rights reserved.
//

import UIKit

class ViewController: UIViewController{

    @IBOutlet weak var slider: UISlider!;
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startGameButton: UIButton!;
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var bentoboxView: UIView!
    
    var timer: NSTimer!;
    var counter = 0;
    let gametime = 120;
    var half_image: CGFloat!;
    var money = 0;
    var gameover = false;
    
    let objectHeight : CGFloat = 50;
    let objectWidth : CGFloat = 50;
    
    let sushiSticks = UIImage(named: "chop.png");
    let sushiSticksView: UIImageView;
    
    let blackSushi = UIImage(named: "black_sushi.jpg");
    let yellowSushi = UIImage(named: "yellow_sushi.jpg");
    let orangeSushi = UIImage(named: "orange_sushi.jpg");
    
    var blackFilled = false;
    var yellowFilled = false;
    var orangeFilled = false;
    
    var bentoArray : [UIImageView] = [];
    
    required init?(coder aDecoder: NSCoder){
        sushiSticksView = UIImageView(frame:CGRectMake(0, 0, objectWidth, objectHeight));
        //bentoboxView = UIView(frame : CGRectMake(10, 10, objectWidth - 200, objectHeight - 50));
        sushiSticksView.image = sushiSticks;
        
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad(){
        super.viewDidLoad();
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.blackColor();
        moneyLabel.hidden = true;
        timerLabel.hidden = true;
        bentoboxView.hidden = true;
        half_image = sushiSticksView.bounds.width / 2;
        sushiSticksView.center.x = 0.5 * (UIScreen.mainScreen().bounds.width - half_image * 2) + half_image;
        sushiSticksView.center.y = slider.center.y;
        startGameButton.setTitle("Start", forState: .Normal);
        startGameButton.setTitleColor(UIColor.whiteColor(), forState: .Normal);
        slider.hidden = true;
        slider.continuous = true;
        slider.setThumbImage(UIImage(named:"custom_thumb.png"), forState: .Normal);
        slider.setMinimumTrackImage(UIImage(), forState: .Normal);
        slider.setMaximumTrackImage(UIImage(), forState: .Normal);

    }

    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning();
        // Dispose of any resources that can be recreated.
    }
    
    func refreshOnEverySecond() {
        counter++;
        timerLabel.text = "\((gametime - counter)) Sekunden";
        if(counter == gametime || self.money <= -600) {
            gameIsEnding();
        }
    }
    
    func createRandomSushi() -> UIImageView {
        let random = Int(arc4random_uniform(3) + 1);
        let randomX = Int(arc4random_uniform(UInt32(UIScreen.mainScreen().bounds.width - 80)) + 1);
        let randomSushiView = UIImageView(frame: CGRectMake(CGFloat(randomX), 0, 40, 40));
        if(random == 1){
            randomSushiView.image = blackSushi!;
            randomSushiView.tag = 1;
        }
        if(random == 2){
            randomSushiView.image = yellowSushi!;
            randomSushiView.tag = 2;
        }
        if(random == 3){
            randomSushiView.image = orangeSushi!;
            randomSushiView.tag = 3;
        }
        return randomSushiView;
    }
    
    func animateSushi(sushi: UIImageView){
        self.view.addSubview(sushi);
        UIView.animateWithDuration(3, delay: 0, options: [.CurveEaseIn],
        
            animations: {
                sushi.center.y = self.sushiSticksView.center.y - (self.objectHeight / 2) - 10;

            }, completion: { finished in
                if(finished) {
                    if(((sushi.frame.origin.x <= self.sushiSticksView.frame.origin.x && sushi.frame.origin.x + sushi.frame.width <= self.sushiSticksView.frame.origin.x + self.sushiSticksView.frame.width && sushi.frame.origin.x + sushi.frame.width >= self.sushiSticksView.frame.origin.x)
                        ||
                       (sushi.frame.origin.x + sushi.frame.width >= self.sushiSticksView.frame.origin.x + self.sushiSticksView.frame.width && sushi.frame.origin.x >= self.sushiSticksView.frame.origin.x && sushi.frame.origin.x <= self.sushiSticksView.frame.origin.x + self.sushiSticksView.frame.width)
                        || (sushi.frame.origin.x >= self.sushiSticksView.frame.origin.x && sushi.frame.origin.x + sushi.frame.width <= self.sushiSticksView.frame.origin.x + self.sushiSticksView.frame.width)
                         ) && !self.gameover){
                            if(sushi.tag == 1){
                                if(!self.blackFilled) {
                                    self.blackFilled = true;
                                    self.animateBentobox(sushi);
                                    self.bentoArray.append(sushi);
                                } else {
                                    sushi.removeFromSuperview();
                                }
                            }
                            if(sushi.tag == 2){
                                if(!self.yellowFilled){
                                    self.yellowFilled = true;
                                    self.animateBentobox(sushi);
                                    self.bentoArray.append(sushi);
                                } else {
                                    sushi.removeFromSuperview();
                                }
                            }
                            if(sushi.tag == 3){
                                if(!self.orangeFilled){
                                    self.orangeFilled = true;
                                    self.animateBentobox(sushi);
                                    self.bentoArray.append(sushi);
                                } else {
                                    sushi.removeFromSuperview();
                                }
                            }
                            if(self.blackFilled && self.yellowFilled && self.orangeFilled && !self.gameover){
                                self.money += 1100;
                                self.blackFilled = false;
                                self.yellowFilled = false;
                                self.orangeFilled = false;
                                self.delay(1.5){
                                    for _ in 0...2 {
                                        if(!self.bentoArray.isEmpty){
                                            self.bentoArray[0].removeFromSuperview();
                                            self.bentoArray.removeFirst();
                                        }
                                    }
                                };
                            }
                    } else {
                        self.animateSushiFail(sushi);
                        if(!self.gameover){
                            self.money -= 300;
                        }
                    }
                    self.moneyLabel.text = "\(self.money)$";
                    self.delay(self.random(0.1, 2.0)){
                        if(!self.gameover){
                            self.animateSushi(self.createRandomSushi());
                        }
                    }
                }
            });
    }
    
    func animateSushiFail(sushi : UIImageView){
        UIView.animateWithDuration(0.5, delay: 0, options: [.CurveLinear],
            
            animations: {
                sushi.center.y = self.sushiSticksView.center.y + 50;
            
            }, completion: { finished in
                if(finished) {
                    let lostMoneyLabel = self.getLostMoneyLabel();
                    lostMoneyLabel.center.x = sushi.center.x;
                    lostMoneyLabel.center.y = self.sushiSticksView.center.y + 20;
                    self.view.addSubview(lostMoneyLabel);
                    self.animateLostMoney(lostMoneyLabel);
                    sushi.removeFromSuperview();
                }
        });
    }
    
    func animateLostMoney(label : UILabel){
        UIView.animateWithDuration(1.5, delay: 0, options: [.CurveLinear],
            
            animations: {
                label.center.y = self.sushiSticksView.center.y - 50;
                
            }, completion: { finished in
                if(finished) {
                    label.removeFromSuperview();
                }
        });
    }
    
    func animateBentobox(sushi : UIImageView){
        UIView.animateWithDuration(1, delay: 0, options: [.CurveLinear],
            
            animations: {
                sushi.center.y = self.bentoboxView.center.y;
                sushi.center.x = self.bentoboxView.center.x + (25 * CGFloat(sushi.tag)) - 50;
                sushi.transform = CGAffineTransformMakeScale(0.5, 0.5);
                
            }, completion: { finished in
                if(finished) {
                    //self.view.bringSubviewToFront(sushi);
                }
        });
    }
    
    func gameIsEnding(){
        timer.invalidate();
        gameover = true;
        if(counter == gametime){
            timerLabel.text = "Zeit abgelaufen!";
        } else {
            timerLabel.text = "GameOver!";
        }
        counter = 0;
        self.bentoArray.removeAll()
        blackFilled = false;
        yellowFilled = false;
        orangeFilled = false;
        bentoboxView.hidden = true;
        startGameButton.setTitle("Neustart", forState: .Normal);
        self.view.backgroundColor = UIColor.blackColor();
        timerLabel.textColor = UIColor.whiteColor();
        moneyLabel.textColor = UIColor.whiteColor();
        slider.hidden = true;
        startGameButton.hidden = false;
        for view:UIView in self.view.subviews {
            if view.isKindOfClass(UIImageView) {
                view.removeFromSuperview();
            }
        }

    }
    
    @IBAction func startGameButton(sender: UIButton){
        self.view.backgroundColor = UIColor.whiteColor();
        startGameButton.hidden = true;
        slider.hidden = false;
        slider.thumbTintColor = UIColor.clearColor();
        moneyLabel.hidden = false;
        timerLabel.hidden = false;
        moneyLabel.textColor = UIColor.blackColor();
        timerLabel.textColor = UIColor.blackColor();
        bentoboxView.hidden = false;
        bentoboxView.backgroundColor = UIColor.whiteColor();
        bentoboxView.layer.borderColor = UIColor.blackColor().CGColor;
        bentoboxView.layer.borderWidth = 3.0;
        self.money = 0;
        moneyLabel.text = "\(money)$";
        if(timer != nil){
            timer.invalidate();
        }
        for _ in 1...3 {
            delay(self.random(0.1, 2.0)){
                self.animateSushi(self.createRandomSushi());
            }
        }
        
        gameover = false;
        self.view.addSubview(sushiSticksView);
        //self.view.addSubview(bentoboxView);
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "refreshOnEverySecond", userInfo: nil, repeats: true);
    }

    @IBAction func sliderValueChanged(sender: UISlider){
            sushiSticksView.center.x = CGFloat(sender.value) * (UIScreen.mainScreen().bounds.width - half_image * 2) + half_image;
    }
    
    func getLostMoneyLabel() -> UILabel {
        let lostMoney = UILabel(frame: CGRectMake(0, 0, 200, 21));
        lostMoney.text = "-300$";
        lostMoney.textColor = UIColor.redColor();
        lostMoney.textAlignment = NSTextAlignment.Center;
        return lostMoney;
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func random(lower: Double = 0, _ upper: Double = 100) -> Double {
        return (Double(arc4random()) / 0xFFFFFFFF) * (upper - lower) + lower
    }
    
}

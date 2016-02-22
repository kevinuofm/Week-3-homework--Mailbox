//
//  MailboxViewController.swift
//  Mailbox
//
//  Created by Kevin Zhu on 2/20/16.
//  Copyright © 2016 Kevin Zhu. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController,UIGestureRecognizerDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var listView: UIImageView!
    
    @IBOutlet weak var rescheduleView: UIImageView!
    
    @IBOutlet weak var messageView: UIView!
    
    @IBOutlet weak var feedView: UIImageView!
    
    @IBOutlet weak var laterIcon: UIImageView!
    
    @IBOutlet weak var archiveIcon: UIImageView!
    
    @IBOutlet weak var everythingElseView: UIView!
    
    @IBOutlet weak var MenuView: UIImageView!
    
    
    var MessageInitialFrame: CGPoint!

    var laterIconInitialFrame: CGPoint! // initial point of laterIcon
    
    var archiveIconInitialFrame: CGPoint! // initial point of archive Icon
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.contentSize = CGSize(width: 320, height: 1000)
        
        
        //for edge gesture, this calls onEdgePan method, way at the bottom.
        var edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "onEdgePan:")
        edgeGesture.edges = UIRectEdge.Left
        everythingElseView.addGestureRecognizer(edgeGesture)
        

        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didPan(sender: UIPanGestureRecognizer) {
        
        // this sets the variable "translation"
        let translation = sender.translationInView(view)
        
        
        if sender.state == UIGestureRecognizerState.Began { // this is executed at the beginning of the pan
           
            MessageInitialFrame = messageView.frame.origin  // sets the initial frame position
            
            laterIconInitialFrame = laterIcon.frame.origin // sets the initial position of the later icon
            
            archiveIconInitialFrame = archiveIcon.frame.origin // sets the initial position of the archive icon
            
            print("latericon initial frame is:",laterIconInitialFrame)
            laterIcon.alpha = 0.5
            
            
        } else if sender.state == UIGestureRecognizerState.Changed {  // this is called continuously as the pan happens
            
            print("translation is: ", translation)
            
            messageView.frame.origin.x = CGFloat(MessageInitialFrame.x + translation.x) // sets the new position to the new translated position
            
            if messageView.frame.origin.x > -60 && messageView.frame.origin.x < 60 {
                
                
                // this calculates the fading of the icon as you slide across, as a percent of the movement.
                var iconAlpha:CGFloat!
                iconAlpha = abs(translation.x) / 60
                
                laterIcon.alpha = iconAlpha
                archiveIcon.alpha = iconAlpha
                
                //this code changes the background color
                scrollView.backgroundColor = UIColor.grayColor()
                
                print ("gray stage")
                print ("alpha is", iconAlpha)

                
            } else if messageView.frame.origin.x > -260 && messageView.frame.origin.x < -60 {
                
                //this code changes the background color
                scrollView.backgroundColor = UIColor.yellowColor()
                
                
                //moves the "later" icon with sliding...
                
                laterIcon.frame.origin.x = CGFloat(laterIconInitialFrame.x + translation.x + 60)
                
                
                print("yellow stage")
                print("latericon.frame.origin.x is ", laterIcon.frame.origin.x)
            
            } else if messageView.frame.origin.x > -320 && messageView.frame.origin.x < -260 {
                
                //moves the "later" icon with sliding...

                laterIcon.frame.origin.x = CGFloat(laterIconInitialFrame.x + translation.x + 60)
                
                print("brown stage")
                
                //this code changes the background color
                scrollView.backgroundColor = UIColor.brownColor()
                
            } else if messageView.frame.origin.x > 60 && messageView.frame.origin.x < 260 {
                
                // if gesture ended in the green zone...
                
                print("green stage")
                
                // moves the archive icon with sliding
                archiveIcon.frame.origin.x = CGFloat(archiveIconInitialFrame.x + translation.x - 60)
                
                //changes the color to green
                scrollView.backgroundColor = UIColor.greenColor()
            
                
            } else if messageView.frame.origin.x > 260 && messageView.frame.origin.x < 320 {
            
            // if gesture ended in the red zone...
            
            print("red stage")
            
                
            // moves the archive icon with sliding
            archiveIcon.frame.origin.x = CGFloat(archiveIconInitialFrame.x + translation.x - 60)
            
            //changes color to red
            scrollView.backgroundColor = UIColor.redColor()
            
            
            }
        
        
        } else if sender.state == UIGestureRecognizerState.Ended {
            
            
            //if gesture ended in the gray zone....
            
            if messageView.frame.origin.x > -60 && messageView.frame.origin.x < 60 {
                
                UIImageView.animateWithDuration(0.3, animations: { () -> Void in
                    self.messageView.frame.origin.x = 0 // the slider goes back to original
                })
                print ("gray stage")
        
                
            // if gesture ended in the yellow zone...
                
            } else if messageView.frame.origin.x > -260 && messageView.frame.origin.x < -60 {
                
                print("yellow stage")
                
                UIImageView.animateWithDuration(0.3, animations: { () -> Void in
                    self.messageView.frame.origin.x = -320; // swipes the yellow band to the left
                    
                })
                
                UIImageView.animateWithDuration(1.3, animations: { () -> Void in
                    self.rescheduleView.alpha = 1  //makes the reschedule screen appear

                })
                
            // if gesture ended in the gray zone...
                
            } else if messageView.frame.origin.x > -320 && messageView.frame.origin.x < -260 {
                
                print("brown stage")
                
                UIImageView.animateWithDuration(0.3, animations: { () -> Void in
                    self.messageView.frame.origin.x = -320;
                    self.listView.alpha = 1
                })
                
            } else if messageView.frame.origin.x > 60 && messageView.frame.origin.x < 260 {

                // if gesture ended in the green zone...

                print("green stage")
                
                //shrinks the message and moves up feed
                UIImageView.animateWithDuration(0.3, animations: { () -> Void in
                    self.messageView.frame.origin.x = 320; // swipes the green band to the right
                    self.messageView.frame.size.height = 0
                    self.feedView.frame.origin.y = 138
                    
                })
                
            } else if messageView.frame.origin.x > 260 && messageView.frame.origin.x < 320 {
                
                // if gesture ended in the red zone...
                
                print("red stage")
                
                //shrinks the message and moves up feed
                UIImageView.animateWithDuration(0.3, animations: { () -> Void in
                    self.messageView.frame.origin.x = 320; // swipes the red band to the right
                    self.messageView.frame.size.height = 0
                    self.feedView.frame.origin.y = 138
                    
                })
                
            }
            
        }

    }
    
    @IBAction func didTap(sender: UITapGestureRecognizer) {
        
        //hides the reschedule screen
        self.rescheduleView.alpha = 0
        self.messageView.frame.origin.x = 0;
        
        // this code animates the shrinking of the first message upon dismissal
        UIImageView.animateWithDuration(0.3) { () -> Void in
            self.messageView.frame.size.height = 0
            self.feedView.frame.origin.y = 138

        }
        
        print("tapped")
    }
    

    @IBAction func didTapList(sender: UITapGestureRecognizer) {
        
        //hides the list view screen
        self.listView.alpha = 0
        self.messageView.frame.origin.x = 0
    }
    
    

    
    // this is what happens when the user pans from left, called from the method way at the top.
    func onEdgePan(sender: UIPanGestureRecognizer) {
        
        //defines the translation amount of the slide
        let everythingSlide = sender.translationInView(view)
        
        //moves everything according to translation
        everythingElseView.frame.origin.x = everythingSlide.x
        
        
        let slideVelocity = sender.velocityInView(view)
        
        
        

        
        
        if sender.state == UIGestureRecognizerState.Changed {
            self.everythingElseView.frame.origin.x = everythingSlide.x
            
        } else if sender.state == UIGestureRecognizerState.Ended {        // when the user lifts finger....

            
            if slideVelocity.x > 0 {
              
                UIImageView.animateWithDuration(0.3, animations: { () -> Void in
                    self.everythingElseView.frame.origin.x = 300

                })
                
            } else if slideVelocity.x < 0 {
                UIImageView.animateWithDuration(0.3, animations: { () -> Void in
                    self.everythingElseView.frame.origin.x = 0
                    
                })

            }
            
            
        }
        
        
        print("finally did pan edge!!!!!!!!!!!!!!!!!")
        
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}

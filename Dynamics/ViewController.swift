
//  Dynamics
//
//  Created by Alex Gibson 8/20/2015

import UIKit

class ViewController: UIViewController,UICollisionBehaviorDelegate {


    @IBOutlet weak var selectedCategoriesLabel: UILabel!
    var animators : NSMutableDictionary!
    var gravities : NSMutableDictionary!
    var collission = UICollisionBehavior()
    
    var mainAnimator : UIDynamicAnimator!
    var pushes = [UIPushBehavior]()
    var viewsAdded = [UIView]()
    var pushBehaviours = NSMutableDictionary()
    var dynamicProperties = [UIDynamicItemBehavior]()
    let selectedCategories = NSMutableArray()
    let big : CGFloat = 80
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
       
     
        let tapCatcher = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapped(_:)))
        tapCatcher.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapCatcher)
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(ViewController.swiped(_:)))
        self.view.addGestureRecognizer(gesture)
        
      
        
    }
    
    func tapped(_ tap : UITapGestureRecognizer){
        // get location
        
        let location = tap.location(in: view)
        for vw in viewsAdded{
            if vw.frame.contains(location){
                print("Tapped ")
                
                
                
                vw.frame = CGRect(x: vw.frame.origin.x, y: vw.frame.origin.y, width: big, height: big)
                vw.bounds = CGRect(x: vw.frame.origin.x, y: vw.frame.origin.y, width: big, height: big)
                vw.layer.frame = CGRect(x: vw.frame.origin.x, y: vw.frame.origin.y, width: big, height: big)
                vw.layer.bounds = CGRect(x: vw.frame.origin.x, y: vw.frame.origin.y, width: big, height: big)
                for sub in vw.subviews{
                    if let lab = sub as? UILabel{
                         lab.center = vw.center
                    }
                }
                
                if vw.backgroundColor == UIColor.red{
                    UIView.animate(withDuration: 0.5, animations: {
                        vw.backgroundColor = UIColor.green
                    }, completion: { (finished) in
                        print("finished")
                        self.updatedSelectedCategories(shouldRemove: false, vw: vw)
                    })
                }else{
                    UIView.animate(withDuration: 0.5, animations: {
                        vw.backgroundColor = UIColor.red
                    }, completion: { (finished) in
                        self.updatedSelectedCategories(shouldRemove: true, vw: vw)
                        print("finished")
                    })
                }
                

                
            }
        }
    }
    
    func swiped(_ swipe : UISwipeGestureRecognizer){
        let location = swipe.location(in: view)
        if swipe.state == UIGestureRecognizerState.changed{
            //add push vector
            self.addPushBack(location)
        }
    }
    
    func addPushBack(_ withPoint:CGPoint){

        pushes.removeAll(keepingCapacity: true)
        for viewT in viewsAdded{
            let angle = self.changebetween(viewT.center, pointView2: withPoint)
            // add push
            let pushBehaviour = UIPushBehavior(items: [viewT], mode: UIPushBehaviorMode.instantaneous)
            pushBehaviour.setAngle(angle, magnitude: 0.3)
            pushes.append(pushBehaviour)
            pushBehaviours.setObject(pushBehaviour, forKey: "\(viewT.tag)" as NSCopying)
        }
        for push in pushes{
            mainAnimator.addBehavior(push)
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addAnimator()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func changebetween(_ pointView1:CGPoint, pointView2:CGPoint)->CGFloat{
        let x = pointView2.x - pointView1.x
        let y =  pointView2.y - pointView1.y
        print("(\(x),\(y))")
        return atan2(y, x)
        
    }

    
    
    func addAnimator(){
        if mainAnimator == nil{
            mainAnimator = UIDynamicAnimator(referenceView: self.view)
        }
        
        // add our viws
        let view1 = UIView(frame: CGRect(x: 0, y: 0, width: big, height: big))
        let view2 = UIView(frame: CGRect(x: 0, y: self.view.frame.size.height/2, width: big, height: big))
        let view3 = UIView(frame: CGRect(x: 0, y: self.view.frame.size.height - big, width: big, height: big))
        let view4 = UIView(frame: CGRect(x: self.view.frame.size.width/2, y: 0, width: big, height: big))
        let view5 = UIView(frame: CGRect(x: self.view.frame.size.width - big, y: 0, width: big, height: big))
        let view6 = UIView(frame: CGRect(x: self.view.frame.size.width - big, y: self.view.frame.size.height/2, width: big, height: big))
        let view7 = UIView(frame: CGRect(x: self.view.frame.size.width - big, y: self.view.frame.size.height - big, width: big, height: big))
        let view8 = UIView(frame: CGRect(x: self.view.frame.size.width/2 - big/2, y: self.view.frame.size.height - big, width: big, height: big))
        
        let funViews = [view1,view2,view3,view4,view5,view6,view7,view8]
        var i = 0
        
        var genre = ["Blues","Rock","R&B","Bluegrass","Country","Alternative","Indie","Oldies"]
        //view configurations
        for viewT in funViews{
            viewT.backgroundColor = UIColor.red
            viewT.layer.borderColor = UIColor.white.cgColor
            viewT.layer.borderWidth = 1
            let centerOfViewT = CGPoint( x: viewT.bounds.midX, y: viewT.bounds.midY);
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
            label.center = centerOfViewT
            label.textAlignment = NSTextAlignment.center
            label.text = genre[i]
            label.font = UIFont(name: "AvenirNext-Medium", size: 14)
            label.textColor = UIColor.white
            label.tag = 4000
            viewT.addSubview(label)
            
            print("view t subviews = \(viewT.subviews)")
            view.addSubview(viewT)
            viewT.tag = i
            let point = CGPoint(x: self.view.frame.size.width/2, y: view.frame.size.height)
            let angle = self.changebetween(viewT.center, pointView2: point)
            viewsAdded.append(viewT)
            
            
            // add push
            let pushBehaviour = UIPushBehavior(items: [viewT], mode: UIPushBehaviorMode.instantaneous)
            pushBehaviour.setAngle(angle, magnitude: 0.9)
            pushes.append(pushBehaviour)
            pushBehaviours.setObject(pushBehaviour, forKey: "view\(i)" as NSCopying)
            
            let dynamicBehaviour = UIDynamicItemBehavior(items: [viewT])
            
            dynamicBehaviour.resistance = 0.3
            dynamicBehaviour.friction = 0.4
            dynamicBehaviour.density = 0.8
            dynamicBehaviour.elasticity = 0.10
            dynamicBehaviour.allowsRotation = false
            self.dynamicProperties.append(dynamicBehaviour)
            
            i += 1
        }

        let collision = UICollisionBehavior(items: viewsAdded)
        collision.translatesReferenceBoundsIntoBoundary = true
        collision.collisionDelegate = self
        mainAnimator.addBehavior(collision)
        for push in pushes{
            mainAnimator.addBehavior(push)
        }
        
        for dyn in self.dynamicProperties{
            mainAnimator.addBehavior(dyn)
        }
        
        
        print("Subview count is \(self.view.subviews.count)")
    }



    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item1: UIDynamicItem, with item2: UIDynamicItem, at p: CGPoint) {
        print("Called")
        
        if let it = item1 as? UIView{
            let int = it.tag
            let push = pushBehaviours.object(forKey: "view\(int)") as! UIPushBehavior
            push.removeItem(item1)
      
            print("Removing")
            
        }
        if let it2 = item2 as? UIView{
            let int = it2.tag
            let push = pushBehaviours.object(forKey: "view\(int)") as! UIPushBehavior
            push.removeItem(item2)
            print("Removing")
         
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.layoutIfNeeded()
        
        if animators == nil{
            animators = NSMutableDictionary()
            gravities = NSMutableDictionary()
        }
        
  
        for vw in self.view.subviews{
        
            if vw is UIScrollView{
               return
            }
            vw.layer.cornerRadius = vw.frame.size.height/2
            vw.layer.masksToBounds = true
        }
     
    
    }
    
    func updatedSelectedCategories(shouldRemove:Bool,vw:UIView){
        if shouldRemove == false{
            if let taggedLabel = vw.viewWithTag(4000) as? UILabel{
                self.selectedCategories.add(taggedLabel.text!)
                
            }
        }else{
            if let taggedLabel = vw.viewWithTag(4000) as? UILabel{
                self.selectedCategories.removeObject(identicalTo: taggedLabel.text!)
            }
        }
        self.updateLabel()
        
    }
    
    func updateLabel(){
        let fade = CATransition()
        fade.type = kCATransitionFade
        fade.duration = 0.4
        selectedCategoriesLabel.text = self.selectedCategories.componentsJoined(by: ",")
        selectedCategoriesLabel.layer.add(fade, forKey: nil)
    }
}


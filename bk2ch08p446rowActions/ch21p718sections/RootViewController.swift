
import UIKit

class RootViewController : UITableViewController {
    
    var sectionNames = [String]()
    var sectionData = [[String]]()
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        let s = NSString(contentsOfFile: NSBundle.mainBundle().pathForResource("states", ofType: "txt")!, encoding: NSUTF8StringEncoding, error: nil)!
        let states = s.componentsSeparatedByString("\n") as [String]
        var previous = ""
        for aState in states {
            // get the first letter
            let c = (aState as NSString).substringWithRange(NSMakeRange(0,1))
            // only add a letter to sectionNames when it's a different letter
            if c != previous {
                previous = c
                self.sectionNames.append( c.uppercaseString )
                // and in that case also add new subarray to our array of subarrays
                self.sectionData.append( [String]() )
            }
            sectionData[sectionData.count-1].append( aState )
        }
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.registerClass(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "Header")
        
        self.tableView.sectionIndexColor = UIColor.whiteColor()
        self.tableView.sectionIndexBackgroundColor = UIColor.redColor()
        self.tableView.sectionIndexTrackingBackgroundColor = UIColor.blueColor()
        
//        let b = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "doEdit:")
//        self.navigationItem.rightBarButtonItem = b
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem() // badda-bing, badda-boom
    }
    
//    func doEdit(sender:AnyObject?) {
//        var which : UIBarButtonSystemItem
//        if !self.tableView.editing {
//            self.tableView.setEditing(true, animated:true)
//            which = .Done
//        } else {
//            self.tableView.setEditing(false, animated:true)
//            which = .Edit
//        }
//        let b = UIBarButtonItem(barButtonSystemItem: which, target: self, action: "doEdit:")
//        self.navigationItem.rightBarButtonItem = b
//    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sectionNames.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sectionData[section].count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        let s = self.sectionData[indexPath.section][indexPath.row]
        cell.textLabel!.text = s
        
        var stateName = s
        stateName = stateName.lowercaseString
        stateName = stateName.stringByReplacingOccurrencesOfString(" ", withString:"")
        stateName = "flag_\(stateName).gif"
        let im = UIImage(named: stateName)
        cell.imageView!.image = im
        
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView {
        let h = tableView.dequeueReusableHeaderFooterViewWithIdentifier("Header") as UITableViewHeaderFooterView
        if h.tintColor != UIColor.redColor() {
            println("configuring a new header view") // only called about 7 times
            h.tintColor = UIColor.redColor() // invisible marker, tee-hee
            h.backgroundView = UIView()
            h.backgroundView!.backgroundColor = UIColor.blackColor()
            let lab = UILabel()
            lab.tag = 1
            lab.font = UIFont(name:"Georgia-Bold", size:22)
            lab.textColor = UIColor.greenColor()
            lab.backgroundColor = UIColor.clearColor()
            h.contentView.addSubview(lab)
            let v = UIImageView()
            v.tag = 2
            v.backgroundColor = UIColor.blackColor()
            v.image = UIImage(named:"us_flag_small.gif")
            h.contentView.addSubview(v)
            lab.setTranslatesAutoresizingMaskIntoConstraints(false)
            v.setTranslatesAutoresizingMaskIntoConstraints(false)
            h.contentView.addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat("H:|-5-[lab(25)]-10-[v(40)]",
                    options:nil, metrics:nil, views:["v":v, "lab":lab]))
            h.contentView.addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat("V:|[v]|",
                    options:nil, metrics:nil, views:["v":v]))
            h.contentView.addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat("V:|[lab]|",
                    options:nil, metrics:nil, views:["lab":lab]))
        }
        let lab = h.contentView.viewWithTag(1) as UILabel
        lab.text = self.sectionNames[section]
        return h
        
    }
    
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        return self.sectionNames
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath ip: NSIndexPath) {
        self.sectionData[ip.section].removeAtIndex(ip.row)
        switch editingStyle {
        case .Delete:
            if self.sectionData[ip.section].count == 0 {
                self.sectionData.removeAtIndex(ip.section)
                self.sectionNames.removeAtIndex(ip.section)
                tableView.deleteSections(NSIndexSet(index: ip.section),
                    withRowAnimation:.Automatic)
                tableView.reloadSectionIndexTitles()
            } else {
                tableView.deleteRowsAtIndexPaths([ip],
                    withRowAnimation:.Automatic)
            }
        default: break
        }
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        let act = UITableViewRowAction(style: .Normal, title: "Mark") {
            action, ip in
            println("Mark") // in real life, do something here
        }
        act.backgroundColor = UIColor.blueColor()
        let act2 = UITableViewRowAction(style: .Default, title: "Delete") {
            action, ip in
            self.tableView(self.tableView, commitEditingStyle:.Delete, forRowAtIndexPath:ip)
        }
        return [act2, act]
    }
    
//    // prevent swipe-to-edit
//    
//    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
//        return self.editing ? .Delete : .None
//    }
    
}

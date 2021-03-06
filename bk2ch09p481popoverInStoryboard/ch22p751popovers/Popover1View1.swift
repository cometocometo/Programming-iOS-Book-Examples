
import UIKit

class Popover1View1 : UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // as far as I can tell, this has to be determined experimentally
        self.preferredContentSize = CGSizeMake(320,150)
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier:"Cell")
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var result = 0
        switch section {
        case 0:
            result = 2
        default:break
        }
        return result
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath:indexPath) as UITableViewCell
        
        let section = indexPath.section
        let row = indexPath.row
        let choice = NSUserDefaults.standardUserDefaults().integerForKey("choice")
        switch section {
        case 0:
            switch row {
            case 0:
                cell.textLabel!.text = "First"
            case 1:
                cell.textLabel!.text = "Second"
            default:break
            }
            cell.accessoryType = (choice == row ?
                .Checkmark :
                .None)
        default:break
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        switch section {
        case 0:
            NSUserDefaults.standardUserDefaults().setInteger(row, forKey:"choice")
            tableView.reloadData()
        default:break
        }
    }
}



//
//  SectionDetailView.swift
//  HotSeats
//
//  Created by RPK on 12/31/15.
//  Copyright © 2015 Robert King. All rights reserved.
//

import UIKit

class SectionDetailView: UIView, UITableViewDataSource {
    
    weak var sectionTitleLabel: UILabel!
    weak var detailTable: UITableView!
    
    var section: Section! = nil
    
    class func fromNib(section: Section) -> SectionDetailView {
        let nib = UINib(nibName: "SectionDetailView", bundle: nil)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! SectionDetailView
        
        view.sectionTitleLabel = view.viewWithTag(20) as! UILabel
        view.detailTable = view.viewWithTag(21) as! UITableView
        view.section = section
        view.sectionTitleLabel.text = section.name
        view.detailTable.dataSource = view
        
        return view
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("DetailViewCell")
        if cell == nil {
            cell = UITableViewCell(style: .Value1, reuseIdentifier: "DetailViewCell")
        }
        
        switch (indexPath.row) {
            case 0:
                cell?.textLabel?.text = "Number of events"
                cell?.detailTextLabel?.text = "\(self.section.events.count)"
            default:
                cell?.textLabel?.text = ""
                cell?.detailTextLabel?.text = ""
                break
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
}

//
//  SectionDetailView.swift
//  HotSeats
//
//  Created by RPK on 12/31/15.
//  Copyright © 2015 Robert King. All rights reserved.
//

import UIKit
import Alamofire

let DETAIL_VIEW_TAG = 10
let ADD_ACTION_VIEW_TAG = 11

let SUBMIT_EVENT_BTN_TAG = 30
let CANCEL_EVENT_BTN_TAG = 31

let DATE_LABEL_TAG = 40
let EVENT_TYPE_TAG = 41

class SectionDetailView: UIView, UITableViewDataSource {
    
    weak var sectionTitleLabel: UILabel!
    weak var detailTable: UITableView!
    weak var actionBtn: UIButton!
    
    var addEventView: UIView!
    var section: Section! = nil
    var pendingEvent: Event! = nil
    
    class func fromNib(section: Section) -> SectionDetailView {
        /** TODO/NOTE TO STREAM: This is really bad and hacky, i will come back to fix it at some point... **/
        let nib = UINib(nibName: "SectionDetailView", bundle: nil)
        var sectionDetailView: SectionDetailView! = nil
        var addEventView: UIView? = nil
        
        for obj in nib.instantiateWithOwner(self, options: nil) {
            if let nibView = obj as? UIView {
                switch nibView.tag {
                case DETAIL_VIEW_TAG:
                    sectionDetailView = (nibView as! SectionDetailView)
                    break
                case ADD_ACTION_VIEW_TAG:
                    addEventView = nibView
                    let submitBtn = addEventView?.viewWithTag(SUBMIT_EVENT_BTN_TAG) as? UIButton
                    submitBtn?.addTarget(sectionDetailView, action: "submitEventPressed:", forControlEvents: .TouchUpInside)
                    let cancelBtn = addEventView?.viewWithTag(CANCEL_EVENT_BTN_TAG) as? UIButton
                    cancelBtn?.addTarget(sectionDetailView, action: "cancelEventPressed:", forControlEvents: .TouchUpInside)
                    break
                default:
                    print("Found a view that should not be there: \(nibView.tag)")
                }
            }
        }
        
        sectionDetailView.sectionTitleLabel = sectionDetailView.viewWithTag(20) as! UILabel
        sectionDetailView.detailTable = sectionDetailView.viewWithTag(21) as! UITableView
        sectionDetailView.actionBtn = sectionDetailView.viewWithTag(22) as! UIButton
        
        sectionDetailView.actionBtn.addTarget(sectionDetailView, action: "addEventPressed:", forControlEvents: .TouchUpInside)
        
        sectionDetailView.section = section
        sectionDetailView.addEventView = addEventView
        sectionDetailView.sectionTitleLabel.text = section.name
        sectionDetailView.detailTable.dataSource = sectionDetailView
        
        return sectionDetailView
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
        case 1:
            cell?.textLabel?.text = "Most recent event"
            if let mostRecent = self.section.getMostRecentEvent() {
                
                // TODO: This should include the time of the event not just a date 
                // a lot of things could happne on the same day
                cell?.detailTextLabel?.text = formatEventDate(mostRecent.date)
            }
            else {
                cell?.detailTextLabel?.text = "N/A"
            }
        default:
            cell?.textLabel?.text = ""
            cell?.detailTextLabel?.text = ""
            break
        }
        
        cell?.userInteractionEnabled = false
        
        return cell!
    }
    
    func formatEventDate(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        
        return formatter.stringFromDate(date)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func addEventPressed(sender: UIButton) {
        self.addEventView.frame = self.detailTable.frame
        self.pendingEvent = Event()
        (self.addEventView.viewWithTag(DATE_LABEL_TAG) as? UILabel)!.text = formatEventDate(pendingEvent.date)
        (self.addEventView.viewWithTag(EVENT_TYPE_TAG) as? UISegmentedControl)?.selectedSegmentIndex = 0
        
        self.addSubview(self.addEventView)
        UIView.transitionFromView(self.detailTable, toView: self.addEventView,
            duration: 1.0, options: [.TransitionFlipFromRight, .ShowHideTransitionViews]) { (complete) -> Void in
                self.actionBtn.hidden = true
            }
    }
    
    func submitEventPressed(sender: UIButton) {
        // TODO: Create an event and add it, to the Section
        let segmentControl = self.addEventView.viewWithTag(EVENT_TYPE_TAG) as! UISegmentedControl
        let selectedSegmentInd = segmentControl.selectedSegmentIndex
        switch segmentControl.titleForSegmentAtIndex(selectedSegmentInd)! {
        case "Foulball":
            self.pendingEvent.type = .Foul
            break
        case "Homerun":
            self.pendingEvent.type = .Homerun
            break
        default:
            // BAD: Unknown event type
            print("Found unknown event type in the segment control!!")
        }
        
        self.section.addEvent(self.pendingEvent)
        
        let postData = self.pendingEvent.toDictionary()
        
        Alamofire.request(.POST, "http://192.168.1.3:8888/events",
            parameters: postData, encoding: .JSON).responseJSON { resp in
                print("Response Success: \(resp.result.isSuccess)")
                
                switch resp.result {
                case .Success:
                    print("Response value: \(resp.result.value)")
                    break;
                case .Failure:
                    // Handle the error
                    print("An error occurred")
                }
        }
        
        self.pendingEvent = nil
        
        self.hideAddEventView()
    }
    
    func cancelEventPressed(sender: UIButton) {
        self.pendingEvent = nil
        
        self.hideAddEventView()
    }
    
    func hideAddEventView() {
        UIView.transitionFromView(self.addEventView, toView: self.detailTable,
            duration: 1.0, options: [.TransitionFlipFromLeft, .ShowHideTransitionViews]) { (complete) -> Void in
                self.actionBtn.hidden = false
                self.addEventView.removeFromSuperview()
        }
        
        self.detailTable.reloadData()
    }
}

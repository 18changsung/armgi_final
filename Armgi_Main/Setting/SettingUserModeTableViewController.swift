//
//  SettingUserModeTableViewController.swift
//  Settings
//
//  Created by CAUAD09 on 2018. 8. 9..
//  Copyright © 2018년 NEURRRI. All rights reserved.
//

import UIKit
import UserNotifications

class SettingUserModeTableViewController: UITableViewController {
    
    var starList:[String] = []
    var odapList:[String] = []

    @IBOutlet weak var starMemory: UITableViewCell!
    @IBOutlet weak var theIncorrect: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if settingStatus.userMode == true || settingStatus.userMode == nil {
            starMemory.accessoryType = .checkmark
            theIncorrect.accessoryType = .none
        } else {
            starMemory.accessoryType = .none
            theIncorrect.accessoryType = .checkmark
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    let numberOfRowsAtSection: [Int] = [2, 1]

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows: Int = 0
        
        if section < numberOfRowsAtSection.count {
            rows = numberOfRowsAtSection[section]
        }
        return rows
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if starMemory.isSelected == true {
            starMemory.accessoryType = .checkmark
            theIncorrect.isSelected = false
            theIncorrect.accessoryType = .none
            
            settingStatus.userMode = true
            
        } else if theIncorrect.isSelected == true {
            theIncorrect.accessoryType = .checkmark
            starMemory.isSelected = false
            starMemory.accessoryType = .none
            
            settingStatus.userMode = false
        }
        
        //notification
        if indexPath.row == 0 { //중요암기 알림
            let popUp = UNMutableNotificationContent()
            
            for i in 0 ..< dataCenter.studyList.count {
                if dataCenter.alarmOnOff[i] == true {
                    for j in 0 ..< dataCenter.studyList[i].unitList.count {
                        for k in 0 ..< dataCenter.studyList[i].unitList[j].allWords.count {
                            if dataCenter.studyList[i].unitList[j].allWords[k].starFlag == false {
                                starList.append("\(dataCenter.studyList[i].unitList[j].allWords[k].keyword)\r\n\(dataCenter.studyList[i].unitList[j].allWords[k].explanation)")
                                
                                let randNum:UInt32 = arc4random_uniform(UInt32(starList.count))
                                var split = starList[Int(randNum)].components(separatedBy: "\r\n")
                                popUp.title = "\(split[0])"
                                popUp.body = "\(split[1])"
                            }
                        }
                    }
                }
                
                let weekdaySet:[Int] = dataCenter.alarmData[i].repeatedWeekdays
                for l in weekdaySet {
                    var dateComponents = DateComponents()
                    dateComponents.weekday = l
                    dateComponents.hour = dataCenter.alarmData[i].alarmHour
                    dateComponents.minute = dataCenter.alarmData[i].alarmMinutes
                    
                    let calendarTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                    let request = UNNotificationRequest(identifier: "\(dataCenter.studyList[i].subjectName)", content: popUp, trigger: calendarTrigger)
                    
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                }
            }
            
        } else if indexPath.row == 1 { //오답노트 알림
            let popUp = UNMutableNotificationContent()
            
            for i in 0 ..< dataCenter.studyList.count {
                if dataCenter.alarmOnOff[i] == true {
                    for j in 0 ..< dataCenter.studyList[i].unitList.count {
                        for k in 0 ..< dataCenter.studyList[i].unitList[j].allWords.count {
                            if dataCenter.studyList[i].unitList[j].allWords[k].odapCount > 0 {
                                odapList.append("\(dataCenter.studyList[i].unitList[j].allWords[k].keyword)\r\n\(dataCenter.studyList[i].unitList[j].allWords[k].explanation)")
                                
                                let randNum:UInt32 = arc4random_uniform(UInt32(odapList.count))
                                var split = odapList[Int(randNum)].components(separatedBy: "\r\n")
                                popUp.title = "\(split[0])"
                                popUp.body = "\(split[1])"
                            }
                        }
                    }
                }
                
                let weekdaySet:[Int] = dataCenter.alarmData[i].repeatedWeekdays
                for l in weekdaySet {
                    var dateComponents = DateComponents()
                    dateComponents.weekday = l
                    dateComponents.hour = dataCenter.alarmData[i].alarmHour
                    dateComponents.minute = dataCenter.alarmData[i].alarmMinutes
                    
                    let calendarTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                    let request = UNNotificationRequest(identifier: "\(dataCenter.studyList[i].subjectName)", content: popUp, trigger: calendarTrigger)
                    
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                }
            }
        }
    }
}

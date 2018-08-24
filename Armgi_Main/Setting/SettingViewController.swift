//
//  SettingViewController.swift
//  Settings
//
//  Created by CAUAD09 on 2018. 8. 8..
//  Copyright © 2018년 NEURRRI. All rights reserved.
//

import UIKit
import UserNotifications


class SettingViewController: UITableViewController {
    
    var allWords:[String] = []
    
    //설정
    @IBOutlet weak var forgettingCurveMode: UITableViewCell!
    @IBOutlet weak var userSettingMode: UITableViewCell!
    @IBOutlet weak var userSettingOption: UITableViewCell!
    @IBOutlet weak var userDetail: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if settingStatus.alarmMode == true || settingStatus.alarmMode == nil{
            userSettingMode.accessoryType = .checkmark
            forgettingCurveMode.accessoryType = .none
        } else {
            userSettingMode.accessoryType = .none
            userSettingOption.isUserInteractionEnabled = false
            userLabel.textColor = UIColor.lightGray
            forgettingCurveMode.accessoryType = .checkmark
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if settingStatus.userMode == true || settingStatus.userMode == nil {
            userDetail.text = "중요 암기"
        } else {
            userDetail.text = "오답 노트"
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //체크마크 변경
        if userSettingMode.isSelected == true {
            userSettingMode.accessoryType = .checkmark
            userSettingOption.isUserInteractionEnabled = true
            userLabel.textColor = UIColor.black
            forgettingCurveMode.isSelected = false
            forgettingCurveMode.accessoryType = .none
            
            settingStatus.alarmMode = true
            
        } else if forgettingCurveMode.isSelected == true {
            forgettingCurveMode.accessoryType = .checkmark
            userSettingMode.isSelected = false
            userSettingMode.accessoryType = .none
            userSettingOption.isUserInteractionEnabled = false
            userLabel.textColor = UIColor.lightGray
            
            settingStatus.alarmMode = false
        }
        
        //notification
        if indexPath.row == 2 { //망각곡선
            
            let forgettingCurveTime:[Int] = [60*60, 5*60*60, 24*60*60, 72*60*60]
            
            for l in 0 ..< forgettingCurveTime.count {
                let popUp = UNMutableNotificationContent()
                
                for i in 0 ..< dataCenter.studyList.count {
                    if dataCenter.alarmOnOff[i] == true {
                        for j in 0 ..< dataCenter.studyList[i].unitList.count {
                            for k in 0 ..< dataCenter.studyList[i].unitList[j].allWords.count {
                                allWords.append("\(dataCenter.studyList[i].unitList[j].allWords[k].keyword)\r\n\(dataCenter.studyList[i].unitList[j].allWords[k].explanation)")
                                
                                let randNum:UInt32 = arc4random_uniform(UInt32(allWords.count))
                                var split = allWords[Int(randNum)].components(separatedBy: "\r\n")
                                popUp.title = "\(split[0])"
                                popUp.body = "\(split[1])"
                            }
                        }
                    }
                }
                let forgetTrigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(forgettingCurveTime[l]), repeats: false)
                let request = UNNotificationRequest(identifier: "\(l)", content: popUp, trigger: forgetTrigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            }
        }
    }

}

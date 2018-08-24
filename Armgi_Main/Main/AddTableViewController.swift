//
//  AddTableViewController.swift
//  Armgi_Main
//
//  Created by Tars on 7/26/18.
//  Copyright © 2018 sspog. All rights reserved.
//

import UIKit

class AddTableViewController: UITableViewController, UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!

    var collectionViewCellCurrent = 0
    var pickerData:Date = Date() // 오직 수정만을 위한.

    //목표량 바 색상 선택
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataCenter.templateColor.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath)
        cell.backgroundColor = UIColor().colorFromHex(dataCenter.templateColor[indexPath.row])
        //처음 박스를 검은색으로 미리 설정.
        if !dataCenter.edit {
            if indexPath.row == 0 {
                cell.layer.borderColor = UIColor.black.cgColor
                cell.layer.borderWidth = 2.0
            }
        } else {
            if indexPath.row == dataCenter.selectedColor[dataCenter.addSubject] {
                cell.layer.borderColor = UIColor.black.cgColor
                cell.layer.borderWidth = 2.0
            }
        }

        return cell
    }
    
    //콜렉션 뷰 가운데정렬(viewdidload의 스페이싱은 없앰)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let tableViewWidth:Int = Int(tableView.frame.size.width)
        let totalCellWidth:Int = 50*dataCenter.templateColor.count
        let totalSpacingWidth:Int = 20*(dataCenter.templateColor.count - 1)
        
        let edgeInsets = (tableViewWidth - (totalCellWidth + totalSpacingWidth)) / 2
        
        return UIEdgeInsetsMake(0, CGFloat(edgeInsets), 0, CGFloat(edgeInsets))
    }
    
    
    //다른 박스 선택시 기존 박스 체크 해제
    var preCellIndex:IndexPath = [0,0]
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        let preCell = collectionView.cellForItem(at: preCellIndex)
        if indexPath != preCellIndex{
            cell?.layer.borderColor = UIColor.black.cgColor
            cell?.layer.borderWidth = 2.0
            preCell?.layer.borderWidth = 0
            preCellIndex = indexPath
            collectionViewCellCurrent = indexPath.row
        }
    }

    @IBOutlet weak var studyTitleInput: UITextField!
    @IBOutlet weak var endDatePicker: UIDatePicker! // pickerView로 선택한 마감날짜.
    @IBOutlet weak var goalValueLabel: UILabel!
    @IBOutlet weak var stepperValue: UIStepper!
    @IBAction func stepperAction(_ sender: Any) {
        goalValueLabel.text = "\(Int(stepperValue.value))"
    }
    //알람 여부, 시간, 요일 설정
    @IBOutlet weak var alarmSwitch: UISwitch!
    @IBAction func alarmWork(_ sender: UISwitch) {
        if sender.isOn {
            alarmSwitch.isOn = true
        } else {
            alarmSwitch.isOn = false
        }
    }

    @IBOutlet weak var timePicker: UIDatePicker!
    var repeatWeekdays:[Int] = []
    @IBOutlet weak var repeatDetail: UILabel!


    //텍스트 필드 공백시 알림
    let inputAlert = UIAlertController(title:"어이쿠!", message:"학습 주제나 목표량이 제대로 입력되었는지\r\n확인해주세요!", preferredStyle: .alert)
    let inputAlertAction = UIAlertAction(title:"확인", style: .default, handler: nil)

    @objc func dismissFunc(){
        self.inputAlert.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // 홈 버튼을 누르고 돌아오면 오류메시지 안보이기.
        inputAlert.addAction(inputAlertAction)
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(dismissFunc), name: Notification.Name.UIApplicationWillResignActive, object: nil)

        if dataCenter.edit {
            studyTitleInput.text = dataCenter.studyList[dataCenter.addSubject].subjectName
            endDatePicker.date = dataCenter.pickerList[dataCenter.addSubject]
            goalValueLabel.text = String(Int(dataCenter.goalData.goalList[dataCenter.addSubject]))
            stepperValue.value = Double(dataCenter.goalData.goalList[dataCenter.addSubject])
            alarmSwitch.isOn = dataCenter.alarmOnOff[dataCenter.addSubject]
            timePicker.date = dataCenter.alarmPicker[dataCenter.addSubject]
            repeatDetail.text = WeekdayTableViewController.repeatText(weekdays: dataCenter.alarmData[dataCenter.addSubject].repeatedWeekdays)

        } else {
            studyTitleInput.text = ""
            endDatePicker.date = Date()
            goalValueLabel.text = "0"
            stepperValue.value = 0
            alarmSwitch.isOn = false
            timePicker.date = Date()
            repeatDetail.text = ""
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        repeatDetail.text = WeekdayTableViewController.repeatText(weekdays: repeatWeekdays)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let weekdayVC = segue.destination as? WeekdayTableViewController
        weekdayVC?.delegate = self
    }

//완료 버튼으로 모달창 닫기.
    @IBAction func doneDismiss(_ sender: Any) {
        if !dataCenter.edit {
            if let studyTitleInput = studyTitleInput.text{
                if studyTitleInput == "" || Int(stepperValue.value) == 0{
                    self.present(inputAlert, animated: true, completion: nil)
                } else {
                    // 추가하는 데이터.
                    dataCenter.studyList.append(Study(subjectName: studyTitleInput))
                    dataCenter.ddayList.append(findDday())
                    dataCenter.pickerList.append(pickerData)

                    dataCenter.goalData.goalList.append(Float(stepperValue.value))
                    dataCenter.selectedColor.append(collectionViewCellCurrent)
                    dataCenter.goalData.currentGoalVal.append(Float(0))
                    
                    dataCenter.alarmOnOff.append(alarmSwitch.isOn)
                    let createAlarmData = AlarmData()
                    
                    let calendar = Calendar.current
                    let components = calendar.dateComponents([.hour, .minute], from: timePicker.date)
                    let pickedHour = components.hour
                    let pickedMinute = components.minute
                    if let hour = pickedHour, let minute = pickedMinute {
                        createAlarmData.alarmHour = hour
                        createAlarmData.alarmMinutes = minute
                    }
                    createAlarmData.repeatedWeekdays.append(Int(0))

                    dataCenter.alarmPicker.append(timePicker.date)
                    dataCenter.alarmData.append(createAlarmData)

                    self.dismiss(animated: true, completion: nil)
                }
            }
        } else {
            if let studyTitleInput = studyTitleInput.text{
                if studyTitleInput == "" || Int(stepperValue.value) == 0{
                    self.present(inputAlert, animated: true, completion: nil)
                } else {
                    // 추가하는 데이터.
                    dataCenter.studyList[dataCenter.addSubject].subjectName = studyTitleInput
                    dataCenter.ddayList[dataCenter.addSubject] = findDday()
                    dataCenter.pickerList[dataCenter.addSubject] = pickerData

                    dataCenter.goalData.goalList[dataCenter.addSubject] = Float(stepperValue.value)
                    dataCenter.selectedColor[dataCenter.addSubject] = collectionViewCellCurrent
                    dataCenter.goalData.currentGoalVal[dataCenter.addSubject] = Float(0)

                    dataCenter.alarmOnOff[dataCenter.addSubject] = alarmSwitch.isOn
                    let createAlarmData = AlarmData()

                    let calendar = Calendar.current
                    let components = calendar.dateComponents([.hour, .minute], from: timePicker.date)
                    let pickedHour = components.hour
                    let pickedMinute = components.minute
                    if let hour = pickedHour, let minute = pickedMinute {
                        createAlarmData.alarmHour = hour
                        createAlarmData.alarmMinutes = minute
                    }
                    createAlarmData.repeatedWeekdays.append(Int(0))

                    dataCenter.alarmPicker[dataCenter.addSubject] = timePicker.date
                    dataCenter.alarmData[dataCenter.addSubject] = createAlarmData

                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        dataCenter.edit = false
    }

//취소 버튼으로 모달창 닫기.
    @IBAction func cancelDismiss(_ sender: Any) {
        dataCenter.edit = false
        self.dismiss(animated: true, completion: nil)
    }

//키보드 완료 버튼 누르면 키보드 숨기기.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

//Dday를 구해주는 함수
    func findDday() -> Int{
        let todayDate = Date()
        pickerData = endDatePicker.date
        do {
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.day]
            formatter.unitsStyle = .full //필요.
            if let daysString = formatter.string(from: todayDate, to: endDatePicker.date) {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .short
                dateFormatter.timeStyle = .none
                let startDate = dateFormatter.string(from: todayDate)
                let endDate = dateFormatter.string(from: endDatePicker.date)
                if startDate == endDate{
                    return 0
                }
                let ddayArr = daysString.components(separatedBy: " ")
                if let ddayIndexZero = Int(ddayArr[0].components(separatedBy: [","]).joined()){
                    if ddayIndexZero < 0{
                        return ddayIndexZero
                    }
                    else{
                        return ddayIndexZero + 1
                    }
                }
            }
        }
        return 9999
    }
}

//
//  DataCenter.swift
//  Armgi_Main
//
//  Created by Tars on 7/26/18.
//  Copyright © 2018 sspog. All rights reserved.
//

import Foundation

var dataCenter:DataCenter = DataCenter()
var settingStatus:SettingStatus = SettingStatus()

class DataCenter: NSObject, NSCoding{

    var studyList:[Study]
    var ddayList:[Int]

    var pickerList:[Date] // 수정을 위한..
    var alarmPicker:[Date]
    var edit:Bool
    var addSubject:Int

    var goalData:GoalData
    var selectedColor:[Int]

    var todayDate:Date // 앱을 처음 실행한 날짜가 들어갈 것이고..

    var templateColor:[String]
    
    var alarmOnOff:[Bool]
    var alarmData:[AlarmData]

    override init() {
        self.studyList = []
        self.ddayList = []
        self.pickerList = []
        self.alarmPicker = []
        self.edit = false
        self.addSubject = 0
        self.goalData = GoalData()
        self.selectedColor = []
        self.todayDate = Date()

        self.templateColor = ["#3FA9F5","#72D54A","#FFD235","#FF4C00"]
        //순서대로 파란색,초록색,노란색,빨간색
        
        self.alarmOnOff = []
        self.alarmData = []
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.studyList, forKey: "studyList")
        aCoder.encode(self.ddayList, forKey: "ddayList")
        aCoder.encode(self.pickerList, forKey: "pickerList")
        aCoder.encode(self.alarmPicker, forKey: "alarmPicker")
        aCoder.encode(self.edit, forKey: "edit")
        aCoder.encode(self.addSubject, forKey: "addSubject")
        aCoder.encode(self.goalData, forKey: "goalData")
        aCoder.encode(self.selectedColor, forKey: "selectedColor")
        aCoder.encode(self.todayDate, forKey: "todayDate")
        aCoder.encode(self.templateColor, forKey: "templateColor")
        aCoder.encode(self.alarmOnOff, forKey: "alarmOnOff")
        aCoder.encode(self.alarmData, forKey: "alarmData")
    }

    public required init?(coder aDecoder: NSCoder) {
        if let studyList = aDecoder.decodeObject(forKey:"studyList") as? [Study]{
            self.studyList = studyList
        } else {
            self.studyList = []
        }
        if let ddayList = aDecoder.decodeObject(forKey:"ddayList") as? [Int]{
            self.ddayList = ddayList
        } else {
            self.ddayList = []
        }
        if let pickerList = aDecoder.decodeObject(forKey:"pickerList") as? [Date]{
            self.pickerList = pickerList
        } else {
            self.pickerList = []
        }
        if let alarmPicker = aDecoder.decodeObject(forKey:"alarmPicker") as? [Date]{
            self.alarmPicker = alarmPicker
        } else {
            self.alarmPicker = []
        }
        if let edit = aDecoder.decodeObject(forKey:"edit") as? Bool{
            self.edit = edit
        } else {
            self.edit = false
        }
        if let addSubject = aDecoder.decodeObject(forKey:"addSubject") as? Int{
            self.addSubject = addSubject
        } else {
            self.addSubject = 0
        }
        if let goalData = aDecoder.decodeObject(forKey:"goalData") as? GoalData{
            self.goalData = goalData
        } else {
            self.goalData = GoalData()
        }
        if let selectedColor = aDecoder.decodeObject(forKey:"selectedColor") as? [Int]{
            self.selectedColor = selectedColor
        } else {
            self.selectedColor = []
        }
        if let todayDate = aDecoder.decodeObject(forKey:"todayDate") as? Date{
            self.todayDate = todayDate
        } else {
            self.todayDate = Date()
        }
        if let templateColor = aDecoder.decodeObject(forKey:"templateColor") as? [String]{
            self.templateColor = templateColor
        } else {
            self.templateColor = ["#3FA9F5","#72D54A","#FFD235","#FF4C00"]
        }
        if let alarmOnOff = aDecoder.decodeObject(forKey: "alarmOnOff") as? [Bool] {
            self.alarmOnOff = alarmOnOff
        } else {
            self.alarmOnOff = []
        }
        if let alarmData = aDecoder.decodeObject(forKey: "alarmData") as? [AlarmData] {
            self.alarmData = alarmData
        } else {
            self.alarmData = []
        }
    }
}

class Study: NSObject, NSCoding {
    var subjectName:String
    var chosenUnit:Int
    var unitList:[OneUnit]

    init(subjectName:String) {
        self.subjectName = subjectName
        self.chosenUnit = 0
        self.unitList = []
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.subjectName, forKey: "subjectName")
        aCoder.encode(self.chosenUnit, forKey: "chosenUnit")
        aCoder.encode(self.unitList, forKey: "unitList")
    }

    public required init?(coder aDecoder: NSCoder) {
        if let subjectName = aDecoder.decodeObject(forKey:"subjectName") as? String{
            self.subjectName = subjectName
        } else {
            self.subjectName = ""
        }
        if let chosenUnit = aDecoder.decodeObject(forKey:"chosenUnit") as? Int{
            self.chosenUnit = chosenUnit
        } else {
            self.chosenUnit = 0
        }
        if let unitList = aDecoder.decodeObject(forKey:"unitList") as? [OneUnit]{
            self.unitList = unitList
        } else {
            self.unitList = []
        }
    }
}

class OneUnit: NSObject, NSCoding {
    var unitName:String
    var allWords:[Words] // 단어식
    var allSentences:[Sentences] // 문장식
    var sentencesQuiz:[[String]]

    init(unitName:String, allWords:[Words], allSentences:[Sentences]) {
        self.unitName = unitName
        self.allWords = allWords
        self.allSentences = allSentences
        self.sentencesQuiz = []
    }

    convenience init(unitName: String) {
        self.init(unitName: unitName, allWords: [], allSentences: [])
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.unitName, forKey: "unitName")
        aCoder.encode(self.allWords, forKey: "allWords")
        aCoder.encode(self.allSentences, forKey: "allSentences")
        aCoder.encode(self.sentencesQuiz, forKey: "sentencesQuiz")
    }

    public required init?(coder aDecoder: NSCoder) {
        if let unitName = aDecoder.decodeObject(forKey:"unitName") as? String{
            self.unitName = unitName
        } else {
            self.unitName = ""
        }
        if let allWords = aDecoder.decodeObject(forKey:"allWords") as? [Words]{
            self.allWords = allWords
        } else {
            self.allWords = []
        }
        if let allSentences = aDecoder.decodeObject(forKey:"allSentences") as? [Sentences]{
            self.allSentences = allSentences
        } else {
            self.allSentences = []
        }
        if let sentencesQuiz = aDecoder.decodeObject(forKey:"sentencesQuiz") as? [[String]]{
            self.sentencesQuiz = sentencesQuiz
        } else {
            self.sentencesQuiz = []
        }
    }
}

class Words: NSObject, NSCoding{
    var keyword:String
    var explanation:String
    var starFlag:Bool? // optional로 안했더니 계속 terminate 후, true로 초기화 됨. 그리고 wordTVC에서 nil처리 해줌.
    var odapCount:Int

    init(keyword:String, explanation:String) {
        self.keyword = keyword
        self.explanation = explanation
        // self.starFlag = true
        self.odapCount = 0
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.keyword, forKey: "keyword")
        aCoder.encode(self.explanation, forKey: "explanation")
        aCoder.encode(self.starFlag, forKey: "starFlag")
        aCoder.encode(self.odapCount, forKey: "odapCount")
    }

    public required init?(coder aDecoder: NSCoder) {
        if let keyword = aDecoder.decodeObject(forKey:"keyword") as? String{
            self.keyword = keyword
        } else {
            self.keyword = ""
        }
        if let explanation = aDecoder.decodeObject(forKey:"explanation") as? String{
            self.explanation = explanation
        } else {
            self.explanation = ""
        }
        if let starFlag = aDecoder.decodeObject(forKey:"starFlag") as? Bool? {
            self.starFlag = starFlag
        } else {
            self.starFlag = true
        }
        if let odapCount = aDecoder.decodeObject(forKey:"odapCount") as? Int{
            self.odapCount = odapCount
        } else {
            self.odapCount = 0
        }
    }
}

class Sentences: NSObject, NSCoding { // starFlag, starImageFlag 가 아카이빙할 때 겹치지 않을까?
    var sentences:String
    var starFlag:Bool?
    var odapCount:Int

    init(sentences:String) {
        self.sentences = sentences
        self.odapCount = 0
    }
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.sentences, forKey: "sentences")
        aCoder.encode(self.starFlag, forKey: "starFlag")
        aCoder.encode(self.odapCount, forKey: "odapCount")
    }

    public required init?(coder aDecoder: NSCoder) {
        if let sentences = aDecoder.decodeObject(forKey:"sentences") as? String {
            self.sentences = sentences
        } else {
            self.sentences = " "
        }
        if let starFlag = aDecoder.decodeObject(forKey:"starFlag") as? Bool? {
            self.starFlag = starFlag
        } else {
            self.starFlag = true
        }
        if let odapCount = aDecoder.decodeObject(forKey:"odapCount") as? Int{
            self.odapCount = odapCount
        } else {
            self.odapCount = 0
        }
    }
}

class GoalData: NSObject, NSCoding {
    var goalList:[Float]
    var currentGoalVal:[Float]

    override init() {
        self.goalList = []
        self.currentGoalVal = []
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.goalList, forKey: "goalList")
        aCoder.encode(self.currentGoalVal, forKey: "currentGoalVal")
    }

    public required init?(coder aDecoder: NSCoder) {
        if let goalList = aDecoder.decodeObject(forKey:"goalList") as? [Float] {
            self.goalList = goalList
        } else {
            self.goalList = []
        }
        if let currentGoalVal = aDecoder.decodeObject(forKey:"currentGoalVal") as? [Float] {
            self.currentGoalVal = currentGoalVal
        } else {
            self.currentGoalVal = []
        }
    }
}

class AlarmData: NSObject, NSCoding {
    var alarmHour:Int
    var alarmMinutes:Int
    var repeatedWeekdays:[Int]
    
    override init() {
        self.alarmHour = 0
        self.alarmMinutes = 0
        self.repeatedWeekdays = []
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.alarmHour, forKey: "alarmHour")
        aCoder.encode(self.alarmMinutes, forKey: "alarmMinutes")
        aCoder.encode(self.repeatedWeekdays, forKey: "repeatedWeekdays")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        if let alarmHour = aDecoder.decodeObject(forKey: "alarmHour") as? Int {
            self.alarmHour = alarmHour
        } else {
            self.alarmHour = 0
        }
        if let alarmMinutes = aDecoder.decodeObject(forKey: "alarmMinutes") as? Int {
            self.alarmMinutes = alarmMinutes
        } else {
            self.alarmMinutes = 0
        }
        if let repeatedWeekdays = aDecoder.decodeObject(forKey:"repeatedWeekdays") as? [Int] {
            self.repeatedWeekdays = repeatedWeekdays
        } else {
            self.repeatedWeekdays = []
        }
    }
}

class SettingStatus: NSObject, NSCoding{
    var alarmMode:Bool?
    var userMode:Bool?
    
    override init() {
        
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.alarmMode, forKey: "alarmMode")
        aCoder.encode(self.userMode, forKey: "userMode")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        if let alarmMode = aDecoder.decodeObject(forKey: "alarmMode") as? Bool? {
            self.alarmMode = alarmMode
        } else {
            self.alarmMode = true
        }
        if let userMode = aDecoder.decodeObject(forKey:"userMode") as? Bool? {
            self.userMode = userMode
        } else {
            self.userMode = true
        }
    }
    
}

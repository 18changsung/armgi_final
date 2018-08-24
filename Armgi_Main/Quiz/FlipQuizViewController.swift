//
//  ViewController.swift
//  Armgi_Main
//
//  Created by MacBook on 2018. 8. 15..
//  Copyright © 2018년 sspog. All rights reserved.
//

import UIKit

class FlipQuizViewController: UIViewController {

    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var preButton: UIButton!
    @IBOutlet weak var incorrectButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var quizCardView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerTF: UITextField!
    @IBOutlet var noDataView: UIView!
    @IBOutlet weak var questionCount: UILabel!

    var selectedSubject:Int = 0
    var selectedUnit:Int = 0

    var qIndex:Int = 0
    var answerIndex:Int = 0

    var questionWordsList:[String] = []
    var answerWordsList:[String] = []

    var pop:Bool = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionLabel.numberOfLines = 0 //레이블이 길어질 경우 줄의 숫자는 무한대
        questionLabel.adjustsFontSizeToFitWidth = true //폰트사이즈는 오토레이아웃에 맞춰져서 변경
        answerLabel.numberOfLines = 0 //해결완료
        answerLabel.adjustsFontSizeToFitWidth = true //해결완료
        
        subjectLabel.text = dataCenter.studyList[selectedSubject].subjectName
        unitLabel.text = dataCenter.studyList[selectedSubject].unitList[selectedUnit].unitName

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let count:Int = dataCenter.studyList[selectedSubject].unitList[selectedUnit].allWords.count
        
        if count == 0 { // 생성된 암기가 없으면..
            self.view = noDataView
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let countWords:Int = dataCenter.studyList[selectedSubject].unitList[selectedUnit].allWords.count

        questionWordsList = []
        answerWordsList = []

        questionCount.text = "\(qIndex+1) / \(countWords)"

        for i in 0 ..< countWords {
            questionWordsList.append(dataCenter.studyList[selectedSubject].unitList[selectedUnit].allWords[i].explanation)
            answerWordsList.append(dataCenter.studyList[selectedSubject].unitList[selectedUnit].allWords[i].keyword)
        }

        if countWords > 0 && qIndex < countWords {
            questionLabel.text = questionWordsList[qIndex]
        }

        // 축하버튼에서 되돌아가기 누르면 navigation pop시작.
        if pop == true {
            //네비게이션 팝
            if self.presentingViewController != nil {
                self.dismiss(animated: false, completion: {
                    self.navigationController!.popToRootViewController(animated: true)
                })
            }
            else {
                self.navigationController!.popToRootViewController(animated: true)
            }
            pop = false
        }

        answerLabel.text = ""
        starButton.isHidden = true
        incorrectButton.isHidden = true
    }
    
    @IBAction func CheckButton(_ sender: Any) {
        let countWords:Int = dataCenter.studyList[selectedSubject].unitList[selectedUnit].allWords.count

        if countWords > 0 {
            if answerIndex < countWords {
                let answer = answerWordsList[qIndex]

                answerLabel.text = answer
                if answerTF.text == answer {
                    answerLabel.textColor = UIColor.green
                    incorrectButton.isHidden = true
                    checkButton.isEnabled = false
                } else {
                    answerLabel.textColor = UIColor.red
                    incorrectButton.isHidden = false
                    checkButton.isEnabled = false
                }
            }
            starButton.isHidden = false
            self.view.endEditing(true)
        }
    }

    //주변 건들이면 키보드 없애기
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func NextButton(_ sender: Any) {
        let count:Int = dataCenter.studyList[selectedSubject].unitList[selectedUnit].allWords.count
        qIndex += 1
        answerIndex += 1
        if qIndex >= count {
            print ("암기 퀴즈가 끝났습니다!\r\n목표량이 일 증가합니다.")
            dataCenter.goalData.currentGoalVal[selectedSubject] += 1
            checkButton.isEnabled = false
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CelebrateVC") as?CelebrateViewController {
                vc.delegate2 = self
                present(vc, animated: true, completion: nil)
            }
        } else {
            incorrectButton.isEnabled = true
            checkButton.isEnabled = true
            self.quizCardView.NextButton()
        }
        answerTF.text = "" // 텍스트 필드 비워주기.
        self.viewWillAppear(true)
    }
    
    
    @IBAction func PreButton(_ sender: Any)  {
        incorrectButton.isEnabled = true
        checkButton.isEnabled = true
        if qIndex > 0 {
            qIndex -= 1
            answerIndex -= 1
            self.quizCardView.PreButton()
        }
        answerTF.text = "" // 텍스트 필드 비워주기.
        self.viewWillAppear(true)
    }
    
    var flag:Bool = true
    @IBAction func starButton(_ sender: Any)
    {
        if flag == true {
            starButton.setImage(UIImage(named: "star"), for: .normal)
            flag = false
        } else {
            starButton.setImage(UIImage(named: "blankstar"), for: .normal)
            flag = true
        }
    }

    @IBAction func incorrectButton(_ sender: Any)   {
        let countWords:Int = dataCenter.studyList[selectedSubject].unitList[selectedUnit].allWords.count

        if qIndex < countWords {
            dataCenter.studyList[selectedSubject].unitList[selectedUnit].allWords[qIndex].odapCount += 1
        }
        incorrectButton.isEnabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

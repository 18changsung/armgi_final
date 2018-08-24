//
//  WordTableViewController.swift
//  amgi
//
//  Created by CAUAD09 on 2018. 8. 3..
//  Copyright © 2018년 NEURRRI. All rights reserved.
//

import UIKit

protocol WordsCellDelegate : class {
    func DidTapStar(_ sender: WordsCell)
}

class WordsCell: UITableViewCell {

    @IBOutlet weak var explanationText: UITextView!
    @IBOutlet weak var keywordLabel: UILabel!
    @IBOutlet weak var starButton: UIButton!

    weak var delegate: WordsCellDelegate?

    @IBAction func starTapped(_ sender: Any) {
        delegate?.DidTapStar(self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

class WordTableViewController: UITableViewController, UITextFieldDelegate, WordsCellDelegate{

    @IBOutlet weak var selectedSubjectName: UILabel!
    @IBOutlet weak var selectedUnitName: UILabel!
    @IBOutlet weak var newKeyword: UITextField!
    @IBOutlet weak var newExplanation: UITextView!

    var selectedSubject:Int = 0
    var selectedUnit:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        newExplanation.placeholder = "설명" // 텍스트필드 값
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap) // 키보드
        
        selectedSubjectName.text = dataCenter.studyList[selectedSubject].subjectName
        selectedUnitName.text = dataCenter.studyList[selectedSubject].unitList[selectedUnit].unitName
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //키보드 완료 버튼 누르면 키보드 숨기기.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    //화면 클릭시 키보드 자동 내려가기 // viewDidload() let Tap 부분도 필요함
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let oneUnitDataCount = dataCenter.studyList[selectedSubject].unitList[selectedUnit].allWords.count
        if  oneUnitDataCount > 0 {
            return oneUnitDataCount
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "keywordSet", for: indexPath)

        guard let wordCell = cell as? WordsCell else{
            return cell
        }
        let wordSet = dataCenter.studyList[selectedSubject].unitList[selectedUnit].allWords[indexPath.row]
        wordCell.keywordLabel?.text = wordSet.keyword
        wordCell.explanationText?.text = wordSet.explanation

        wordCell.delegate = self

        if wordSet.starFlag == false {
            wordCell.starButton.setImage(UIImage(named: "star"), for: .normal)
        } else{
            wordCell.starButton.setImage(UIImage(named: "blankstar"), for: .normal)
        }
        return wordCell
    }

    func DidTapStar(_ sender: WordsCell) {
        guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
        if dataCenter.studyList[selectedSubject].unitList[selectedUnit].allWords[tappedIndexPath.row].starFlag == true {
            dataCenter.studyList[selectedSubject].unitList[selectedUnit].allWords[tappedIndexPath.row].starFlag = false
        } else {
            dataCenter.studyList[selectedSubject].unitList[selectedUnit].allWords[tappedIndexPath.row].starFlag = true
        }
        self.tableView.reloadData()
    }
    
    @IBAction func saveNewWordSetButton(_ sender: Any) {
        if let newKeyword = self.newKeyword.text, let newExplanation = self.newExplanation.text {
            if newKeyword == "" || newExplanation == "" {
                //빈 텍스트일 때
            } else {
                dataCenter.studyList[selectedSubject].unitList[selectedUnit].allWords.insert(Words(keyword: newKeyword, explanation: newExplanation), at: 0)
                    self.newKeyword.becomeFirstResponder() //생성칸 누르고 나면 자동으로 위로 가는 함수
            }
        }
        self.newKeyword.text = nil
        self.newExplanation.text = nil
        self.tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "삭제") { (action, indexPath) in
            dataCenter.studyList[self.selectedSubject].unitList[self.selectedUnit].allWords.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        let star = UITableViewRowAction(style: .normal, title: "별표") { (action, indexPath) in
            if dataCenter.studyList[self.selectedSubject].unitList[self.selectedUnit].allWords[indexPath.row].starFlag == true || dataCenter.studyList[self.selectedSubject].unitList[self.selectedUnit].allWords[indexPath.row].starFlag == nil {
                // 이렇게 nil 처리 안하면 계속 true로 초기화 됨
                let starCell = self.tableView.cellForRow(at: indexPath) as! WordsCell
                starCell.starButton.setImage(UIImage(named: "star"), for: .normal)
                dataCenter.studyList[self.selectedSubject].unitList[self.selectedUnit].allWords[indexPath.row].starFlag = false
            }
            else { // 별표 한 번 더 누르면 해제
                let starCell = self.tableView.cellForRow(at: indexPath) as! WordsCell
                starCell.starButton.setImage(UIImage(named: "blankstar"), for: .normal)
                dataCenter.studyList[self.selectedSubject].unitList[self.selectedUnit].allWords[indexPath.row].starFlag = true
            }
        }
        star.backgroundColor = UIColor().colorFromHex("#F9C835")
        return [delete, star]
    }
}

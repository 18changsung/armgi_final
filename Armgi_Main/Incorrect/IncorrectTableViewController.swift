//
//  IncorrectTableViewController.swift
//  Armgi_Main
//
//  Created by Tars on 8/14/18.
//  Copyright © 2018 sspog. All rights reserved.
//

import UIKit

class IncorrectCell: UITableViewCell {
    @IBOutlet weak var odapTV: UITextView!
    @IBOutlet weak var odapCountLabel: UILabel!
}

class IncorrectTableViewController: UITableViewController {

    var selectedSubject:Int = 0
    var selectedUnit:Int = 0
    var selectedOdap:Int = 0

    var odapList:[String] = []
    var odapMoreThree:[Int] = []

    var wordsIndex:[Int] = []
    var sentencesIndex:[Int] = []

    @IBOutlet weak var noDataView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = self.editButtonItem
        if selectedOdap < 3 {
            self.navigationItem.title = "\(selectedOdap)회"
        } else {
            self.navigationItem.title = "3회 이상"
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        
        let wordsData = dataCenter.studyList[selectedSubject].unitList[selectedUnit].allWords
        let sentencesData = dataCenter.studyList[selectedSubject].unitList[selectedUnit].allSentences

        var idx = 0
        for item in wordsData {
            if item.odapCount == selectedOdap {
                odapList.append("\(item.keyword)\r\n\(item.explanation)")
                wordsIndex.append(idx)
                if selectedOdap == 3 {
                    odapMoreThree.append(3)
                }
            } else if item.odapCount > 3 && selectedOdap == 3 {
                odapList.append("\(item.keyword)\r\n\(item.explanation)")
                odapMoreThree.append(item.odapCount)
                wordsIndex.append(idx)
            }
            idx += 1
        }

        idx = 0
        for item in sentencesData {
            if item.odapCount == selectedOdap {
                odapList.append("\(item.sentences)")
                sentencesIndex.append(idx)
                if selectedOdap == 3 {
                    odapMoreThree.append(3)
                }
            } else if item.odapCount > 3 && selectedOdap == 3 {
                odapList.append("\(item.sentences)")
                sentencesIndex.append(idx)
                odapMoreThree.append(item.odapCount)
            }
            idx += 1
        }

        // 만약 오답노트에 추가한 것이 없다면?
        if odapList.count == 0 {
            self.view = noDataView
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return odapList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "odapCell", for: indexPath)

        guard let odapCell = cell as? IncorrectCell else {
            return cell
        }

        odapCell.odapTV.text = odapList[indexPath.row]

        if selectedOdap == 3 {
            odapCell.odapCountLabel.text = String(odapMoreThree[indexPath.row]) + " 회"
        } else {
            odapCell.odapCountLabel.text = ""
        }

        return odapCell
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "삭제") { (action, indexPath) in
            // 실질적인 삭제. odapCount를 0으로 초기화.
            if indexPath.row < self.wordsIndex.count {
                dataCenter.studyList[self.selectedSubject].unitList[self.selectedUnit].allWords[self.wordsIndex[indexPath.row]].odapCount = 0
                self.wordsIndex.remove(at: indexPath.row)
            } else {
                dataCenter.studyList[self.selectedSubject].unitList[self.selectedUnit].allSentences[self.sentencesIndex[indexPath.row - self.wordsIndex.count]].odapCount = 0
                self.sentencesIndex.remove(at: indexPath.row - self.wordsIndex.count)
            }
            // 오답노트에 있는거 삭제.
            self.odapList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }

        return [delete]
    }
}

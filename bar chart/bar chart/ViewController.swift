//
//  ViewController.swift
//  bar chart
//
//  Created by sushmitha raja on 28/08/17.
//  Copyright © 2017 sush. All rights reserved.
//

import UIKit
import Charts
class ViewController: UIViewController {

    @IBOutlet weak var barChartView: BarChartView!
    var textArray = [String]()
    var wordsCountArray = [Int]()
    var sentenceCountArray = [Int]()
    var wordListArray = [String]()
    var word = [Int]()
    var sentence = [Int]()
    var keyArr = [String]()
    var valArr = [String]()
    override func viewDidLoad() {
        do {
            if let file = Bundle.main.url(forResource: "Tips", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
//                    print(object)
                    if let results = object["results"] as? [[String:Any]] {
//                        print(results)
                        for i in 0..<results.count{
                            let result = results[i]
                            if let text = result["text"]
                            {
                                self.textArray.append(text as! String)
//                                         print(text)
                                let wordList = (text as AnyObject).components(separatedBy: .punctuationCharacters).joined().components(separatedBy: " ").filter{!$0.isEmpty}
                                wordListArray += wordList
//                                print(wordList)
//                                print(wordList.count)
                                self.wordsCountArray.append(wordList.count)
                                let sentenceList = (text as AnyObject).components(separatedBy: ".").filter{!$0.isEmpty}
//                                print(sentenceList)
//                                print(sentenceList.count)
                                self.sentenceCountArray.append(sentenceList.count)
                            }

                        }
                    }
                }
                else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
//        print(wordsCountArray)
        let sumArray = wordsCountArray.reduce(0, { $0 + $1 })
        let avgArray = sumArray / wordsCountArray.count
        word.append(avgArray)
//        print(avgArray)
//        print(sumArray)
//        print(sentenceCountArray)
        let sumArraySen = sentenceCountArray.reduce(0, {$0 + $1 })
        let avgArraySen = sumArraySen / sentenceCountArray.count
        sentence.append(avgArraySen)
//        print(sumArraySen)
//        print(avgArraySen)
        }
    
    
    override func viewDidAppear(_ animated: Bool) {
        let alertView = UIAlertController(title: "Average No of Words & Average No of Sentences",
                                          message: "Words:\(word) Sentences:\(sentence)", preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil)
        alertView.addAction(action)
        self.present(alertView, animated: true, completion: nil)
        
        var times = [String:Int]()
        for i in wordListArray {
            times[i] = (times[i] ?? 0) + 1
        }
        let descending = times.sorted(by: {$0.1 > $1.1})
//        print(descending)
        let firstFifty = descending[0..<50]
//        print(firstFifty)
        for (key, value) in firstFifty {
            keyArr.append("\(key)")
            valArr.append("\(value)")
        }
        print(keyArr)
        print(valArr)
        setChart(forX: keyArr,forY: valArr)

        }

    func setChart(forX: [String], forY: [String]) {
        barChartView.noDataText = "You need to provide data for the chart."
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<forX.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(forY[i])! , data: forX as AnyObject?)
//            print(dataEntry )
            dataEntries.append(dataEntry)
        }
    
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "\(keyArr)")
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
    }
    }




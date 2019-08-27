//
//  AddQuestViewController.swift
//  TestTrashQuest
//
//  Created by student on 27/08/2019.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit
import Firebase

class AddQuestViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var streetNumberTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var zipcodeTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var privateLabel: UILabel!
    @IBOutlet weak var privateSwitch: UISwitch!
    
    private var datePicker: UIDatePicker?
    var type = ["Water", "Land"]
    var db: Firestore?
    var refDoc: DocumentReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        //set switch to unlocked
        privateSwitch.isOn = false
        
        //setRoundBorder privateLayer
        privateLabel.layer.cornerRadius = 10
        
        //set pickerView for type choosing
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.backgroundColor = .white
        pickerView.tintColor = .gray
        typeTextField.inputView = pickerView
        
        //set date picker
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .dateAndTime
        datePicker!.backgroundColor = .white
        datePicker!.tintColor = .gray
        datePicker?.addTarget(self, action: #selector(AddQuestViewController.dateChanged(datePicker:)), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddQuestViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        dateTextField.inputView = datePicker

    }
    
    func getPrivateValue() -> Bool {
        if privateSwitch.isOn {
            return true
        } else {return false}
    }
    
    //dismiss date picker when click elsewhere on screen
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    //update text field with date picker data
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        dateTextField.text = dateFormatter.string(from: datePicker.date)
        //view.endEditing(true)
    }
    
    //number of column in pickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //number of row in pickerview's column(s)
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return type.count
    }
    
    //name of the rows
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return type[row]
    }
    
    //display pickerview data in textfield
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeTextField.text = type[row]
    }
    
    //dismiss pickerView
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    @IBAction func addCollectButton(_ sender: Any) {
        let collectTitle = titleTextField.text
        let collectType = typeTextField.text
        let collectDate = dateTextField.text
        let collectStreetNumber = streetNumberTextField.text
        let collectStreetName = streetTextField.text
        let collectZipcode = zipcodeTextField.text
        let collectCity = cityTextField.text
        let collectComment = commentTextField.text
        let collectPrivat = getPrivateValue()
        if let collectTitle = collectTitle, let collectType = collectType, let collectDate = collectDate, let collectStreetNumber = collectStreetNumber, let collectStreetName = collectStreetName, let collectZipcode = collectZipcode, let collectCity = collectCity {
            let postData: [String: Any?] = ["title": collectTitle, "type": collectType, "date": collectDate, "streetNumber": collectStreetNumber, "streetName": collectStreetName, "zipcode": collectZipcode, "city": collectCity, "comment": collectComment, "privat": collectPrivat]
            refDoc = db?.collection("collect").addDocument(data: postData) { (error) in
                if let error = error {
                    print("unable to add document to Firestore + \(error)")
                }
                else {
                    print("Document has been added to Firestore + \(self.refDoc?.documentID)")
                }
            }
        }
        else {
            Toast.show(message: "Sorry but your quest is missing informations", controller: self)
        }
    }
    
    
    

}

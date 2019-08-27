//
//  AddQuestViewController.swift
//  TestTrashQuest
//
//  Created by student on 27/08/2019.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class AddQuestViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var privateLabel: UILabel!
    @IBOutlet weak var typeTextField: UITextField!
    
    private var datePicker: UIDatePicker?
    var type = ["Water", "Land"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

}

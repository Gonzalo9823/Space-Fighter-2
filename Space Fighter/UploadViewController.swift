//
//  UploadViewController.swift
//  Space Fighter
//
//  Created by Gonzalo Caballero on 8/2/16.
//  Copyright © 2016 Gonzalo Caballero. All rights reserved.
//

import UIKit

class UploadViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBAction func close(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet weak var selectCountry: UIPickerView!
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    let countries = ["Chile", "United States", "Afghanistan", "Albania", "Algeria", "American Samoa", "Andorra", "Angola", "Anguilla", "Antarctica", "Antigua and Barbuda", "Argentina", "Armenia", "Aruba", "Australia", "Austria", "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados", "Belarus", "Belgium", "Belize", "Benin", "Bermuda", "Bhutan", "Bolivia", "Bosnia and Herzegowina", "Botswana", "Bouvet Island", "Brazil", "British Indian Ocean Territory", "Brunei Darussalam", "Bulgaria", "Burkina Faso", "Burundi", "Cambodia", "Cameroon", "Canada", "Cape Verde", "Cayman Islands", "Central African Republic", "Chad", "China", "Christmas Island", "Cocos (Keeling) Islands", "Colombia", "Comoros", "Congo", "Congo, the Democratic Republic of the", "Cook Islands", "Costa Rica", "Cote d'Ivoire", "Croatia (Hrvatska)", "Cuba", "Cyprus", "Czech Republic", "Denmark", "Djibouti", "Dominica", "Dominican Republic", "East Timor", "Ecuador", "Egypt", "El Salvador", "Equatorial Guinea", "Eritrea", "Estonia", "Ethiopia", "Falkland Islands (Malvinas)", "Faroe Islands", "Fiji", "Finland", "France", "France Metropolitan", "French Guiana", "French Polynesia", "French Southern Territories", "Gabon", "Gambia", "Georgia", "Germany", "Ghana", "Gibraltar", "Greece", "Greenland", "Grenada", "Guadeloupe", "Guam", "Guatemala", "Guinea", "Guinea-Bissau", "Guyana", "Haiti", "Heard and Mc Donald Islands", "Holy See (Vatican City State)", "Honduras", "Hong Kong", "Hungary", "Iceland", "India", "Indonesia", "Iran (Islamic Republic of)", "Iraq", "Ireland", "Israel", "Italy", "Jamaica", "Japan", "Jordan", "Kazakhstan", "Kenya", "Kiribati", "Korea, Democratic People's Republic of", "Korea, Republic of", "Kuwait", "Kyrgyzstan", "Lao, People's Democratic Republic", "Latvia", "Lebanon", "Lesotho", "Liberia", "Libyan Arab Jamahiriya", "Liechtenstein", "Lithuania", "Luxembourg", "Macau", "Macedonia, The Former Yugoslav Republic of", "Madagascar", "Malawi", "Malaysia", "Maldives", "Mali", "Malta", "Marshall Islands", "Martinique", "Mauritania", "Mauritius", "Mayotte", "Mexico", "Micronesia, Federated States of", "Moldova, Republic of", "Monaco", "Mongolia", "Montserrat", "Morocco", "Mozambique", "Myanmar", "Namibia", "Nauru", "Nepal", "Netherlands", "Netherlands Antilles", "New Caledonia", "New Zealand", "Nicaragua", "Niger", "Nigeria", "Niue", "Norfolk Island", "Northern Mariana Islands", "Norway", "Oman", "Pakistan", "Palau", "Panama", "Papua New Guinea", "Paraguay", "Peru", "Philippines", "Pitcairn", "Poland", "Portugal", "Puerto Rico", "Qatar", "Reunion", "Romania", "Russian Federation", "Rwanda", "Saint Kitts and Nevis", "Saint Lucia", "Saint Vincent and the Grenadines", "Samoa", "San Marino", "Sao Tome and Principe", "Saudi Arabia", "Senegal", "Seychelles", "Sierra Leone", "Singapore", "Slovakia (Slovak Republic)", "Slovenia", "Solomon Islands", "Somalia", "South Africa", "South Georgia and the South Sandwich Islands", "Spain", "Sri Lanka", "St. Helena", "St. Pierre and Miquelon", "Sudan", "Suriname", "Svalbard and Jan Mayen Islands", "Swaziland", "Sweden", "Switzerland", "Syrian Arab Republic", "Taiwan, Province of China", "Tajikistan", "Tanzania, United Republic of", "Thailand", "Togo", "Tokelau", "Tonga", "Trinidad and Tobago", "Tunisia", "Turkey", "Turkmenistan", "Turks and Caicos Islands", "Tuvalu", "Uganda", "Ukraine", "United Arab Emirates", "United Kingdom", "United States Minor Outlying Islands", "Uruguay", "Uzbekistan", "Vanuatu", "Venezuela", "Vietnam", "Virgin Islands (British)", "Virgin Islands (U.S.)", "Wallis and Futuna Islands", "Western Sahara", "Yemen", "Yugoslavia", "Zambia", "Zimbabwe"]
    
    
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var puntaje: UILabel!
    @IBOutlet weak var pais: UILabel!
    @IBOutlet weak var uploadButton: UIButton!
    
    var espanol = false
    let pre = NSLocale.preferredLanguages()[0]
    
    var score: Int = 0
    
    enum Dificulty: String {
        case Easy = "Easy"
        case Medium = "Medium"
        case Hard = "Hard"
    }
    
    var currentDificulty: Dificulty = .Medium
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer?
        tap = UITapGestureRecognizer(target: self, action: #selector(UploadViewController.dismissKeyboard))
        view.addGestureRecognizer(tap!)
        
        selectCountry.delegate = self
        selectCountry.dataSource = self
        
        if (pre.rangeOfString("es") != nil) {
            espanol = true
        }
        
        if let estado = defaults.objectForKey("Dificultad") as? String {
            currentDificulty = Dificulty(rawValue: estado)!
        }
        
        if espanol {
            titulo.text! = "Subir mejor puntaje"
            titulo.adjustsFontSizeToFitWidth = true
            nombre.text! = "Nombre:"
            //puntaje.text! = "Tu puntaje:"
            pais.text! = "Pais:"
            let subirImagen = UIImage(named: "subir")
            uploadButton.setImage(subirImagen!, forState: .Normal)
            
            switch currentDificulty  {
            case .Easy:
                puntaje.text! = "Tu puntaje: \(defaults.integerForKey("bestScoreEasy"))"
            case .Medium:
                puntaje.text! = "Tu puntaje: \(defaults.integerForKey("bestScore"))"
            case .Hard:
                puntaje.text! = "Tu puntaje: \(defaults.integerForKey("bestScoreHard"))"
            }
        }
        
        switch currentDificulty {
        case .Easy:
            puntaje.text! = "Your high score: \(defaults.integerForKey("bestScoreEasy"))"
        case .Medium:
            puntaje.text! = "Your high score: \(defaults.integerForKey("bestScore"))"
        case .Hard:
            puntaje.text! = "Your high score: \(defaults.integerForKey("bestScoreHard"))"
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func uploadButtonAction(sender: AnyObject) {
        
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countries[row]
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let titleData = countries[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
        
        return myTitle
    }
    
}

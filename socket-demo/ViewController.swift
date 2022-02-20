//
//  ViewController.swift
//  socket-demo
//
//  Created by LAP11353 on 19/02/2022.
//

import UIKit

class ViewController: UIViewController {

    // MARK: View properties
    @IBOutlet weak var bubbleTableView: UITableView!
    @IBOutlet weak var chatBar: UITextField!
    @IBOutlet weak var roomCodeTextField: UITextField!
    
    
    // MARK: Model
    var messages : [String] = []
    var inputText : String = ""
    var inputCode : String = ""
    
    // MARK: Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupChatBar()
        setupInputCode()
    }
    //MARK: Setups
    func setupTableView(){
        bubbleTableView.delegate = self
        bubbleTableView.dataSource = self
    }
    
    func setupChatBar(){
        chatBar.delegate = self
    }
    
    func setupInputCode(){
        roomCodeTextField.delegate = self
    }

    func sendMessage(_ content: String){
        messages.append(content)
        let r = messages.count - 1
        DispatchQueue.main.async{
            self.bubbleTableView.insertRows(at: [IndexPath(row: r, section: 0)], with: .bottom)
            
        }
    }
}

extension ViewController : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let textFieldText = textField.text ?? ""
            let text = (textFieldText as NSString).replacingCharacters(in: range, with: string)
        
        if string == "\n"{
            print("submit")
            if textField == chatBar {
                // send msg
                self.sendMessage(textFieldText)
            }
            if textField == roomCodeTextField {
                // connect to room ...
            }
            textField.text = ""
            return false
        }
        if textField == chatBar {
            inputText = text
        }
        if textField == roomCodeTextField {
            inputCode = text
        }
        return true
    }
}

extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "BubbleCell",for: indexPath)
        cell.textLabel?.text = messages[indexPath.row]
        return cell
    }
}

extension ViewController : UITableViewDelegate {
    
}


//
//  AddTaskViewController.swift
//  ListaTareasCoreData
//
//  Created by Mac16 on 20/01/21.
//

import UIKit
import CoreData

var LibroArray = [String]()
var dateArray = [String]()

class AddTaskViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    

    @IBOutlet weak var spinerOutlet: UIPickerView!
    @IBOutlet weak var spinerDateOutlet: UIDatePicker!
    @IBOutlet weak var btnSaveOutlet: UIButton!
    
    var selectLibro = ""
    
    var libro = ["SELECCIONA UNA CATEGORIA", "Accion", "Aventura", "Clasicos", "Humos", "Misterio", "Poesia", "Romance", "Terror", "Novela", "Espiritual"]
    
    var dateFormatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinerOutlet.dataSource = self
        spinerOutlet.delegate = self
        
        btnSaveOutlet.isEnabled = false
        
        dateFormatter.dateFormat = "dd/MMM/yyyy - HH:mm"
        
        spinerDateOutlet.minimumDate = Date()

        // Do any additional setup after loading the view.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return libro.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return libro[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            btnSaveOutlet.isEnabled = false
        }else{
            btnSaveOutlet.isEnabled = true
            selectLibro = libro[row]
        }
        
    }

   

    @IBAction func saveBtnAction(_ sender: Any) {
        let date = spinerDateOutlet.date
        print(date)
        
        let dateStr = dateFormatter.string(from: date)
        print(dateStr)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let taskEntity = NSEntityDescription.entity(forEntityName: "Task", in: managedContext)!
        
        let task = NSManagedObject(entity: taskEntity, insertInto: managedContext)
        task.setValue(selectLibro, forKeyPath: "tarea")
        task.setValue(dateStr, forKeyPath: "date")
        task.setValue(false, forKey: "status")
        
        do {
            try managedContext.save()
            print("Guardandooo los datos")
        } catch let error as NSError {
            print("No se pudieron guardar. \(error), \(error.localizedDescription)")
        }
        
        
        
       
    
        LibroArray.append(selectLibro)
        dateArray.append(dateStr)
        print(LibroArray,dateArray)
        
        navigationController?.popViewController(animated: true)
    }
}

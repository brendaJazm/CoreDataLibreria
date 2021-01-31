//
//  ViewController.swift
//  ListaTareasCoreData
//
//  Created by Mac16 on 20/01/21.
//
import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var segmentOutlet: UISegmentedControl!
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LibroArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = "\(indexPath.row + 1). \(LibroArray[indexPath.row])"
        
        cell.detailTextLabel?.text = "\(dateArray[indexPath.row])"
        
        if ((indexPath.row + 1) % 2) == 0 {
            cell.backgroundColor = UIColor.init(displayP3Red: 191/255, green: 179/255, blue: 216/255, alpha: 1)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if segmentOutlet.selectedSegmentIndex == 0 {
            if editingStyle == .delete {
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
                
                let managedContext = appDelegate.persistentContainer.viewContext
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
                fetchRequest.predicate = NSPredicate(format:"tarea = %@", LibroArray[indexPath.row])
                
                do{
                    let test = try managedContext.fetch(fetchRequest)
                    
                    let objectUpdate = test[0] as! NSManagedObject
                    objectUpdate.setValue(true, forKey: "status")
                    
                    do {
                        try managedContext.save()
                        LibroArray.remove(at: indexPath.row)
                        dateArray.remove(at: indexPath.row)
                        tableViewOutlet.deleteRows(at: [indexPath], with: .automatic)
                    }catch {
                        print("error: \(error)")
                    }
                }catch{
                    print(error)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewOutlet.dataSource = self
        getCore(false)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCore(false)
        tableViewOutlet.reloadData()
    }
    
    func getCore(_ bandera: Bool){
        LibroArray.removeAll()
        dateArray.removeAll()
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
            fetchRequest.predicate = NSPredicate(format:"status = %@", NSNumber(value: bandera))
            do {
                let result = try managedContext.fetch(fetchRequest)
                for data in result as! [NSManagedObject]{
                    LibroArray.append(data.value(forKey: "tarea") as! String)
                    dateArray.append(data.value(forKey: "date") as! String)
                    tableViewOutlet.reloadData()
                }
            } catch {
                print("Erroooor \(error)")
            }
    }

    @IBAction func segmentChangeAction(_ sender: Any) {
        print(segmentOutlet.selectedSegmentIndex)
        
        if segmentOutlet.selectedSegmentIndex == 1 {
            print("Libros sin leer")
            getCore(true)
            tableViewOutlet.reloadData()
        } else {
            getCore(false)
            print("Libros Leidos")
            tableViewOutlet.reloadData()
        }
    }
}

//
//  ViewController.swift
//  BucketListAPI
//
//  Created by Ashwin Mahesh on 7/16/18.
//  Copyright © 2018 AshwinMahesh. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var tableData:[String]=[]
    var ids:[Int]=[]
    
    @IBAction func addPushed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "AddSegue", sender: "add")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        getAllTasks()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(_ animated: Bool) {
        tableData = []
        getAllTasks()
    }

    func getAllTasks(){
        let url=URL(string: "http://192.168.1.228:8000/getTasks/")
        let session = URLSession.shared
        let task = session.dataTask(with: url!, completionHandler:{
            data, response, error in
//            print(data)
            do{
                if let jsonResult = try JSONSerialization.jsonObject(with:data!, options: .mutableContainers) as? NSDictionary{
//                    print(jsonResult)
                    let tasks = jsonResult["tasks"] as! NSMutableArray
                    for task in tasks{
                        let taskFixed = task as! NSDictionary
                        self.tableData.append(taskFixed["name"] as! String)
                        self.ids.append(taskFixed["id"] as! Int)
                    }
                    DispatchQueue.main.async{
                        self.tableView.reloadData()
                    }
                }
            }
            catch{
                print(error)
            }
        })
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPathRow = sender as? Int{
                let nav = segue.destination as! UINavigationController
                let dest = nav.topViewController as! AddEditVC
                dest.edit = true
                dest.taskID = ids[indexPathRow]
                dest.oldText = tableData[indexPathRow]
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath)
        cell.textLabel?.text = tableData[indexPath.row]
        cell.detailTextLabel?.text = String(ids[indexPath.row])
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "AddSegue", sender: indexPath.row)
    }
}


//
//  ViewController.swift
//  07_TodoApp
//
//  Created by user on 2021/08/24.
//

import UIKit
import CoreData


enum PriorityLevel: Int64{
  //  자동으로 순번이 설정됨
  //  rowValue <-- 0, 1, 2
  case level1
  case level2
  case level3
}

extension PriorityLevel{
  var color: UIColor{
    switch self{
      case .level1:
        return .brown
      case .level2:
        return .yellow
      case .level3:
        return .red
    }
  }
}


class ViewController: UIViewController {
  
  
  @IBOutlet weak var todoTableView: UITableView!
  
  var todoList = [TodoList]()
  
  // UIApplication : App 의  life cycle 이 설정되어 있음
  // Singleton Pattern
  let appdelegate = UIApplication.shared.delegate as! AppDelegate
  

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "해야 할 일을 메모하세요."
    makeNavigationBar()
    
    todoTableView.delegate = self
    todoTableView.dataSource = self
    
    // appdelegate.persistentContainer.viewContext
    
    // Entity(table) 에서 data 가져오기
    fetchData()
    
    // 화면 갱신하기
    todoTableView.reloadData()
    
    
    
  }
  
  // data 가져오기
  // core data로서 local storage에 있는 data를 가져옴
  
  func fetchData(){
   
    // TodoList Entity 에 있는 data 가져오는 설정
    let fetchRequest: NSFetchRequest<TodoList> = TodoList.fetchRequest()
    let context = appdelegate.persistentContainer.viewContext
    
    do{
          
      self.todoList = try context.fetch(fetchRequest)
            
    }catch{
      print(error)
    }
    
  }
  
  
  
  func makeNavigationBar(){
    let item = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTodo))
    item.tintColor = .black
    navigationItem.rightBarButtonItem = item
        
    // navigation 영역 색상 지정하기
    let barAppearance = UINavigationBarAppearance()
    //barAppearance.backgroundColor = .blue.withAlphaComponent(0.2)
    barAppearance.backgroundColor = UIColor(red: 180/255, green: 40/255, blue: 0/255, alpha: 0.5)
    //barAppearance.backgroundColor = UIColor(displayP3Red: 130/255, green: 200/255, blue: 45/255, alpha: 0.5)
      
    self.navigationController?.navigationBar.standardAppearance = barAppearance
    
  }
  
  // + button 눌렀을 때 호출됨
  @objc func addNewTodo(){
    
    let detailVC = TableDetailViewController.init(nibName: "TableDetailViewController", bundle: nil)
    
    // ViewController(self)하고
    // TableDetailViewController 연결하기
    detailVC.delegate = self
    
    self.present(detailVC, animated: true, completion: nil)
    
  }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.todoList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoCell
    
    cell.topTItleLabel.text = todoList[indexPath.row].title
    
    if let hasDate = todoList[indexPath.row].date{
      let formatter = DateFormatter()
      formatter.dateFormat = "MM-dd hh:mm:ss"
      let dateString = formatter.string(from: hasDate)
      cell.dateLabel.text = dateString
      
    }else{
      cell.dateLabel.text = ""
    }
    
    // todoList (Entity) 에서 priotityLevel 속성값을 가져옴
    let priority = todoList[indexPath.row].priorityLevel

    // local DB에서 가져온 priority 값을   rowValue 로 설정해서
    // switch  문에서 지정한 색상을 가져옴
    let priorityColor = PriorityLevel(rawValue: priority)?.color
    
    // priorityColor 에 저장된 색상을 화면에 나타나게 함
    cell.priorityView.backgroundColor = priorityColor
    
    // cell image view 모양을 둥글게 하기
    cell.priorityView.layer.cornerRadius = cell.priorityView.bounds.height / 2
    
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    let detailVC = TableDetailViewController.init(nibName: "TableDetailViewController", bundle: nil)
    
    // ViewController(self)하고
    // TableDetailViewController 연결하기
    detailVC.delegate = self
    detailVC.selectedTodoList = todoList[indexPath.row]
    
    self.present(detailVC, animated: true, completion: nil)
    
    
  }
  
}

extension ViewController: TableDetailViewControllerDelegate{
  
  func didFinishSaveData() {
    // 저장한 data 불러오기
    self.fetchData()
    // 화면(tableView) 갱신하기
    self.todoTableView.reloadData()
  }
  
  
}

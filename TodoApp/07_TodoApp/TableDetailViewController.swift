//
//  TableDetailViewController.swift
//  07_TodoApp
//
//  Created by user on 2021/08/24.
//

import UIKit
import CoreData


protocol TableDetailViewControllerDelegate: AnyObject{
  
  // 저장이 되는 시점에 호출함
  func didFinishSaveData()
  
}


class TableDetailViewController: UIViewController {
  
  weak var delegate: TableDetailViewControllerDelegate?
  
  @IBOutlet weak var titleTextView: UITextField!
  
  @IBOutlet weak var lowButton: UIButton!
  
  @IBOutlet weak var normalButton: UIButton!
  
  @IBOutlet weak var highButton: UIButton!
  
  var priority: PriorityLevel?
  
  var selectedTodoList: TodoList?
  
  @IBOutlet weak var saveButton: UIButton!
  
  @IBOutlet weak var deleteButton: UIButton!
  
  
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  

  override func viewDidLoad() {
      super.viewDidLoad()

  }
  
  // 화면이 나타나기 시작할 때
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // text field에 가져온 값들을 setting함
    // 선택해서 가져온 값이 있는 경우에만 실행하도록 함
    //  ㄴ 이미 있는 일정을 불러와서 수정하거나 삭제하는 경우
    if let hasData = selectedTodoList{
      
      titleTextView.text = hasData.title
      
      //  선택한 data안에 있는 값으로 설정하기
      priority = PriorityLevel(rawValue: hasData.priorityLevel)
      
      makePriorityButtonDesign()
      
      saveButton.setTitle("수정하기", for: .normal)
      deleteButton.isHidden = false
      
      
    }else{  // 가져온 값이 없는 경우 <- 일정을 추가하는 경우
      deleteButton.isHidden = true
      saveButton.setTitle("저장하기", for: .normal)
      
    }
    
    
  }
  
  // 화면이 그려지고나서 버튼 모양 설정하기
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    lowButton.layer.cornerRadius = lowButton.bounds.height / 2
    normalButton.layer.cornerRadius = normalButton.bounds.height / 2
    highButton.layer.cornerRadius = highButton.bounds.height / 2
  }

  
  @IBAction func setPriority(_ sender: UIButton) {
    switch sender.tag{
      case 1:
        priority = .level1
      case 2:
        priority = .level2
      case 3:
        priority = .level3
      default:
        break
        
    }
    
    makePriorityButtonDesign()
    
  }
  
  func makePriorityButtonDesign(){
    
    lowButton.backgroundColor = .clear
    normalButton.backgroundColor = .clear
    highButton.backgroundColor = .clear
    
    switch self.priority{
      case .level1:
        lowButton.backgroundColor = priority?.color
      case .level2:
        normalButton.backgroundColor = priority?.color
      case .level3:
        highButton.backgroundColor = priority?.color
      default:
        break
        
    }
    
  }
  
  
  
  @IBAction func saveTodo(_ sender: Any) {
    
    
    if selectedTodoList != nil{
      updateTodo()
    }else{
      saveTodo()
    }
        
    // 화면 갱신
    //  ㄴ 새로운 일정이 입력된 화면이 보이게 하기
    delegate?.didFinishSaveData()
    
    // 일정 입력할 때 나온 화면 닫기(내리기)
    self.dismiss(animated: true)
    
    
  }
  
  func saveTodo(){
    guard let entityDescription = NSEntityDescription.entity(forEntityName: "TodoList", in: context) else{
      return
    }
    
    // NSManagedObject : Model 형태 그대로 가져옴
    guard let object = NSManagedObject(entity: entityDescription, insertInto: context) as? TodoList else{
      return
    }
    
    // Object 형태로 구조를 가져옴....
    object.title = titleTextView.text
    object.date = Date()
    object.uuid = UUID()
    
    // low, normal, high 중 하나를 눌렀을 때
    // 결정된 priority값을0 local DB 의
    // priorityLevel 속성에 저장함
    object.priorityLevel = priority?.rawValue ?? PriorityLevel.level1.rawValue
         
    // data 저장하기
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.saveContext()
    
    
  }
  
  func updateTodo(){
    // 수정할 data를 가져오기
    
    // 가져올 준비
    let fetchRequest: NSFetchRequest<TodoList> = TodoList.fetchRequest()
    
    // 선택한 것만 가져오기
    guard let hasData = selectedTodoList else {
      return
    }
    guard let hasUUID = hasData.uuid else {
      return
    }
    
    fetchRequest.predicate = NSPredicate(format: "uuid = %@", hasUUID as CVarArg)
    
    // context.fetch() 호출해서 위의 조건에 해당하는 레코드만 TodoList에서 가져오기
    do{
      let loadedData = try context.fetch(fetchRequest)
      
      loadedData.first?.title = titleTextView.text
      loadedData.first?.date = Date()
      loadedData.first?.priorityLevel = self.priority?.rawValue ?? PriorityLevel.level1.rawValue
      
      // data 저장하기
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      appDelegate.saveContext()
      
    }catch{
      print(error)
    }
    
    
    
  }
  
  @IBAction func deleteTodo(_ sender: UIButton){
    
    // 수정할 data를 가져오기
    
    // 가져올 준비
    let fetchRequest: NSFetchRequest<TodoList> = TodoList.fetchRequest()
    
    // 선택한 것만 가져오기
    guard let hasData = selectedTodoList else {
      return
    }
    guard let hasUUID = hasData.uuid else {
      return
    }
    
    fetchRequest.predicate = NSPredicate(format: "uuid = %@", hasUUID as CVarArg)
    
    // context.fetch() 호출해서 위의 조건에 해당하는 레코드만 TodoList에서 가져오기
    do{
      let loadedData = try context.fetch(fetchRequest)
      
      if let loadFirstData = loadedData.first{
        context.delete(loadFirstData)
        
        // data 저장하기
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.saveContext()
      }
      
      
      
    }catch{
      print(error)
    }
    
    // 화면 갱신
    //  ㄴ 새로운 일정이 입력된 화면이 보이게 하기
    delegate?.didFinishSaveData()
    
    // 일정 입력할 때 나온 화면 닫기(내리기)
    self.dismiss(animated: true)
    
  }
  
}



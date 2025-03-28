//
//  ViewController.swift
//  Gemiai
//
//  Created by dbug on 3/21/25.
//

import UIKit
import RxSwift

class HomeViewController: UIViewController, Storyboarded {
    weak var coordinator: AppCoordinator?

    @IBOutlet weak var tableView: MainTableView!
    
    let disposeBag = DisposeBag()
    var viewModel = HomeViewModel(geminiService: GeminiService(), chatDataManager: ChatDataManager())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupTableView()
        appendInitialData()
    }
    
    func appendInitialData() {
        viewModel.fetchMessages()
    }
    
    func setupView() {
        title = "Gemiai"
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: UIAction(handler: { [weak self] _ in
            self?.presentAlert()
            })
        )
    }
    
    func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "chatCell")
        
        viewModel.chats
            .bind(to: tableView.rx.items(cellIdentifier: "chatCell", cellType: UITableViewCell.self)) { row, item, cell in
                var content = cell.defaultContentConfiguration()
                
                content.text = item.message
                content.secondaryText = item.isUser ? "Sent" : "Received"
                cell.contentConfiguration = content
                
                cell.accessoryType = .none
                
            }
            .disposed(by: disposeBag)
    }
    
    func presentAlert() {
        showInputAlert(title: "Send a message", message: "", completion: { message in
            self.viewModel.sendMessage(message!)
        })
    }
    
    func showInputAlert(title: String, message: String, completion: @escaping (String?) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = message
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completion(nil)
        }
        
        let sendAction = UIAlertAction(title: "Send", style: .default) { [weak alertController] _ in
            let textField = alertController?.textFields?.first
            completion(textField?.text)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(sendAction)
        
        present(alertController, animated: true)
    
    }
}


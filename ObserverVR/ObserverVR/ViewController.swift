//
//  ViewController.swift
//  ObserverVR
//  https://youtu.be/jFKuMb6kILU
//  Created by Uri on 24/3/23.
//

import UIKit
import Combine

class ViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    var viewModel = ViewModel()
    var anyCancellable: [AnyCancellable] = []   // where to store the subscriptions
    var timer = Timer()
    var count = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscriptions()
        
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateViewTitle), userInfo: nil, repeats: true)
    }
    
    @objc func updateViewTitle(){
        count += 1
        if count > 10 {
            anyCancellable.removeAll()  // cancel the subscriptions
        }
        viewModel.updateTitle(newTitle: "New Title - Updated: \(count)")
    }
    
    func subscriptions(){
        viewModel.title.sink { _ in } receiveValue: {[weak self] title in  // -> sink creates the subscription
            // what happens when title sends a notification
            self?.titleLabel.text = title    // sets the text using the string coming from the observable
        }.store(in: &anyCancellable)
        
        viewModel.$color.sink { [weak self] color in
            self?.view.backgroundColor = color
        }.store(in: &anyCancellable)
    }
    
}

class ViewModel {
    // the observed subject (Observable)
    var title = PassthroughSubject<String, Error>()
    
    // another observable example
    @Published var color: UIColor = .black
    
    // the method to notify our subscriptors
    func updateTitle(newTitle: String) {
        self.title.send(newTitle)
        
        let colors: [UIColor] = [.black, .white, .blue, .systemPink, .red, .cyan]
        color = colors.randomElement() ?? .yellow
    }
}

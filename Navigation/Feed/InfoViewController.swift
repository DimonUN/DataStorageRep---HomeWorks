import UIKit

class InfoViewController: UIViewController {
    
    var button: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
        button.backgroundColor = UIColor.systemBlue
        button.setTitle("Alert", for: .normal)
        button.addTarget(self, action: #selector(donePressed), for: .touchUpInside)
        
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        button.center = view.center
        view.addSubview(button)
    }
    
    
    @objc func donePressed(sender: UIButton) {
        let alert = UIAlertController(title: "Attention", message: "Something wrong", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default,
                    handler: {(okAction) in print("Ok was pressed")})
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel,
                    handler: {(cancelAction) in print("Cancel was pressed")})
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
    }
}
   

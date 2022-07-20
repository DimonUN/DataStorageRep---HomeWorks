import UIKit

final class PostViewController: UIViewController {
    var firstPost: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        title = firstPost
        
        navigationController?.isNavigationBarHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(openInfoViewController)
        )
    }

    @objc func openInfoViewController(sender: UIBarButtonItem) {
        let modalInfoViewController = InfoViewController()
        present(modalInfoViewController, animated: true, completion: nil)
    }
}

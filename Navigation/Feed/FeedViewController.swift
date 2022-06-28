import UIKit

class FeedViewController: UIViewController {

    var networkRequest: UIButton = {
        let networkRequest = UIButton(type: .system)
        networkRequest.toAutoLayout()
        networkRequest.backgroundColor = .systemBlue
        networkRequest.setTitle("Create request", for: .normal)
        networkRequest.setTitleColor(.white, for: .normal)
        networkRequest.layer.cornerRadius = 20
        networkRequest.addTarget(
            self,
            action: #selector(buttonAction),
            for: .touchUpInside
        )
        return networkRequest
    }()

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            networkRequest.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            networkRequest.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            networkRequest.widthAnchor.constraint(equalToConstant: 150.0),
            networkRequest.heightAnchor.constraint(equalToConstant: 50.0)
        ])
    }

    private func setupUI() {
        view.backgroundColor = .white
        title = "Your feed"
        view.addSubview(networkRequest)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    @objc func buttonAction(sender: UIButton) {
        let infoViewController = InfoViewController()
        navigationController?.pushViewController(infoViewController, animated: true)
    }
}

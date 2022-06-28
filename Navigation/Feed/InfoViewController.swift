//
//  InfoViewController.swift
//  Navigation
//
//  Created by Дмитрий Никоноров on 28.06.2022.
//

import Foundation

import UIKit

final class InfoViewController: UIViewController {

    private var networkService = NetworkService()
    private var jsonModel = JSONModel(model: [:])

    private var planet: Planet?
    private var residents: [Residents] = []
    private var urlsToResidents: [URL] = []

    private enum Links {
        static let firstLink = "https://jsonplaceholder.typicode.com/todos/"
        static let secondLink = "https://swapi.dev/api/planets/1"
    }

    private enum CellIdentifiers: String {
        case residents
    }

    private lazy var modelLabel: UILabel = {
        let modelLabel = UILabel()
        modelLabel.toAutoLayout()
        modelLabel.textColor = .black
        modelLabel.textAlignment = .center
        modelLabel.numberOfLines = 0
        return modelLabel
    }()

    private lazy var orbitalPeriodLabel: UILabel = {
        let orbitalPeriodLabel = UILabel()
        orbitalPeriodLabel.toAutoLayout()
        orbitalPeriodLabel.textColor = .black
        orbitalPeriodLabel.textAlignment = .center
        orbitalPeriodLabel.numberOfLines = 0
        return orbitalPeriodLabel
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.toAutoLayout()
        tableView.separatorStyle = .singleLine
        tableView.indicatorStyle = .default
        tableView.backgroundColor = .systemGray6
        return tableView
    }()

    private lazy var firstLinkButton: UIButton = {
        let firstLinkButton = UIButton(type: .system)
        firstLinkButton.toAutoLayout()
        firstLinkButton.setTitle("Fetch data from first link", for: .normal)
        firstLinkButton.setTitleColor(.white, for: .normal)
        firstLinkButton.backgroundColor = .systemBlue
        firstLinkButton.layer.cornerRadius = 20.0
        firstLinkButton.addTarget(self, action: #selector(fetchDataFromFitstLink), for: .touchUpInside)
        return firstLinkButton
    }()

    private lazy var secondLinkButton: UIButton = {
        let secondLinkButton = UIButton(type: .system)
        secondLinkButton.toAutoLayout()
        secondLinkButton.setTitle("Fetch data from second link", for: .normal)
        secondLinkButton.setTitleColor(.white, for: .normal)
        secondLinkButton.backgroundColor = .systemCyan
        secondLinkButton.layer.cornerRadius = 20.0
        secondLinkButton.addTarget(self, action: #selector(fetchDataFromSecondLink), for: .touchUpInside)
        return secondLinkButton
    }()

    private lazy var thirdLinkButton: UIButton = {
        let secondLinkButton = UIButton(type: .system)
        secondLinkButton.toAutoLayout()
        secondLinkButton.setTitle("Fetch data from array of links", for: .normal)
        secondLinkButton.setTitleColor(.white, for: .normal)
        secondLinkButton.backgroundColor = .systemYellow
        secondLinkButton.layer.cornerRadius = 20.0
        secondLinkButton.addTarget(self, action: #selector(fetchDataFromThirdLink), for: .touchUpInside)
        return secondLinkButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupTableView()
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubviews(modelLabel, firstLinkButton, secondLinkButton, tableView, orbitalPeriodLabel, thirdLinkButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            modelLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            modelLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10.0),
            modelLabel.heightAnchor.constraint(equalToConstant: 60.0),
            modelLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            modelLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0),

            orbitalPeriodLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            orbitalPeriodLabel.topAnchor.constraint(equalTo: modelLabel.bottomAnchor, constant: 20.0),
            orbitalPeriodLabel.heightAnchor.constraint(equalToConstant: 20.0),

            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: orbitalPeriodLabel.bottomAnchor, constant: 20.0),
            tableView.bottomAnchor.constraint(equalTo: firstLinkButton.topAnchor, constant: -20.0),

            firstLinkButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            firstLinkButton.widthAnchor.constraint(equalToConstant: 250.0),
            firstLinkButton.heightAnchor.constraint(equalToConstant: 50.0),
            firstLinkButton.bottomAnchor.constraint(equalTo: secondLinkButton.topAnchor, constant: -20.0),

            secondLinkButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondLinkButton.widthAnchor.constraint(equalToConstant: 250.0),
            secondLinkButton.heightAnchor.constraint(equalToConstant: 50.0),
            secondLinkButton.bottomAnchor.constraint(equalTo: thirdLinkButton.topAnchor, constant: -20.0),

            thirdLinkButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            thirdLinkButton.widthAnchor.constraint(equalToConstant: 250.0),
            thirdLinkButton.heightAnchor.constraint(equalToConstant: 50.0),
            thirdLinkButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20.0)
        ])
    }

    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifiers.residents.rawValue)
        tableView.dataSource = self
    }

    @objc private func fetchDataFromFitstLink(_ sender: UIButton) {
        fetchTitle()
    }

    @objc private func fetchDataFromSecondLink(_ sender: UIButton) {
        fetchPlanet()
    }

    @objc private func fetchDataFromThirdLink(_ sender: UIButton) {
        fetchPlanetsResidents()

    }

    private func fetchTitle() {
        guard let url = URL(string: Links.firstLink) else { return }
        self.networkService.request(url: url) { [weak self] result in
            switch result {
            case.success(let data):
                do {
                    let object = try JSONSerialization.jsonObject(with: data, options: [])
                    if let array = object as? [[String: Any]] {
                        let randomInt = Int.random(in: 0...array.count - 1)
                        guard randomInt > 0 else { return }
                        self?.jsonModel.model = array[randomInt]
                        self?.modelLabel.text = self?.jsonModel.model["title"] as? String
                    }
                } catch let error {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    private func fetchPlanet() {
        guard let url = URL(string: Links.secondLink) else { return }
        self.networkService.request(url: url) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let planet = try JSONDecoder().decode(Planet.self, from: data)
                    self?.planet = planet
                    self?.orbitalPeriodLabel.text = "Orbital period is: \(planet.orbitalPeriod)"
                } catch let error {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    private func fetchPlanetsResidents() {
        guard let url = URL(string: Links.secondLink) else { return }
        self.networkService.request(url: url) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let planet = try JSONDecoder().decode(Planet.self, from: data)
                    self?.urlsToResidents = planet.linksForResidents
                    self?.fetchResidents()
                } catch let error {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    private func fetchResidents() {
        for url in urlsToResidents {
            self.networkService.request(url: url) { [weak self] result in
                switch result {
                case .success(let data):
                    do {
                        let resident = try JSONDecoder().decode(Residents.self, from: data)
                        self?.residents.append(resident)
                        self?.tableView.reloadData()
                    } catch let error {
                        print(error)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

extension InfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        residents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.residents.rawValue, for: indexPath)
        cell.textLabel?.text = residents[indexPath.row].name
        return cell
    }
}

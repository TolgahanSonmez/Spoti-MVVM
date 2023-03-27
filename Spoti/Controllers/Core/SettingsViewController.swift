//
//  SettingsViewController.swift
//  Spoti
//
//  Created by Tolgahan Sonmez on 27.02.2023.
//

import UIKit

class SettingsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
  
    private let tableView : UITableView = {
        let tableview = UITableView(frame: .zero, style: .grouped)
        tableview.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        return tableview
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        configureModels()
        
        
    }
    
    private var sections = [Sections]()
    
    private func configureModels() {
        sections.append(Sections(title: "Profil", options: [Option(title: "Profilini Gör", handler: { [weak self] in
            DispatchQueue.main.async {
                self?.viewProfile()
            }
        })]))
        
        sections.append(Sections(title: "Hesap", options: [Option(title: "Çıkış Yap", handler: { [weak self] in
            DispatchQueue.main.async {
                self?.signOutTapped()
            }
        })]))
        
    }
    
    private func viewProfile() {
        let vc = ProfileViewController()
        vc.title = "Profile"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func signOutTapped() {
        
        let alert = UIAlertController(title: "Çıkış Yap",
                                      message: "Emin misiniz?",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Vazgeç", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Çıkış Yap", style: .destructive, handler: { _ in
            AuthManager.shared.signOut { [weak self] signOut in
                if signOut {
                    DispatchQueue.main.async {
                        let navVC = UINavigationController(rootViewController: WelcomeViewController())
                        navVC.navigationBar.prefersLargeTitles = true
                        navVC.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
                        navVC.modalPresentationStyle = .fullScreen
                        self?.present(navVC, animated: true, completion: {
                            self?.navigationController?.popToRootViewController(animated: false)
                        })
                    }
                }
            }
        }))
        present(alert, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = sections[indexPath.section].options[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = sections[indexPath.section].options[indexPath.row]
        model.handler()
    }
}

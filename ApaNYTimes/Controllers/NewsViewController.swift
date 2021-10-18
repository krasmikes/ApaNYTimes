//
//  ViewController.swift
//  ApaNYTimes
//
//  Created by Apanasenko Mikhail on 11.10.2021.
//

import UIKit

class NewsViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var manager = NewsManager()
    var model: NewsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
        
        title = "Updating..."
        
        manager.delegate = self
        manager.readData()
    }

    @IBAction func updateButtonPressed(_ sender: UIButton) {
        title = "Updating..."
        manager.updateData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newsToArticlesSegue" {
            let index = tableView.indexPathForSelectedRow?.row ?? 0
            let articleViewController = segue.destination as! ArticleViewController
            
            articleViewController.index = index
            articleViewController.model = model
            articleViewController.manager = manager
        }
    }
}

extension NewsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (model?.data.num_results) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        if let article = model?.data.results[indexPath.row] {
            if let rawImageData = article.smallPicture {
                DispatchQueue.main.async {
                    cell.cellImageView.image = UIImage(data: rawImageData)
                }
            } else {
                manager.loadPicture(for: article, format: "Standard Thumbnail") { rawImageData, _, _ in
                    if let safeData = rawImageData {
                        self.model?.data.results[indexPath.row]?.smallPicture = safeData
                        self.manager.saveData(for: self.model!)
                        
                        DispatchQueue.main.async {
                            cell.cellImageView.image = UIImage(data: safeData)
                        }
                    }
                }
            }
            cell.cellArticleTitle.text = article.title
            cell.cellArticleAbstract.text = article.abstract
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "newsToArticlesSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
}

extension NewsViewController: NewsManagerDelegate {
    func didUpdateData(model: NewsModel) {
        self.model = model
        DispatchQueue.main.async {
            self.title = model.data.section
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        if let error = error as? URLError, error.code == URLError.Code.networkConnectionLost || error.code == URLError.Code.notConnectedToInternet {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Ошибка сети", message: "Нет подключения к интернету\nПопробуйте позже", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Неизвестная ошибка", message: "Обратитесь к разработчику\n \(error.localizedDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

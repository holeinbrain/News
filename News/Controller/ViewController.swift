//
//  ViewController.swift
//  News
//
//  Created by Anton Levin on 26.02.2021.
//

import UIKit
import SafariServices

class ViewController: UIViewController {
  
  private var articles = [Article]()
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    self.searchBar.delegate = self
    self.title = "Новости дня"
    getLatestNews()
    configureTableView()
  }
  
  func configureTableView() {
    tableView.tableFooterView = UIView()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: Constants.CellIdentifiers.ARTICLE_CELL, bundle: nil), forCellReuseIdentifier: Constants.CellIdentifiers.ARTICLE_CELL)
  }
  
  func getLatestNews() {
    activityIndicator.startAnimating()
    NetworkManager.shared.getAppleArticles { [weak self] result in
      guard let self = self else { return }
      
      switch result {
      case .success(let articles):
        self.articles = articles
        DispatchQueue.main.async {
          self.activityIndicator.stopAnimating()
          self.tableView.reloadData()
        }
      case .failure(let error):
        DispatchQueue.main.async {
          self.activityIndicator.stopAnimating()
        }
        print(error)
      }
    }
  }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return articles.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.ARTICLE_CELL, for: indexPath) as? MainCell {
      cell.configure(article: articles[indexPath.row])
      return cell
    }
    return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let safeURL = articles[indexPath.row].url{
      let vc = SFSafariViewController(url: safeURL)
      present(vc, animated: true, completion: nil)
    }
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.text = ""
    searchBar.endEditing(true)
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    NetworkManager.requestWord = searchBar.text ?? "intel"
    // print(searchBar.text ?? "apple")
    getLatestNews()
    searchBar.endEditing(true)
  }
  
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    searchBar.endEditing(true)
  }
}

//
//  FavView.swift
//  TVShows App
//
//  Created by Giovanny Bonifaz on 25/10/20.
//

import UIKit
import RxSwift
import CoreData

class FavView: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var activity: UIActivityIndicatorView!
	
	private var router = FavRouter()
	private var viewModel = FavViewModel()
	private var shows: [Show]?
	private var indexPathSelected: IndexPath?
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	

    override func viewDidLoad() {
        super.viewDidLoad()
		
		configureTableViewCell()
		viewModel.bind(view: self, router: router)
		fetchData()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		fetchData()
	}
	
	private func configureTableViewCell() {
		tableView.rowHeight = UITableView.automaticDimension
		tableView.register(UINib(nibName: "TVShowCell", bundle: nil), forCellReuseIdentifier: "CustomShowCell")
	}
	
	private func fetchData() {
		do {
			self.shows = try context.fetch(Show.fetchRequest())
			self.reloadTableView()
		} catch let error {
			print(error.localizedDescription)
		}
		
		
	}
	
	private func reloadTableView() {
		DispatchQueue.main.async {
			self.activity.stopAnimating()
			self.activity.isHidden = true
			self.tableView.reloadData()
		}
	}

}


extension FavView: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let shows = shows {
			return shows.count
		}
		return 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CustomShowCell") as! TVShowCell
		
		if let shows = shows {
			cell.cover.imageFromServer(urlString: shows[indexPath.row].image)
			cell.title.text = shows[indexPath.row].name
		}
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 150
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let shows = shows {
			let show = TVShow(show: shows[indexPath.row])
			viewModel.makeDetailView(show)
		}
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		self.indexPathSelected = indexPath
		
		let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
			let alert = UIAlertController(title: "Do you want to delete it from your favorites?", message: "If you delete this show from your favorite list you could add it later.", preferredStyle: .alert)
			
			alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (alertAction) in
				self.deleteAction()
				completion(true)
			}))
			alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alertAction) in
				completion(true)
			}))
			self.present(alert, animated: true)
			
		}
		let config = UISwipeActionsConfiguration(actions: [delete])
		config.performsFirstActionWithFullSwipe = false
		return config
	}
	
	private func deleteAction() {
		guard let index = indexPathSelected, let shows = shows else { return }
		let favToRemove = shows[index.row]
		self.context.delete(favToRemove)
		do {
			try self.context.save()
			fetchData()
			print("Fav deleted")
		} catch let error {
			sendAlert("Oops, something went wrong!", "There was a problem deleting this TV show. Do you want to try again?", defaultButtonTitle: "Retry") { (action) in
				self.deleteAction()
			}
			print(error.localizedDescription)
		}
	}
	
	private func sendAlert(_ title: String, _ message: String?, defaultButtonTitle titleA:String?, handler: ((UIAlertAction) -> Void)? = nil){
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		
		let retryAction = UIAlertAction(title: titleA, style: .default, handler: handler)
		let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
		
		alert.addAction(retryAction)
		alert.addAction(cancelAction)
		
		self.present(alert, animated: true)
	}
}

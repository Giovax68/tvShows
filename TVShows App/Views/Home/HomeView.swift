//
//  HomeView.swift
//  TVShows App
//
//  Created by Giovanny Bonifaz on 24/10/20.
//

import UIKit
import RxSwift
import CoreData

class HomeView: UIViewController {
	
	@IBOutlet private weak var tableView: UITableView!
	@IBOutlet private weak var activity: UIActivityIndicatorView!
	
	private var router = HomeRouter()
	private var viewModel = HomeViewModel()
	private var disposeBag = DisposeBag()
	private var shows = [TVShow]()
	private var indexPathSelected: IndexPath?
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureTableViewCell()
		viewModel.bind(view: self, router: router)
		getData()
	}
	
	private func configureTableViewCell() {
		tableView.rowHeight = UITableView.automaticDimension
		tableView.register(UINib(nibName: "TVShowCell", bundle: nil), forCellReuseIdentifier: "CustomShowCell")
	}
	
	private func getData() {
		return viewModel.getShowListData()
			// Manage concurrency or threads of RxSwift
			.subscribeOn(MainScheduler.instance)
			.observeOn(MainScheduler.instance)
		
			//Subscribe to observer
			.subscribe(onNext: { shows in
				self.shows = shows
				self.reloadTableView()
			}, onError: { error in
				self.sendAlert("Oops, something went wrong!", "An error occurred while querying the service. Do you want to try again?", defaultButtonTitle: "Retry") { (action) in
					self.getData()
				}
				print(error.localizedDescription)
			}, onCompleted: {
			}).disposed(by: disposeBag)
	}
	
	private func findFavShow(show: TVShow) -> Show? {
		do {
			let request = Show.fetchRequest() as NSFetchRequest<Show>
			request.predicate = NSPredicate(format: "id = %i", Int32(show.id))
			let tvS = try context.fetch(request)
			return tvS.first
		} catch let error {
			print(error.localizedDescription)
			return nil
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

extension HomeView: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return shows.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CustomShowCell") as! TVShowCell
		
		cell.cover.imageFromServer(urlString: shows[indexPath.row].image.medium)
		cell.title.text = shows[indexPath.row].name
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 150
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		viewModel.makeDetailView(shows[indexPath.row])
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	
	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		self.indexPathSelected = indexPath
		let show = shows[indexPath.row]
		if let _ = findFavShow(show: show) {
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
		} else {
			let add = UIContextualAction(style: .normal, title: "Favorite") { (action, view, completion) in
				self.addAction()
				completion(true)
			}
			add.backgroundColor = .systemGreen
			let config = UISwipeActionsConfiguration(actions: [add])
			config.performsFirstActionWithFullSwipe = false
			return config
		}
		
		
	}
	
	private func deleteAction() {
		guard let index = indexPathSelected else { return }
		guard let favToRemove = findFavShow(show: shows[index.row]) else { return }
		self.context.delete(favToRemove)
		do {
			try self.context.save()
			print("Fav deleted")
		} catch let error {
			sendAlert("Oops, something went wrong!", "There was a problem deleting this TV show. Do you want to try again?", defaultButtonTitle: "Retry") { (action) in
				self.deleteAction()
			}
			print(error.localizedDescription)
		}
	}
	
	private func addAction() {
		guard let index = indexPathSelected else { return }
		if findFavShow(show: shows[index.row]) == nil{
			let show = shows[index.row]
			let newFav = Show(context: self.context)
			newFav.setData(show)
			do {
				try self.context.save()
				print("Fav saved")
			} catch let error {
				sendAlert("Oops, something went wrong!", "There was a problem saving this TV show. Do you want to try again?", defaultButtonTitle: "Retry") { (action) in
					self.addAction()
				}
				print(error.localizedDescription)
			}
		}else{
			print("already saved")
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

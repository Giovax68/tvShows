//
//  DetailView.swift
//  TVShows App
//
//  Created by Giovanny Bonifaz on 24/10/20.
//

import UIKit
import CoreData

class DetailView: UIViewController {

	@IBOutlet private weak var cover: UIImageView!
	@IBOutlet private weak var genres: UILabel!
	@IBOutlet private weak var rating: UILabel!
	@IBOutlet private weak var language: UILabel!
	@IBOutlet private weak var premiere: UILabel!
	@IBOutlet private weak var summary: UILabel!
	@IBOutlet private weak var imdbBtn: UIButton!
	
	private var viewModel = DetailViewModel()
	var tvShow: TVShow?
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		configureBarButtonItem()
		getData()
	}
	
	private func configureBarButtonItem() {
		guard let tvS = tvShow else { return }
		
		if let _ = findFavShow(show: tvS) {
			let image = UIImage(systemName: "star.fill")
			let btnItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(deleteFromFavs))
			self.navigationItem.rightBarButtonItem = btnItem
		}else{
			let image = UIImage(systemName: "star")
			let btnItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addToFav))
			self.navigationItem.rightBarButtonItem = btnItem
		}
	}
	
	private func getData() {
		guard let tvS = tvShow else { return }
		self.fillWithData(tvS)
		let router = DetailRouter(tvS)
		viewModel.bind(view: self, router: router)
	}
	
	private func fillWithData(_ tvShow: TVShow) {
		self.navigationItem.title = tvShow.name
		cover.imageFromServer(urlString: tvShow.image.medium)
		genres.text = tvShow.genres.joined(separator: ", ")
		rating.text = "\(tvShow.rating.average ?? 0) / 10"
		language.text = tvShow.language
		premiere.text = tvShow.premiered
		summary.text = tvShow.summary.htmlToString
		imdbBtn.isHidden = tvShow.externals.imdb == nil || tvShow.externals.imdb == ""
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
	
	@IBAction func goToIMDb(_ sender: UIButton) {
		if let tvs = tvShow, let imdbStr = tvs.externals.imdb, let url = URL(string: Constants.URL.imdb+imdbStr) {
			UIApplication.shared.open(url)
		}
	}
	
	
	@objc func deleteFromFavs() {
		guard let show = tvShow, let favToRemove = findFavShow(show: show) else { return }
		self.context.delete(favToRemove)
		do {
			try self.context.save()
			self.configureBarButtonItem()
			print("Fav deleted")
		} catch let error {
			sendAlert("Oops, something went wrong!", "There was a problem deleting this TV show. Do you want to try again?", defaultButtonTitle: "Retry") { (action) in
				self.deleteFromFavs()
			}
			print(error.localizedDescription)
		}
	}
	
	@objc func addToFav() {
		guard let show = tvShow else { return }
		if findFavShow(show: show) == nil{
			let newFav = Show(context: self.context)
			newFav.setData(show)
			do {
				try self.context.save()
				self.configureBarButtonItem()
				print("Fav saved")
			} catch let error {
				sendAlert("Oops, something went wrong!", "There was a problem saving this TV show. Do you want to try again?", defaultButtonTitle: "Retry") { (action) in
					self.addToFav()
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

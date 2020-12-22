//
//  ImagesViewController.swift
//  mobile development labs
//

import UIKit


struct ImageURL: Decodable {
	let webformatURL: String
}

struct ImagesSearch: Decodable {
	let hits: [ImageURL]
}


class ImagesViewController: UIViewController, UICollectionViewDelegate {

	@IBOutlet weak var PicturesCollectionView: UICollectionView!
	@IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!

	var ImagesDataSource = ImagesViewDataSource()

	override func viewDidLoad() {
		super.viewDidLoad()

		PicturesCollectionView.delegate = self
		PicturesCollectionView.dataSource = ImagesDataSource

		DispatchQueue.global().async {
			if let ImagesSearchData = try? Data(contentsOf: URL(string: "https://pixabay.com/api/?key=19193969-87191e5db266905fe8936d565&q=yellow+flowers&image_type=photo&per_page=27")!) {
				if let imagesSearch = try? JSONDecoder().decode(ImagesSearch.self, from: ImagesSearchData) {
					for image in imagesSearch.hits {
						self.ImagesDataSource.Images.append((nil, image.webformatURL))
					}
				}
			}

			DispatchQueue.main.async {
				self.PicturesCollectionView.reloadData()
				self.ActivityIndicator.stopAnimating()
			}
		}

	}


}


//
//  HoroscopeDetailVC.swift
//  HoroscopeInfo
//
//  Created by Yusuf Özgül on 28.09.2020.
//

import UIKit

typealias HoroscopeDetailCollectionSnapshot = NSDiffableDataSourceSnapshot<DetailSection, HoroscopeDetailCellData>
private typealias DataSource = UICollectionViewDiffableDataSource<DetailSection, HoroscopeDetailCellData>


enum DetailSection {
    case main
}

class HoroscopeDetailVC: UIViewController {
    @IBOutlet weak var dateSelector: UIDatePicker!
    @IBOutlet weak var latitudeTextfield: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    @IBOutlet weak var collectionArea: UIView!
    
    @IBOutlet weak var birthDateLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    private var loadingIndicator: UIActivityIndicatorView!
    
    var collection: UICollectionView!
    
    var viewModel: HoroscopeDetailViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    private var dataSource: DataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.makeCollectionViewLayout()
        self.dataSource = self.makeDatasource()
        setActiviyIndicator()
    }
    
    func setActiviyIndicator() {
        loadingIndicator = UIActivityIndicatorView()
        self.view.addSubview(loadingIndicator)
        loadingIndicator.center = self.view.center
        loadingIndicator.hidesWhenStopped = true
    }
    
    @IBAction func loadData(_ sender: Any) {
        viewModel.load(birthDate: dateSelector.date, lat: latitudeTextfield.text!, lon: longitudeTextField.text!)
    }
}

extension HoroscopeDetailVC: HoroscopeDetailViewModelDelegate {
    func handleOutput(_ output: HoroscopeDetailViewModelOutput) {
        switch output {
        case .setLoading(let isLoading):
            DispatchQueue.main.async { [self] in
                isLoading ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
            }
        case .showDetail(let snapShot):
            DispatchQueue.main.async {
                self.dataSource.apply(snapShot)
            }
        case .showError(let errorMessage):
            DispatchQueue.main.async {
                self.self.showError(errorMessage: errorMessage)
            }
        }
    }
    
    func showError(errorMessage: String) {
        let alert = UIAlertController(title: "ALERT_TITLE".localized, message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ALERT_CANCEL_BUTTON_TITLE".localized, style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}

extension HoroscopeDetailVC {
    func makeCollectionViewLayout() {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        let frame = CGRect(x: 0, y: 0, width: collectionArea.frame.width, height: collectionArea.frame.height)
        collection = UICollectionView(frame: frame, collectionViewLayout: layout)
        collection.backgroundColor = .systemBackground
        collectionArea.addSubview(collection)
        
        collection.leadingAnchor.constraint(equalTo: collectionArea.leadingAnchor).isActive = true
        collection.trailingAnchor.constraint(equalTo: collectionArea.trailingAnchor).isActive = true
        collection.topAnchor.constraint(equalTo: collectionArea.topAnchor).isActive = true
        collection.bottomAnchor.constraint(equalTo: collectionArea.bottomAnchor).isActive = true
    }
    
    func makeCell() -> UICollectionView.CellRegistration<UICollectionViewListCell, HoroscopeDetailCellData> {
        UICollectionView.CellRegistration { cell, indexPath, data in
            var config = cell.defaultContentConfiguration()
            config.text = data.value
            config.secondaryText = data.key
            cell.contentConfiguration = config
        }
    }
    
    private func makeDatasource() -> DataSource {
        let cell = makeCell()
        return DataSource(collectionView: collection) { (collectionView, indexPath, data) -> UICollectionViewCell? in
            collectionView.dequeueConfiguredReusableCell(using: cell, for: indexPath, item: data)
        }
    }
}

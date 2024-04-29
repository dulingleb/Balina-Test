//
//  ViewController.swift
//  Balina Test
//
//  Created by Dulin Gleb on 28.4.24..
//

import UIKit

class ViewController: UIViewController {
    private var currentPhotoListPage: Int = 0
    private var isPagginating: Bool = false
    private let dataSource = MainTableViewDataSource()
    private var photoId: Int?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTableView()
        loadPhotos()
    }

    private func configTableView() {
        tableView.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: MainTableViewCell.reuseId)
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        dataSource.tableView = tableView
        dataSource.delegate = self
    }
    
    private func loadPhotos() {
        isPagginating = true
        APIFetchHandler.shared.getPhotos(page: currentPhotoListPage) { [weak self] value, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Somthing went wrong! \(error.localizedDescription)")
                return
            }

            dataSource.photos.append(contentsOf: value?.content ?? []) 
            self.currentPhotoListPage += 1
            self.isPagginating = false
        }
    }
    
    private func uploadPhoto(image: UIImage) {
        guard let id = photoId else { return }
        APIFetchHandler.shared.sendPhoto(id: id, image: image) { [weak self] in
            print("successful uploaded")
        }
        photoId = nil
    }
}

extension ViewController: MainTableViewDataSourceDelegate {
    func didSwipeToEndTable() {
        if !isPagginating {
            loadPhotos()
        }
    }
    
    func didSelectRow(id: Int) {
        photoId = id
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.cameraCaptureMode = .photo
        vc.delegate = self
        vc.view.layoutIfNeeded()
        
        present(vc, animated: true)
    }
}

extension ViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.originalImage] as? UIImage else {
            print("No image found")
            return
        }

        uploadPhoto(image: image)
    }
}

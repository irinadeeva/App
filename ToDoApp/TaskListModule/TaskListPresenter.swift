//
//  TaskListPresenter.swift
//
//  Created by Irina Deeva on 29/11/24
//

enum TaskListState {
  case initial, loading, data([TaskItem]),
       //       update,
       failed(Error)
}

protocol TaskListPresenterProtocol: AnyObject {
  func viewDidLoad()
  func didSelectTask(_ task: TaskItem)
}

final class TaskListPresenter {
  weak var view: TaskListViewProtocol?
  var router: TaskListRouterProtocol?
  var interactor: TaskListInteractorInput?
  
  private var tasks: [TaskItem] = []
  private var state: TaskListState = .initial {
    didSet {
      stateDidChanged()
    }
  }
  
  private func stateDidChanged() {
    switch state {
    case .initial:
      assertionFailure("can't move to initial state")
    case .loading:
      //TODO: doesnt work
      //      view?.showLoadingAndBlockUI()
      interactor?.fetchTasks()
    case .data(let tasks):
      self.tasks = tasks
      view?.showTasks(tasks)
      //      view?.hideLoadingAndUnblockUI()
    case .failed(let error):
      print("error: \(error.localizedDescription)")
      //      let errorModel = makeErrorModel(error)
      //      view?.hideLoadingAndUnblockUI()
      //      view?.showError(errorModel)
      //    case .update:
      //
    }
  }
}

extension TaskListPresenter: TaskListInteractorOutput {
  func didFetchTasks(_ tasks: [TaskItem]) {
    state = .data(tasks)
  }
  
  func didFailToFetchTasks(with error: Error) {
    state = .failed(error)
  }
}

extension TaskListPresenter: TaskListPresenterProtocol {
  func didSelectTask(_ task: TaskItem) {
    router?.navigateToTaskDetail(with: task)
  }
  
  func viewDidLoad() {
    state = .loading
  }
}

//protocol PhotoListPresenter {
//  func fetchPhotosFor(_ text: String)
//  func fetchHints() -> [String]
//  func fetchPhotosNextPage()
//  func getCachedImage(for url: String) -> Data?
//}

//final class PhotoListPresenterImpl: PhotoListPresenter {
//  weak var view: PhotoListView?
//  private let service: PhotoService
//  private var loadedPhotos: [Photo] = []
//  private var imageCache = NSCache<NSString, NSData>()
//  private var lastLoadedPage: Int = 0
//
//  private var state = State<[Photo]>.initial {
//    didSet {
//      stateDidChanged()
//    }
//  }
//
//  init(photoService: PhotoService) {
//    self.service = photoService
//  }
//
//  func fetchPhotosFor(_ text: String) {
//    loadedPhotos = []
//    lastLoadedPage = 0
//    state = .loading
//  }
//
//  func fetchPhotosNextPage() {
//    lastLoadedPage += 1
//    state = .loading
//  }
//
//
//  func getCachedImage(for url: String) -> Data? {
//    return imageCache.object(forKey: url as NSString) as Data?
//  }
//
//  private func stateDidChanged() {
//    switch state {
//    case .initial:
//      assertionFailure("can't move to initial state")
//    case .loading:
//      //TODO: doesnt work
//      view?.showLoadingAndBlockUI()
//      loadPhoto()
//    case .data(let photos):
//      view?.fetchPhotos(self.loadedPhotos)
//      view?.hideLoadingAndUnblockUI()
//    case .failed(let error):
//      let errorModel = makeErrorModel(error)
//      view?.hideLoadingAndUnblockUI()
//      view?.showError(errorModel)
//    }
//  }
//
//  private func loadPhoto() {
//    service.loadPhoto(for: searchText, for: lastLoadedPage) { [weak self] result in
//      switch result {
//      case .success(let photos):
//        self?.loadedPhotos.append(contentsOf: photos)
//        self?.cachePhotosImages(photos)
//      case .failure(let error):
//        self?.state = .failed(error)
//      }
//    }
//  }
//
//  private func cachePhotosImages(_ photos: [Photo]) {
//    let dispatchGroup = DispatchGroup()
//
//    for photo in photos {
//      if let imageURL = URL(string: photo.thumbImageURL),
//         imageCache.object(forKey: photo.thumbImageURL as NSString) == nil {
//        dispatchGroup.enter()
//        DispatchQueue.global().async {
//          if let imageData = try? Data(contentsOf: imageURL) {
//            self.imageCache.setObject(
//              imageData as NSData,
//              forKey: photo.thumbImageURL as NSString
//            )
//          }
//          dispatchGroup.leave()
//        }
//      }
//    }
//
//    dispatchGroup.notify(queue: .main) {
//      self.state = .data(photos)
//    }
//  }
//
//
//  private func makeErrorModel(_ error: Error) -> ErrorModel {
//    let message: String
//    switch error {
//    case is NetworkClientError:
//      message = "Проверьте соединение"
//    default:
//      message = "Error.unknown"
//    }
//
//    let actionText = "Repeat"
//    return ErrorModel(message: message,
//                      actionText: actionText) { [weak self] in
//      self?.state = .loading
//    }
//  }
//}

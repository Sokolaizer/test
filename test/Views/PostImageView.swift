
import UIKit

class PostImageView: UIImageView {
  enum Constants {
    static let maximumZoomScale: CGFloat = 2.0
    static let minimumZoomScale: CGFloat = 1.0
    static let duration = 0.3
    static let alphaRatio: CGFloat = 1.5
  }
  
  var isZooming = false
  var originalImageCenter:CGPoint?
  weak var tableView: UITableView!
  var overlayView = OverlayView()
  let navigationController: UINavigationController?
  let tabBarController: UITabBarController?
  
  func setGestures(tableView: UITableView, delegate: UIGestureRecognizerDelegate) {
    let pinch = UIPinchGestureRecognizer(target: self, action: #selector(self.pinch(sender:)))
    pinch.delegate = delegate
    self.addGestureRecognizer(pinch)
    let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(sender:)))
    pan.delegate = delegate
    self.addGestureRecognizer(pan)
  }
  
  @objc func pan(sender: UIPanGestureRecognizer) {
    if self.isZooming && sender.state == .began {
      self.originalImageCenter = sender.view?.center
    } else if self.isZooming && sender.state == .changed {
      let translation = sender.translation(in: self)
      if let view = sender.view {
        view.center = CGPoint(x:view.center.x + translation.x,
                              y:view.center.y + translation.y)
      }
      sender.setTranslation(.zero, in: self.superview)
    }
  }
  
  @objc func pinch(sender:UIPinchGestureRecognizer) {
    if sender.state == .began {
      navigationController?.navigationBar.alpha = 0
      tabBarController?.tabBar.alpha = 0
      overlayView.isHidden = false
      tableView.clipsToBounds = false
      tableView.isScrollEnabled = false
      let currentScale = self.frame.size.width / self.bounds.size.width
      let newScale = currentScale*sender.scale
      if newScale > Constants.minimumZoomScale {
        isZooming = true
      }
    } else if sender.state == .changed {
      guard let view = sender.view else {return}
      let pinchCenter = CGPoint(x: sender.location(in: view).x - view.bounds.midX,
                                y: sender.location(in: view).y - view.bounds.midY)
      let transform = view.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
        .scaledBy(x: sender.scale, y: sender.scale)
        .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
      let currentScale = self.frame.size.width / self.bounds.size.width
      var newScale = currentScale*sender.scale
      overlayView.alpha = (newScale * newScale) / Constants.alphaRatio
      if newScale < Constants.minimumZoomScale {
        newScale = Constants.minimumZoomScale
        let transform = CGAffineTransform(scaleX: newScale, y: newScale)
        self.transform = transform
        sender.scale = Constants.minimumZoomScale
      } else if newScale > Constants.maximumZoomScale {
        newScale = Constants.maximumZoomScale
      } else {
        view.transform = transform
        sender.scale = Constants.minimumZoomScale
      }
    } else if sender.state == .ended || sender.state == .failed || sender.state == .cancelled {
      guard let center = self.originalImageCenter else {return}
      UIView.animate(withDuration: Constants.duration, animations: {
        self.transform = CGAffineTransform.identity
        self.overlayView.alpha = 0
        self.navigationController?.navigationBar.alpha = 1
        self.tabBarController?.tabBar.alpha = 1
        self.center = center
      }, completion: { _ in
        self.isZooming = false
        self.overlayView.isHidden = true
        self.tableView.clipsToBounds = true
        self.tableView.isScrollEnabled = true
      })
    }
  }
  
  init(with image: UIImage, asTableHeaderViewIn tableView: UITableView, navController:UINavigationController?, tabBarController: UITabBarController?) {
    self.navigationController = navController
    self.tableView = tableView
    self.tabBarController = tabBarController
    super.init(image: image)
    self.contentMode = .scaleAspectFill
    self.isUserInteractionEnabled = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

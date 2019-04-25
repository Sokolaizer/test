
import UIKit

class PostImageView: UIImageView {
  
  var isZooming = false
  var originalImageCenter:CGPoint?
  weak var tableView: UITableView!
  weak var fadeView: UIView!
  let navigationController: UINavigationController?
  
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
      navigationController?.navigationBar.isHidden = true
      self.tableView.clipsToBounds = false
      self.tableView.isScrollEnabled = false
      let currentScale = self.frame.size.width / self.bounds.size.width
      let newScale = currentScale*sender.scale
      if newScale > 1 {
        self.isZooming = true
        self.fadeView.isHidden = false
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
      if newScale < 1 {
        newScale = 1
        let transform = CGAffineTransform(scaleX: newScale, y: newScale)
        self.transform = transform
        sender.scale = 1
      } else if newScale > 1.8 {
        newScale = 1.8
      } else {
        view.transform = transform
        sender.scale = 1
      }
    } else if sender.state == .ended || sender.state == .failed || sender.state == .cancelled {
      guard let center = self.originalImageCenter else {return}
      UIView.animate(withDuration: 0.3, animations: {
        self.transform = CGAffineTransform.identity
        self.center = center
      }, completion: { _ in
        self.isZooming = false
        self.fadeView.isHidden = true
        self.tableView.clipsToBounds = true
        self.tableView.isScrollEnabled = true
        self.navigationController?.navigationBar.isHidden = false
      })
    }
  }
  
  init(with image: UIImage, asTableHeaderViewIn tableView: UITableView, fadeView: UIView, navController:UINavigationController?) {
    self.navigationController = navController
    self.tableView = tableView
    self.fadeView = fadeView
    super.init(image: image)
    self.contentMode = .scaleAspectFill
    self.clipsToBounds = true
    self.isUserInteractionEnabled = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

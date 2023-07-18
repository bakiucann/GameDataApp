import UIKit

@available(iOS 13.0, *)
public class LoadingManager {

    public static let shared = LoadingManager()

    private var loadingViewController: LoadingViewController?

    private init() { }

    public func startLoading() {
        guard let keyWindow = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return }
        loadingViewController = LoadingViewController()
        loadingViewController?.view.frame = keyWindow.bounds
        keyWindow.addSubview(loadingViewController!.view)
        loadingViewController?.startLoading()
    }

    public func stopLoading() {
        loadingViewController?.stopLoading()
        loadingViewController?.view.removeFromSuperview()
        loadingViewController = nil
    }
}

@available(iOS 13.0, *)
public class LoadingViewController: UIViewController {

    private let activityIndicator = UIActivityIndicatorView(style: .large)

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(activityIndicator)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    public func startLoading() {
        activityIndicator.startAnimating()
    }

    public func stopLoading() {
        activityIndicator.stopAnimating()
    }
}

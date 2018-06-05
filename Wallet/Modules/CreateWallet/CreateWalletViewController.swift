import UIKit

class CreateWalletViewController: UIViewController, CreateWalletViewProtocol {

    let delegate: CreateWalletViewDelegate

    @IBOutlet weak var wordsLabel: UILabel?

    init(delegate: CreateWalletViewDelegate) {
        self.delegate = delegate

        super.init(nibName: String(describing: CreateWalletViewController.self), bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate.viewDidLoad()
    }

    func show(wordsString: String) {
        wordsLabel?.text = wordsString
    }

}
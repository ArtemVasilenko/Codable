import UIKit

class ProductDetailsViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    var product: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = product.name
        
        
    }
    

}

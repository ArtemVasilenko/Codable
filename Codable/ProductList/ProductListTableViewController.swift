import UIKit
import CoreData

class ProductListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var model: ProductListModel?
    var frc: NSFetchedResultsController<Product>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My products"
        
        model = ProductListModel(completion: { [weak self] result in
            switch result {
            case .succeed(let context):
                self?.buildFRCIn(conext: context)
                self?.model?.requestProducts()
                
            case .failed:
                return
            }
        })
    }
    
    func buildFRCIn(conext: NSManagedObjectContext) {
        let frc = NSFetchedResultsController(fetchRequest: Product.sortedRequest,
                                             managedObjectContext: conext,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        
        frc.delegate = self
        do {
            try frc.performFetch()
            self.frc = frc
        } catch {
            print(error )
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let section = frc?.sections?[section]
        return section?.numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "ProductCell",
                                                  for: indexPath) as? ProductCellTableViewCell)!
        
        let product = frc?.object(at: indexPath)
        
        cell.productNameLabel.text = product?.name?.description
        cell.productAmountLabel.text = "\(String(describing: product?.amount.description))"
        
        
        return cell
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let productDetailVC = segue.destination as? ProductDetailsViewController,
           let indexPath = tableView.indexPathForSelectedRow,
           let product = frc?.object(at: indexPath) {
            productDetailVC.product = product
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    
}



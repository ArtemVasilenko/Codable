import Foundation
import CoreData

enum Result<Value> {
    case succeed(Value )
    case failed(Error)
}

class ProductListModel {
    private let session = URLSession.shared
    private var productsDataProvider: ProductsDataProvider?
    
    init(completion: @escaping (Result<NSManagedObjectContext>)-> ()) {
        let container = NSPersistentContainer(name: "ListToBuy")
        
        container.loadPersistentStores { [weak self] store, error in
            
            guard let error = error else {
                let context = container.viewContext
                context.automaticallyMergesChangesFromParent = true
                
                self?.productsDataProvider = ProductsDataProvider(container: container)
                completion(Result.succeed(container.viewContext))
                return
            }
            
            completion(Result.failed(error))
            
        }
    }
    
    func requestProducts() {
        
        guard let url = URL(string: "https://api.jsonbin.io/b/5fcfa27d516f9d127029ed6b") else { return }
        
        let request = URLRequest(url: url)
        
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if
                let data = data,
                let httpResponse = response as? HTTPURLResponse,
                error == nil,
                httpResponse.statusCode == 200 {
                
                self.productsDataProvider?.saveProducts(data: data)
            }
        }
        task.resume()
    }
}

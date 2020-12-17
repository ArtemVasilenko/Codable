import Foundation
import CoreData

class ProductsDataProvider {
    private let container: NSPersistentContainer
    
    init(container: NSPersistentContainer) {
        self.container = container
    }
    
    func saveProducts(data: Data) {
        container.performBackgroundTask { context in
            let decoder = JSONDecoder()
            decoder.userInfo[.context] = context
            
            do {
                let objects = try decoder.decode([String: [Product]].self, from: data)
                guard let products = objects["products"] else { return }
                for product in products {
                    context.insert(product)
                }
                try context.save()
            } catch {
                print(error)
            }
        }
    }
}

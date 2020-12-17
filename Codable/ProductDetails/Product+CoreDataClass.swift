import Foundation
import CoreData

extension String: Error {}

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")!
}

@objc(Product)
public class Product: NSManagedObject, Codable {
    
    
    //ключи из JSON
    enum CodingKeys: String, CodingKey {
        case name
        case amount
    }
    
    static var sortedRequest: NSFetchRequest<Product> {
        let request = NSFetchRequest<Product>(entityName: entity().name!)
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(name), ascending: false)]
        return request
    }
    
    //кострукция объекта из JSON
    public required convenience init(from decoder: Decoder) throws {
        
        guard let entityName = Product.entity().name,
              let context = decoder.userInfo[.context] as? NSManagedObjectContext,
              let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
            throw "Entity name is nil"
        }
        
        self.init(entity: entity, insertInto: context)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try values.decode(String.self, forKey: .name)
        amount = Int16(try values.decode(Int.self, forKey: .amount))
    }
    
    //собрать JSON из объекта
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(amount, forKey: .amount)
        
    }
    
}

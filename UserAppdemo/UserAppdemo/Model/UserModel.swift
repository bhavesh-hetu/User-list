
import Foundation
import CoreData

class UserDataModel: Codable {
    var status: Bool?
    var data: [UserModel]?
    
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case data = "data"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decode(Bool?.self, forKey: .status)
        data = try container.decode([UserModel]?.self, forKey: .data)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(status, forKey: .status)
        try container.encode(data, forKey: .data)
    }
}

class UserModel: Codable {
    var fullName: String?
    var userId: Int?
    var email: String?
    var profilePicUrl: String?
    var phone: String?
    var address: String?
    var birthDate: String?
    var gender: String?
    var designation: String?
    var salary: Int?
    var createdAt: String?
    var updatedAt: String?
    
    let entityName: String = Constants.CoreData.Entity.userList
    let managedContext = CoreDataManager.sharedInstance.getManagedContext()
    
    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case userId = "id"
        case email = "email"
        case profilePicUrl = "profile_pic_url"
        case phone = "phone"
        case address = "address"
        case birthDate = "dob"
        case gender = "gender"
        case designation = "designation"
        case salary = "salary"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        fullName = try container.decode(String?.self, forKey: .fullName)
        userId = try container.decode(Int?.self, forKey: .userId)
        email = try container.decode(String?.self, forKey: .email)
        profilePicUrl = try container.decode(String?.self, forKey: .profilePicUrl)
        phone = try container.decode(String?.self, forKey: .phone)
        address = try container.decode(String?.self, forKey: .address)
        birthDate = try container.decode(String?.self, forKey: .birthDate)
        gender = try container.decode(String?.self, forKey: .gender)
        designation = try container.decode(String?.self, forKey: .designation)
        salary = try container.decode(Int?.self, forKey: .salary)
        createdAt = try container.decode(String?.self, forKey: .createdAt)
        updatedAt = try container.decode(String?.self, forKey: .updatedAt)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(fullName, forKey: .fullName)
        try container.encode(userId, forKey: .userId)
        try container.encode(email, forKey: .email)
        try container.encode(profilePicUrl, forKey: .profilePicUrl)
        try container.encode(phone, forKey: .phone)
        try container.encode(address, forKey: .address)
        try container.encode(birthDate, forKey: .birthDate)
        try container.encode(gender, forKey: .gender)
        try container.encode(designation, forKey: .designation)
        try container.encode(salary, forKey: .salary)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(updatedAt, forKey: .updatedAt)
    }
    
    func saveUserObject() {
        if let savedUserObject = CoreDataManager.sharedInstance.fetchWithPredicate(entityName: self.entityName, predicate: NSPredicate(format: "userId = \(self.userId ?? 0)")) as? [Users], savedUserObject.count > 0 {
            self.update(user: savedUserObject[0])
        } else {
            self.insertNewUserObject()
        }
    }
    
    func insertNewUserObject() {
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)!
        let object: Users = NSManagedObject(entity: entity, insertInto: managedContext) as! Users
        
        self.update(user: object)
    }
    
    func update(user: Users) {
        user.userId = Int64(self.userId ?? 0)
        user.fullName = self.fullName ?? ""
        user.email = self.email ?? ""
        user.profilePicUrl = self.profilePicUrl ?? ""
        user.phone = self.phone ?? ""
        user.address = self.address ?? ""
        user.birthDate = self.birthDate ?? ""
        user.designation = self.designation ?? ""
        user.gender = self.gender ?? ""
        user.salary = Int64(self.salary ?? 0)
        user.createdAt = self.createdAt ?? ""
        user.updatedAt = self.updatedAt ?? ""
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save", error, error.userInfo)
        }
    }
    
}




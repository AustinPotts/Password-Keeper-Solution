//
//  Password + Convenience .swift
//  PasswordKeeperSolution
//
//  Created by Austin Potts on 11/23/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData



extension Password {
    
    //Initialize Model Representation
    var passwordRepresentation: PasswordRepresentation? {
        
        guard let website = website,
        let passwordString = passwordString,
        let identifier = identifier?.uuidString else {return nil}
        
        return PasswordRepresentation(identifier: identifier, passwordString: passwordString, website: website)
        
    }
    
    convenience init(website: String, passwordString: String, identifier: UUID = UUID(), context: NSManagedObjectContext ){
        
        self.init(context: context)
        self.website = website
        self.passwordString = passwordString
        self.identifier = identifier
        
    }
    
    @discardableResult convenience init?(passwordRepresentation: PasswordRepresentation, context: NSManagedObjectContext) {
        
        guard let identifier = UUID(uuidString: passwordRepresentation.identifier) else {return nil }
        
        self.init(website: passwordRepresentation.website, passwordString: passwordRepresentation.passwordString, identifier: identifier, context: context)
        
    }
    
    
    
}

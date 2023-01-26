//
//  Permissions.swift
//  ios-trusted-device
//
//  Created by Binar - Mei on 02/01/23.
//

import Foundation
import Contacts

class ContactManager {
    
    let store = CNContactStore()
    static let shared = ContactManager()
    func isAccessContact() {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            // Access has been granted.
            DispatchQueue.global(qos: .background).async {
//                self.fetchContacts()
//                self.fetchAndFormatContactNames(from: self.store)
//                self.fetchAndFormatContactNamesAndNumbers(from: self.store)
            }
        case .denied:
            // Access has been denied.
            print("Access denied")
        case .notDetermined:
            // Access has not been determined.
            store.requestAccess(for: .contacts) { (success, error) in
                if success {
                    // Access has been granted.
                    DispatchQueue.global(qos: .background).async {
//                        self.fetchContacts()
                    }
                } else {
                    // Access has been denied.
                    print("Access denied")
                }
            }
        case .restricted:
            // Access has been restricted.
            print("Access restricted")
        @unknown default:
            fatalError()
        }
    }
    
    func fetchContacts() {
        let keysToFetch = [CNContactPhoneNumbersKey]
        let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch as [CNKeyDescriptor])
        do {
            try store.enumerateContacts(with: fetchRequest) { contact, stop in
//                for phoneNumber in contact.phoneNumbers {
//                    let label = phoneNumber.label
//                    let value = phoneNumber.value.stringValue
//                    print("\(label): \(value)")
//                }
                print(contact.phoneNumbers.count)
            }
        } catch {
            print("Error fetching phone numbers: \(error)")
        }
        // You can now access the phone numbers of the user's contacts using the `contacts` array.
    }
    
    func fetchAndFormatContactNames(from store: CNContactStore) {
        let formatter = CNContactFormatter()
        formatter.style = .fullName
        let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName)]
        let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
        do {
            try store.enumerateContacts(with: fetchRequest) { contact, stop in
                let fullName = formatter.string(from: contact)
                print(fullName)
            }
        } catch {
            print("Error fetching contacts: \(error)")
        }
    }
    
    func fetchAndFormatContactNamesAndNumbers(from store: CNContactStore) {
        let keysToFetch = [CNContactGivenNameKey as NSString, CNContactPhoneNumbersKey as NSString]
        let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
        var contacts = [CNContact]()
        do {
            try store.enumerateContacts(with: fetchRequest) { contact, stop in
                contacts.append(contact)
            }
        } catch {
            print("Error fetching contacts: \(error)")
        }
        for contact in contacts {
            let name = contact.givenName
            print("Name: \(name)")
            for phoneNumber in contact.phoneNumbers {
                let number = phoneNumber.value.stringValue
                print("Number: \(number)")
            }
        }
    }
}

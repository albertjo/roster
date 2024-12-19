import Contacts
import SwiftUI

// Contact data structure to hold what we need
struct ContactData: Identifiable {
    let id: String  // This will be the contact identifier
    let contact: CNContact

    init(contact: CNContact) {
        self.id = contact.identifier
        self.contact = contact
    }
}

class ContactsManager: ObservableObject {
    @Published var contacts: [ContactData] = []
    @Published var authorizationStatus: CNAuthorizationStatus = .notDetermined

    func requestAccess() {
        CNContactStore().requestAccess(for: .contacts) { [weak self] granted, error in
            DispatchQueue.main.async {
                self?.authorizationStatus = granted ? .authorized : .denied
                if granted {
                    self?.fetchContacts()
                }
            }
        }
    }

    func fetchContacts() {
        let store = CNContactStore()
        let keys = [
            CNContactIdentifierKey,
            CNContactGivenNameKey,
            CNContactFamilyNameKey,
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey,
            CNContactImageDataKey,
            CNContactThumbnailImageDataKey,
            CNContactBirthdayKey
        ] as [CNKeyDescriptor]

        let request = CNContactFetchRequest(keysToFetch: keys)

        do {
            var newContacts: [ContactData] = []
            try store.enumerateContacts(with: request) { contact, _ in
                let contactData = ContactData(contact: contact)
                newContacts.append(contactData)
            }

            DispatchQueue.main.async {
                self.contacts = newContacts
            }
        } catch {
            print("Error fetching contacts: \(error)")
        }
    }

    // Fetch a single contact by identifier
    func fetchContact(withIdentifier identifier: String) -> CNContact? {
        let store = CNContactStore()
        let keys = [
            CNContactIdentifierKey,
            CNContactGivenNameKey,
            CNContactFamilyNameKey,
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey,
            CNContactImageDataKey,
            CNContactThumbnailImageDataKey,
            CNContactBirthdayKey
        ] as [CNKeyDescriptor]

        do {
            return try store.unifiedContact(withIdentifier: identifier, keysToFetch: keys)
        } catch {
            print("Error fetching contact: \(error)")
            return nil
        }
    }
}

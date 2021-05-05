//
//  FirebaseManager.swift
//  Lend
//
//  Created by ОК on 14.01.2021.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

let COLLECTION_USERS = "Users"
let COLLECTION_FILTERS = "Fields"
let COLLECTION_ORGANISATIONS = "Organisations"
let COLLECTION_DONATES = "Donates"
let COLLECTION_CAUSES = "Causes"
let COLLECTION_PAYMENT_HYSTORY = "PaymentHystory"

class FirestoreManager {
    static let shared: FirestoreManager = FirestoreManager()
    
    let db = Firestore.firestore()
    
    var isAuthorized: Bool {
        return currentUser != nil
    }
    
    var currentUser: User? {
        return Auth.auth().currentUser
    }
    
    var donateRefs: [DonateItemRef]?
    
    var filters: [FilterItem] = [] {
        didSet {
            filtersDict.removeAll()
            filters.forEach {
                filtersDict[$0.id] = $0
            }
        }
    }
    
    private var filtersDict: [String:FilterItem] = [:]
    
    weak var handle: AuthStateDidChangeListenerHandle?
    
    func checkAuth(completion: @escaping (Bool)->Void) {
        
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            if let strongUser = user {
                print("Auth.auth().addStateDidChangeListener:  Status = athorized, displayName = \(strongUser.displayName ?? "nil")")
            } else {
                print("Auth.auth().addStateDidChangeListener:  Status = not athorized")
            }
            
            Auth.auth().removeStateDidChangeListener(self.handle!)
            completion(self.currentUser != nil)
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Error?)->Void) {
        do {
            try Auth.auth().signOut()
        } catch {}
        Auth.auth().signIn(withEmail: email, password: password, completion: { (result, error) in
            guard error == nil else {
                return completion(error)
            }
            
            self.fetchUpdateUser { _ in
                completion(nil)
            }
        })
    }
    
    func signUp(email: String, password: String, displayName: String?, completion: @escaping (Bool,Error?)->Void) {
        let addUserBlock: ((User)->Void) = { user in
            UserManager.shared.user = LendUser(email: email, displayName: displayName)
            self.addUser(uid: user.uid, email: email, displayName: displayName) { success in
                completion(true, nil)
            }
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard error == nil else {
                return completion(false, error)
            }
            
            guard let user = authResult?.user else {
                completion(false, nil)
                return
            }
            
            if let displayName = displayName {
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = displayName
                changeRequest?.commitChanges { (error) in
                    addUserBlock(user)
                }
            } else {
                addUserBlock(user)
            }
        }
    }
    
    func signOut()->String? {
        do {
           try Auth.auth().signOut()
            return nil
        } catch let signOutError as NSError {
           print ("Error signing out: %@", signOutError)
            return signOutError.localizedDescription
        }
    }
    
    func resetPassword(email: String, completion: @escaping (String?)->Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error?.localizedDescription)
        }
    }
    
    private func addUser(uid: String, email: String, displayName: String?, completion: @escaping (Bool)->Void) {
        var data = [LendUserKey.email : email]
        if let displayName = displayName {
            data[LendUserKey.displayName] = displayName
        }
        
        db.collection(COLLECTION_USERS)
            .document(uid)
            .setData(data, merge: false) { error in
                completion(error == nil)
            }
    }
    
    func fetchUpdateUser(completion: @escaping (Bool)->Void) {
        guard let uid = currentUser?.uid else {
            Coordinator.redirectToAuth()
            return completion(false)
        }
        
        db.collection(COLLECTION_USERS).document(uid).getDocument { snapshot, error in
            if let user = LendUser(snapshot) {
                UserManager.shared.user = user
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func fetchFilters(completion: @escaping ([FilterItem]?)->Void) {
        db.collection(COLLECTION_FILTERS).getDocuments { snapshot, error in
            guard let snapshot = snapshot else { return completion(nil) }

            let result = snapshot.documents.compactMap { FilterItem($0) }
            if !result.isEmpty {
                self.filters = result
            }
            completion(result)
        }
    }
    
    func fetchOrganisations(causeId: String, completion: @escaping ([OrganisationItem]?)->Void) {
        db.collection(COLLECTION_ORGANISATIONS)
            .whereField("causes", arrayContains: causeId)
            .getDocuments { snapshot, error in
                guard let snapshot = snapshot else { return completion(nil) }
                
                let result = snapshot.documents.compactMap { OrganisationItem($0) }
                completion(result)
            }
    }
    
    func fetchOrganisations(completion: @escaping ([OrganisationItem]?, DocumentSnapshot?)->Void) {
        db.collection(COLLECTION_ORGANISATIONS).getDocuments { snapshot, error in
            guard let snapshot = snapshot else { return completion(nil, nil) }
            
            let result = snapshot.documents.compactMap { OrganisationItem($0) }
            completion(result, snapshot.documents.last)
        }
    }
    
    private func addFiltersToOrganisations(_ organisations: [OrganisationItem]) {
        organisations.forEach {
            if let filterId = $0.fieldId {
                $0.filterName = filtersDict[filterId]?.name
            }
        }
    }
    
    //MARK: DefaultDonateAmount
    
    func updateDefaultDonateAmount(_ amount: Int, completion: @escaping (Bool)->Void) {
        guard let uid = currentUser?.uid else {
            Coordinator.redirectToAuth()
            return completion(false)
        }
        
        guard UserManager.shared.user?.defaultDonateAmount != amount else {
            return completion(true)
        }
        
        let data: [String : Any] = [LendUserKey.defaultDonateAmount : amount]
        
        db.collection(COLLECTION_USERS)
            .document(uid).updateData(data) { error in
                if error == nil {
                    UserManager.shared.user?.defaultDonateAmount = amount
                }
                completion(error == nil)
            }
    }
    
    //MARK: CAUSES
    
    func fetchCauses(completion: @escaping ([Cause]?)->Void) {
        db.collectionGroup(COLLECTION_CAUSES)
            .getDocuments { snapshot, error in
                guard let snapshot = snapshot else { return completion(nil) }
                
                let lendRefs = snapshot.documents.compactMap { Cause($0) }
                completion(lendRefs)
            }
    }
    
    //MARK: TIPS
    func addTips(amount: Int, completion: @escaping (Bool)->Void) {
        guard let uid = currentUser?.uid else {
            Coordinator.redirectToAuth()
            return completion(false)
        }
        
        let data: [String:Any] = [LendUserKey.tipsAmount : amount]
        db.collection(COLLECTION_USERS)
            .document(uid)
            .updateData(data) { error in
                if error == nil {
                    UserManager.shared.user?.tips = amount
                }
                completion(error == nil)
            }
    }
    
    //MARK: ONE TIME DONATES
    func addOneTimeDonate(organisationId: String, amount: Int, date: Date, completion: @escaping (Bool)->Void) {
        guard let uid = currentUser?.uid else {
            Coordinator.redirectToAuth()
            return completion(false)
        }
        
        let data: [String:Any] = [DonateItemKey.amount : amount, DonateItemKey.organisation : organisationId, "date" : Timestamp(date: date)]
        db.collection(COLLECTION_USERS)
            .document(uid)
            .collection(COLLECTION_PAYMENT_HYSTORY)
            .addDocument(data: data) { error in
                completion(error == nil)
            }
    }
    
    //MARK: DONATES
    func addDonate(organisationId: String, amount: Int, completion: @escaping (Bool)->Void) {
        guard let uid = currentUser?.uid else {
            Coordinator.redirectToAuth()
            return completion(false)
        }
        
        let data: [String:Any] = [DonateItemKey.amount : amount, DonateItemKey.organisation : organisationId]
        db.collection(COLLECTION_USERS)
            .document(uid)
            .collection(COLLECTION_DONATES)
            .addDocument(data: data) { error in
                completion(error == nil)
            }
    }
    
    func editDonate(id: String, data: [String:Any], completion: @escaping (Bool)->Void) {
        guard let uid = currentUser?.uid else {
            Coordinator.redirectToAuth()
            return completion(false)
        }
        
        db.collection(COLLECTION_USERS)
            .document(uid)
            .collection(COLLECTION_DONATES)
            .document(id)
            .setData(data, merge: true) { error in
                completion(error == nil)
            }
    }
    
    func deleteDonate(id: String, completion: @escaping (Bool)->Void) {
        guard let uid = currentUser?.uid else {
            Coordinator.redirectToAuth()
            return completion(false)
        }
        
        db.collection(COLLECTION_USERS)
            .document(uid)
            .collection(COLLECTION_DONATES)
            .document(id)
            .delete { error in
                completion(error == nil)
            }
    }
    
    func fetchDonateRefs(completion: @escaping ([DonateItemRef]?)->Void) {
        guard let uid = currentUser?.uid else {
            Coordinator.redirectToAuth()
            return completion(nil)
        }
        db.collection(COLLECTION_USERS)
            .document(uid)
            .collection(COLLECTION_DONATES)
            .getDocuments { snapshot, error in
                guard let snapshot = snapshot else { return completion(nil) }
                
                let result = snapshot.documents.compactMap { DonateItemRef($0) }
                self.donateRefs = result
                completion(result)
            }
    }
    
    func fetchDonates(completion: @escaping ([DonateItem]?)->Void) {
        fetchDonateRefs { donateRefs in
            guard let donateRefs = donateRefs else { return completion(nil) }
            guard !donateRefs.isEmpty else { return completion([]) }
            
            let orgIds =  donateRefs.map { $0.organisationId }
            self.fetchOrganisations(ids: orgIds) { organisations in
                var orgsDict: [String:OrganisationItem] = [:]
                organisations.forEach {
                    orgsDict[$0.id] = $0
                }
                
                var result: [DonateItem] = []
                donateRefs.forEach {
                    if let orgItem = orgsDict[$0.organisationId] {
                        result.append(DonateItem(id: $0.id, amount: $0.amount, organisation: orgItem))
                    }
                }
                completion(result)
            }
        }
    }
    
    func fetchDonatesForOrganisation(id: String, completion: @escaping ([DonateItemRef]?)->Void) {
        db.collectionGroup(COLLECTION_DONATES)
            .whereField(DonateItemKey.organisation, isEqualTo: id)
            .getDocuments { snapshot, error in
                guard let snapshot = snapshot else { return completion(nil) }
                
                let lendRefs = snapshot.documents.compactMap { DonateItemRef($0) }
                completion(lendRefs)
            }
    }
    
    private func fetchOrganisations(ids: [String], completion: @escaping ([OrganisationItem])->Void) {
        guard !ids.isEmpty else { return completion([]) }

        let uniqIds = Array(Set(ids))
        let chunked = uniqIds.chunked(into: 10)
        var queryCount = 0

        var result: [OrganisationItem] = []
        for chunkedItem in chunked {
            db.collection(COLLECTION_ORGANISATIONS)
                .whereField(FieldPath.documentID(), in: chunkedItem)
                .getDocuments { snapshot, error in
                    queryCount += 1
                    let organisations = (snapshot?.documents ?? []).compactMap { OrganisationItem($0) }
                    result += organisations

                    if queryCount == chunked.count {
                        self.addFiltersToOrganisations(result)
                        completion(result)
                    }
            }
        }
    }
    
}

extension Notification.Name {
    static let authStateDidChange = Notification.Name("authStateDidChange")
}

//
//  OrganisationItem.swift
//  Lend
//
//  Created by ОК on 20.01.2021.
//

import Foundation
import FirebaseFirestore

class OrganisationItem {
    struct Leader {
        let avatarUrl: URL?
        let about: String
        
        static func itemsFromData(_ data: Any?) -> [Leader] {
            guard let dataArr = data as? [[String:Any]] else { return [] }
            return dataArr.map{ Leader($0) }
        }
        
        init(_ data: [String:Any]) {
            self.about = data["about"] as? String ?? ""
            self.avatarUrl = URL(string: (data["avatar"] as? String) ?? "")
        }
    }
    
    struct Score {
        enum ScoreType: String {
            case overallScore = "overallScore"
            case atScore = "atScore"
            case financeScore = "financeScore"
        }
        let type: ScoreType
        var name: String {
            switch type {
            case .overallScore: return "Overall"
            case .financeScore: return "Financial"
            case .atScore: return "Accountability & Transparency"
            }
        }
        var sortIndex: Int {
            switch type {
            case .overallScore: return 0
            case .atScore: return 1
            case .financeScore: return 2
            }
        }
        let value: Any
        
        static func itemsFromData(_ data: Any?) -> [Score] {
            guard let data = data as? [String:Any] else { return [] }
                 
            return data.keys.compactMap { Score(key: $0, value: data[$0]!) }
        }
        
        init?(key: String, value: Any) {
            guard let type = ScoreType(rawValue: key) else { return nil }
            
            self.type = type
            self.value = value
         }
    }
    
    struct Program {
        let name: String
        let about: String
        
        static func itemsFromData(_ data: Any?) -> [Program] {
            guard let dataArr = data as? [[String:Any]] else { return [] }
            return dataArr.map{ Program($0) }
        }
        
        init(_ data: [String:Any]) {
            self.name = data["name"] as? String ?? ""
            self.about = data["description"] as? String ?? ""
        }
    }
    
    struct Review {
        let sourse: String
        let text: String
        
        static func itemsFromData(_ data: Any?) -> [Review] {
            guard let dataArr = data as? [[String:Any]] else { return [] }
            return dataArr.map{ Review($0) }
        }
        
        init(_ data: [String:Any]) {
            self.sourse = data["sourse"] as? String ?? ""
            self.text = data["text"] as? String ?? ""
        }
    }
    
    struct FinanceMetric {
        let name: String
        let note: String
        let unit: String
        let value: Double
        
        static func itemsFromData(_ data: Any?) -> [FinanceMetric] {
            guard let dataArr = data as? [[String:Any]] else { return [] }
            return dataArr.map{ FinanceMetric($0) }
        }
        
        init(_ data: [String:Any]) {
            self.name = data["name"] as? String ?? ""
            self.note = data["note"] as? String ?? ""
            self.unit = data["unit"] as? String ?? ""
            self.value = data["value"] as? Double ?? 0.0
         }
    }
        
    let id: String
    let about: String
    let desctiptionText: String
    let fieldId: String?
    var filterName: String?
    let imageUrl: URL?
    let name: String
    let contacts: [ContactItem]
    let scores: [Score]
    let leaders: [Leader]
    let programs: [Program]
    let reviews: [Review]
    let financialMetrics: [FinanceMetric]
    let monthDonors: Int
    let monthPledged: Int
    
    init?(_ document: DocumentSnapshot) {
        guard let data = document.data() else { return nil }
        
        self.id = document.documentID
        self.about = data["about"] as? String ?? ""
        self.desctiptionText = data["description"] as? String ?? ""
        self.fieldId = data["field"] as? String
        self.imageUrl = URL(string: (data["imageUrl"] as? String) ?? "")
        
        self.name = data["name"] as? String ?? ""
        self.contacts = ContactItem.fromData(data["contacts"])
        self.scores = Score.itemsFromData(data["scores"]).sorted(by: { $0.sortIndex < $1.sortIndex })
        self.leaders = Leader.itemsFromData(data["leaders"])
        self.programs = Program.itemsFromData(data["programs"])
        self.reviews = Review.itemsFromData(data["reviews"])
        self.financialMetrics = FinanceMetric.itemsFromData(data["financeMetrics"])
        self.monthDonors = data["monthDonors"] as? Int ?? 0
        self.monthPledged = data["monthPledged"] as? Int ?? 0
    }
}

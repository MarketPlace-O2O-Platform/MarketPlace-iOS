import SwiftUI

struct ShopModel: Identifiable {
    let id = UUID()
    let name: String
    let categoryID: Int
    let description: String
    let address: String
    let operatingHours: String
    let closedDays: String
    let phoneNumber: String
    let createdAt: Date
    let updatedAt: Date
    let imageName: String
}

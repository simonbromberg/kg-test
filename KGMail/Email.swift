import Foundation

struct EmailHeader: Codable {
    let name: String
    let value: String

    init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}

struct EmailPayload: Codable {
    let headers: [EmailHeader]

    init(headers: [EmailHeader]) {
        self.headers = headers
    }
}

struct Email: Codable, Hashable {

    let id: String
    let labelIds: [String]
    let snippet: String
    let internalDate: String
    let payload: EmailPayload

    init(id: String,
         labelIds: [String],
         snippet: String,
         internalDate: String,
         payload: EmailPayload) {
        self.id = id
        self.labelIds = labelIds
        self.snippet = snippet
        self.internalDate = internalDate
        self.payload = payload
    }

    static func == (lhs: Email, rhs: Email) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

}

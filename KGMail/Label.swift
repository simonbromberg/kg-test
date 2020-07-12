import Foundation

struct LabelsReponse: Codable {
    let labels: [Label]
}

enum LabelType: String, Codable {
    case system
    case user
}

struct Label: Codable {
    let id: String
    let name: String
    let type: LabelType

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        type = try values.decodeIfPresent(LabelType.self, forKey: .type) ?? .user
    }
}

import Foundation

public protocol Responsable {
    public associatedtype Response: Decodable
}

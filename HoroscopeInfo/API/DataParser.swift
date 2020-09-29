//
//  DataParser.swift
//  HoroscopeInfo
//
//  Created by Yusuf Özgül on 28.09.2020.
//

import Foundation
/// Parse `Data` type json to `Decodable`.
class ParseFromData<T: Decodable>{
    /// Parse `Data` type json to `Decodable`.
    /// - Parameter data: `Data` from network
    /// - Returns: If `Data` is Error Type return `ApiError` otherwise return `T` type
    class func parse(data: Data) -> Result<T, ApiError> {
        let jsonDecoder = JSONDecoder()
        
        if let error = try? jsonDecoder.decode(ApiResponseError.self, from: data) {
            return .failure(.network(errorMessage: error.msg))
        }
        do {
            let result = try jsonDecoder.decode(T.self, from: data)
            return .success(result)
        } catch DecodingError.dataCorrupted(let context) {
            return .failure(.decoding(errorMessage: context.debugDescription))
        } catch DecodingError.keyNotFound(let key, let context) {
            return .failure(.decoding(errorMessage: "\(key.stringValue) was not found, \(context.debugDescription)"))
        } catch DecodingError.typeMismatch(let type, let context) {
            return .failure(.decoding(errorMessage: "\(type) was expected, \(context.debugDescription)"))
        } catch DecodingError.valueNotFound(let type, let context) {
            return .failure(.decoding(errorMessage: "no value was found for \(type), \(context.debugDescription)"))
        } catch {
            return .failure(.decoding(errorMessage: "unknown json parse error"))
        }
    }
}

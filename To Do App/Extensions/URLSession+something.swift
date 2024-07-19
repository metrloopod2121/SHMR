//
//  URLSession+something.swift
//  To Do App
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 13.07.2024.
//

import Foundation

extension URLSession {
    func dataTask(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        try Task.checkCancellation()
        
        return try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: urlRequest) { data, response, error in
                if Task.isCancelled {
                    continuation.resume(throwing: CancellationError())
                } else if let error = error {
                    continuation.resume(throwing: error)
                } else if let data = data, let response = response {
                    continuation.resume(returning: (data, response))
                } else {
                    continuation.resume(throwing: URLError(.badServerResponse))
                }
            }
            
            Task {
                await withTaskCancellationHandler {
                    task.cancel()
                } operation: {
                    await withCheckedContinuation { (innerContinuation: CheckedContinuation<Void, Never>) in
                        task.resume()
                        innerContinuation.resume()
                    }
                }
            }
        }
    }
}

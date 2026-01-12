import Foundation

enum SubmissionStatus: Equatable {
    case idle
    case submitting
    case success(message: String)
    case failure(message: String)

    var isSubmitting: Bool {
        if case .submitting = self { return true }
        return false
    }

    var successMessage: String? {
        if case .success(let message) = self { return message }
        return nil
    }

    var errorMessage: String? {
        if case .failure(let message) = self { return message }
        return nil
    }
}

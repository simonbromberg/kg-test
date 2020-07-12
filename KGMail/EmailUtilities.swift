import Foundation

class EmailUtilities {
    static func combineAndSortEmails(_ emails: [[Email]]) -> [Email] {
        return mergeSortedLists(firstList: [], restOfLists: emails)
    }
    
    private static func mergeSortedLists(firstList: [Email], restOfLists: [[Email]]) -> [Email] {
        guard let nextList = restOfLists.first else {
            return firstList
        }
        
        let secondList = mergeSortedLists(firstList: nextList, restOfLists: Array(restOfLists.dropFirst()))
        
        return mergeTwoSortedLists(firstList: firstList, secondList: secondList)
    }
    
    private static func mergeTwoSortedLists(firstList: [Email], secondList: [Email]) -> [Email] {
        // MERGE MESSAGES QUESTION
        //
        // This implementation is incomplete.
        // Write logic to take the two arrays of Email objects and return a single array of all unique emails sorted from newest to oldest.
        // Note that each list of Email objects is sorted.
        // This function must run in O(n) time, where n is the sum of the sizes of the two lists

		var result = [Email]()
		let count = min(firstList.count, secondList.count)

		for i in 0..<count {
			let first = min(firstList[i], secondList[i])
			let second = max(firstList[i], secondList[i])
			result.append(first)
			result.append(second)
		}

		let rest = firstList.count > count ? firstList[count...] : secondList[count...]
		result.append(contentsOf: Array(rest))

        return firstList + secondList
    }
}

extension Email: Comparable {
	static func < (lhs: Email, rhs: Email) -> Bool {
		return lhs.internalDate < rhs.internalDate
	}
}

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

	private static func mergeTwoSortedLists(firstList left: [Email], secondList right: [Email]) -> [Email] {
		// MERGE MESSAGES QUESTION
		// take the two arrays of Email objects and return a single array of all unique emails sorted from newest to oldest.
		// Note that each list of Email objects is sorted.
		// This function must run in O(n) time, where n is the sum of the sizes of the two lists

		var result = [Email]()

		var leftIndex = 0
		var rightIndex = 0

		while leftIndex < left.count && rightIndex < right.count {
			let leftElement = left[leftIndex]
			let rightElement = right[rightIndex]

			if leftElement < rightElement {
				result.append(leftElement)
				leftIndex += 1
			} else if leftElement > rightElement {
				result.append(rightElement)
				rightIndex += 1
			} else {
				result.append(leftElement)
				leftIndex += 1
				result.append(rightElement)
				rightIndex += 1
			}
		}

		while leftIndex < left.count {
			result.append(left[leftIndex])
			leftIndex += 1
		}

		while rightIndex < right.count {
			result.append(right[rightIndex])
			rightIndex += 1
		}

		return result
	}
}

extension Email: Comparable {
	static func < (lhs: Email, rhs: Email) -> Bool {
		return lhs.internalDate < rhs.internalDate
	}
}

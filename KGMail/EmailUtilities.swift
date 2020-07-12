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

        return firstList + secondList
    }
}

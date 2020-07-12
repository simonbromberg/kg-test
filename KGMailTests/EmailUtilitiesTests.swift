import XCTest
@testable import KGMail

class EmailUtilitiesTests: XCTestCase {

    // UNIT TESTING QUESTION
    //
    // This implementation is incomplete.
    // Write unit tests to test the functionality of EmailUtilities.combineAndSortEmails

	func testEmpty() {
		let result = EmailUtilities.combineAndSortEmails([])
		XCTAssertTrue(result.isEmpty, "combine and sort emails did not handle empty array properly")
	}

	func testMerge() {
		let email1 = Email(id: "id1", labelIds: [], snippet: "test", internalDate: "1594564151000", payload: EmailPayload(headers: []))
		let email2 = Email(id: "id2", labelIds: [], snippet: "test2", internalDate: "1594564151002", payload: EmailPayload(headers: []))
		let email3 = Email(id: "id3", labelIds: [], snippet: "test3", internalDate: "1594564151001", payload: EmailPayload(headers: []))

		var emails = [[email1, email2], [email3]]
		var merged = EmailUtilities.combineAndSortEmails(emails)

		XCTAssertEqual(merged.count, 3, "Output does not have the correct number of emails")
		XCTAssertEqual(merged[0].id, "id1")
		XCTAssertEqual(merged[1].id, "id3")
		XCTAssertEqual(merged[2].id, "id2")

		emails = [[], [email1, email3, email2]]
		merged = EmailUtilities.combineAndSortEmails(emails)
		
		XCTAssertEqual(merged.count, 3, "Output does not have the correct number of emails")
		XCTAssertEqual(merged[0].id, "id1")
		XCTAssertEqual(merged[1].id, "id3")
		XCTAssertEqual(merged[2].id, "id2")

		emails = [[email2], [email3], [email1]]
		merged = EmailUtilities.combineAndSortEmails(emails)

		XCTAssertEqual(merged.count, 3, "Output does not have the correct number of emails")
		XCTAssertEqual(merged[0].id, "id1")
		XCTAssertEqual(merged[1].id, "id3")
		XCTAssertEqual(merged[2].id, "id2")
	}
}

import Testing

@testable import AdventOfCode


// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day01Tests {
    // Smoke test data provided in the challenge question
    let testData = """
    L68
    L30
    R48
    L5
    R60
    L55
    L1
    L99
    R14
    L82
    """
    
    @Test func testPart1() async throws {
        let challenge = Day01(data: testData)
        #expect(String(describing: challenge.part1()) == "3")
    }
    
    @Test func testPart2() async throws {
        let challenge = Day01(data: testData)
        #expect(String(describing: challenge.part2()) == "6")
        
        #expect(String(describing: Day01(data: "L50\nR50").part2()) == "1")
        #expect(String(describing: Day01(data: "L50\nL50").part2()) == "1")
        #expect(String(describing: Day01(data: "R50\nR50").part2()) == "1")
        #expect(String(describing: Day01(data: "R50\nR100").part2()) == "2")
        #expect(String(describing: Day01(data: "L75\nR50").part2()) == "2")
        #expect(String(describing: Day01(data: "R150").part2()) == "2")
        #expect(String(describing: Day01(data: "L150").part2()) == "2")
        #expect(String(describing: Day01(data: "R50\nR50\nL50\nL50\nR75\nL50").part2()) == "4")
    }
}

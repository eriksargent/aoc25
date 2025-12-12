import Testing

@testable import AdventOfCode


// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day12Tests {
    // Smoke test data provided in the challenge question
    let testData = """
    0:
    ###
    ##.
    ##.
    
    1:
    ###
    ##.
    .##
    
    2:
    .##
    ###
    ##.
    
    3:
    ##.
    ###
    ##.
    
    4:
    ###
    #..
    ###
    
    5:
    ###
    .#.
    ###
    
    4x4: 0 0 0 0 2 0
    12x5: 1 0 1 0 2 2
    12x5: 1 0 1 0 3 2
    """
    
    @Test func testPart1() async throws {
        let challenge = Day12(data: testData)
        #expect(String(describing: challenge.part1()) == "1")
    }
    
    @Test func testPart2() async throws {
        let challenge = Day12(data: testData)
        #expect(String(describing: challenge.part2()) == "0")
    }
}

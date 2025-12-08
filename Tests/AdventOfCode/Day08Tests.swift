import Testing

@testable import AdventOfCode


// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day08Tests {
    // Smoke test data provided in the challenge question
    let testData = """
    162,817,812
    57,618,57
    906,360,560
    592,479,940
    352,342,300
    466,668,158
    542,29,236
    431,825,988
    739,650,466
    52,470,668
    216,146,977
    819,987,18
    117,168,530
    805,96,715
    346,949,466
    970,615,88
    941,993,340
    862,61,35
    984,92,344
    425,690,689
    """
    
    @Test func testPart1() async throws {
        let challenge = Day08(data: testData, numberOfConnectionsToMake: 10)
        #expect(String(describing: challenge.part1()) == "40")
    }
    
    @Test func testPart2() async throws {
        let challenge = Day08(data: testData)
        #expect(String(describing: challenge.part2()) == "25272")
    }
}

import Testing

@testable import AdventOfCode


// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day10Tests {
    // Smoke test data provided in the challenge question
    let testData = """
    [.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
    [...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
    [.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
    """
    
    @Test func testPart1() async throws {
        let challenge = Day10(data: testData)
        #expect(String(describing: await challenge.part1()) == "7")
    }
    
    @Test func testPart2() async throws {
        let challenge = Day10(data: testData)
        #expect(String(describing: challenge.part2()) == "33")
    }
}

/*
 0x + 0y + 0z + 1w = a
 0x + 1y + 0z + 1w = b
 0x + 0y + 1z + 0w = c
 0x + 0y + 1z + 1w = d
 1x + 0y + 1z + 0w = e
 1x + 1y + 0z + 0w = f
 3x + 5y + 4z + 7w = a + b + c + d + e + f
 
 
 
 A = [[i in b for b in buttons] for i in numbers]
 
 b += linprog(c, A_eq=A, b_eq=joltage, integrality=1).fun
 
 0 0 0 0 1 1 | x | = 3
 0 1 0 0 0 1 | y | = 5
 0 0 1 1 1 0 | z | = 4
 1 1 0 1 0 0 | w | = 7
 
 
 */

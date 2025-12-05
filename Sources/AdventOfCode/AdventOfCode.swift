import ArgumentParser

// Add each new day implementation to this array:
let allChallenges: [any AdventDay] = [
    Day01(),
    Day02(),
    Day03(),
    Day04(),
    Day05(),
] // END DAYS

@main
struct AdventOfCode: AsyncParsableCommand {
    @Argument(help: "The day of the challenge. For December 1st, use '1'.")
    var day: Int?
    
    @Flag(help: "Benchmark the time taken by the solution")
    var benchmark: Bool = false
    
    @Flag(help: "Run all the days available")
    var all: Bool = false
    
    /// The selected day, or the latest day if no selection is provided.
    var selectedChallenge: any AdventDay {
        get throws {
            if let day {
                if let challenge = allChallenges.first(where: { $0.day == day }) {
                    return challenge
                } else {
                    throw ValidationError("No solution found for day \(day)")
                }
            } else {
                return latestChallenge
            }
        }
    }
    
    /// The latest challenge in `allChallenges`.
    var latestChallenge: any AdventDay {
        allChallenges.max(by: { $0.day < $1.day })!
    }
    
    func run<T>(part: () async throws -> T, named: String) async -> Duration {
        var result: Result<T, Error>?
        let timing = await ContinuousClock().measure {
            do {
                result = .success(try await part())
            } catch {
                result = .failure(error)
            }
        }
        switch result! {
        case .success(let success):
            print("\(named): \(success)")
        case .failure(let failure as PartUnimplemented):
            print("Day \(failure.day) part \(failure.part) unimplemented")
        case .failure(let failure):
            print("\(named): Failed with error: \(failure)")
        }
        return timing
    }
    
    func run() async throws {
        if all {
            var allTimings = [(day: Int, timing1: Duration, timing2: Duration)]()
            for day in allChallenges {
                let (timing1, timing2) = await execute(challenge: day)
                allTimings.append((day.day, timing1, timing2))
            }
            
            print("\n\n")
            print("--- Begin Timings ---")
            print("|Day|Part 1|Part 2|")
            print("|---|------|------|")
            for (day, timing1, timing2) in allTimings {
                print("|\(day)|\(timing1)|\(timing2)|")
            }
            print("--- End Timings ---")
            print("\n\n")
        }
        else {
            let challenge = try selectedChallenge
            await execute(challenge: challenge)
        }
        
#if DEBUG
        print("Looks like you're benchmarking debug code. Try swift run -c release")
#endif
    }
    
    @discardableResult
    func execute(challenge: any AdventDay) async -> (Duration, Duration) {
        print("Executing Advent of Code challenge \(challenge.day)...")
        
        let timing1 = await run(part: challenge.part1, named: "Part 1")
        let timing2 = await run(part: challenge.part2, named: "Part 2")
        
        print("Part 1 took \(timing1), part 2 took \(timing2).")
        
        return (timing1, timing2)
    }
}

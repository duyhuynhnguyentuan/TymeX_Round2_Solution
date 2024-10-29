import Foundation

func findMissingNumber(_ array: [Int], n: Int) -> Int {
    // Calculate the expected sum of numbers from 1 to n+1
    ///sum = [n * (n+1) ]/ 2 if n
    let expectedSum = (n + 1) * (n + 2) / 2
    
    // Calculate the actual sum of the array
    let actualSum = array.reduce(0) {$0 + $1}
    
    // The missing number is the difference between the expected sum and the actual sum
    return expectedSum - actualSum
}

// MARK: -Example usage:
let numbers = [1, 2, 3, 5]
let n = 4
let missingNumber = findMissingNumber(numbers, n: n)
print("The missing number is \(missingNumber)")

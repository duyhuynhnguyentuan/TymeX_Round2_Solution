import Foundation

class Product {
    var name: String
    var price: Double
    var quantity: Int
    
    init(name: String, price: Double, quantity: Int) {
        self.name = name
        self.price = price
        self.quantity = quantity
    }
}

func calculateTotalInventoryValue(products: [Product]) -> Double {
    var totalValue: Double = 0.0
    for product in products {
        totalValue += product.price * Double(product.quantity)
    }
    return totalValue
}

func findMostExpensiveProduct(products: [Product]) -> String? {
    var maxPrice: Double = 0.0
    var expensiveProduct: String?
    for product in products {
        if product.price > maxPrice {
            maxPrice = product.price
            expensiveProduct = product.name
        }
    }
    return expensiveProduct
}

func checkProductInStock(products: [Product], productName: String) -> Bool {
//    let productPredicate = #Predicate<Product> { product in
//        return product.quantity > 0
//    }
//    let product = try! products.filter(productPredicate)
//    for product in product {
//        if product.name == productName{
//            return true
//        }
//    }
    for product in products {
        if product.name == productName {
            return product.quantity > 0
        }
    }
    return false
}

func sortProductsByPrice(products: [Product], ascending: Bool) -> [Product] {
    return products.sorted {
        ascending ? $0.price < $1.price : $0.price > $1.price
    }
}

func sortProductsByQuantity(products: [Product], ascending: Bool) -> [Product] {
    return products.sorted {
        ascending ? $0.quantity < $1.quantity : $0.quantity > $1.quantity
    }
}

// MARK: - Example Usage

let products = [
    Product(name: "Laptop", price: 999.99, quantity: 5),
    Product(name: "Mouse", price: 49.99, quantity: 10),
    Product(name: "Headphones", price: 79.99, quantity: 0),
    Product(name: "Keyboard", price: 79.99, quantity: 4)
]

// Calculate total inventory value
let totalValue = calculateTotalInventoryValue(products: products)
print("Total inventory value: \(totalValue)")

// Find the most expensive product
if let expensiveProduct = findMostExpensiveProduct(products: products) {
    print("Most expensive product: \(expensiveProduct)")
}

// Check if Headphones are in stock
let isHeadphonesInStock = checkProductInStock(products: products, productName: "Headphones")
print("Are headphones in stock? \(isHeadphonesInStock)")

// Sort products by price in descending order
let sortedByPrice = sortProductsByPrice(products: products, ascending: false)
print("Products sorted by price (descending): \(sortedByPrice.map { $0.name })")

// Sort products by quantity in ascending order
let sortedByQuantity = sortProductsByQuantity(products: products, ascending: true)
print("Products sorted by quantity (ascending): \(sortedByQuantity.map { $0.name })")

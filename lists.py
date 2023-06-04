# List creation
numbers = [1, 2, 3, 4, 5]
fruits = ["apple", "banana", "orange"]

# List comprehension
squared_numbers = [x ** 2 for x in numbers]
uppercase_fruits = [fruit.upper() for fruit in fruits]

print(squared_numbers)   # Output: [1, 4, 9, 16, 25]
print(uppercase_fruits)  # Output: ['APPLE', 'BANANA', 'ORANGE']

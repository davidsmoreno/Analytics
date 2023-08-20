def hola(x, y):
    return x + y


print(hola(3, 5))


list = [1, 3, 5]


# Write a function that sum a list of numbers recursively
def sum_list(list):
    if len(list) == 1:
        return list[0]
    else:
        return list[0] + sum_list(list[1:])


print(sum_list([1, 2, 3, 4, 5]))


sum_list("aa")
x = 0

print(x)

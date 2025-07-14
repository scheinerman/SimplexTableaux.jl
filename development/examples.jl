using SimplexTableaux

"""
    dog_food()

A,b,c for chapter 3 dogfood problem
"""
function dog_food()
    A = [3 10; 5 6; 10 2]
    b = [100; 100; 100]
    c = [25; 10]
    return A, b, c
end

"""
    peanut_butter()

A,b,c for peanut butter manufacturing problem in chapter 3
"""
function peanut_butter()
    A = [7//10 9//10; 1//10 5//100; -1 5//10]
    b = [5000; 500; 0]
    c = [305; 545] .// 1000
    return -A, -b, -c
end

function fishkind4()
    A = [2 1 0 9 -1; 1 1 -1 5 1]
    b = [9; 7]
    c = [2; 4; 2; 1; -1]
    @info "This problem is already in standard form"
    T = Tableau(A, b, c, false)
end

"""
    small_example()

Small example for section 4.4
"""
function small_example()
    A = [3 2 -1; 1 -1 3]
    b = [1; 6]
    c = [1;2;3]
    return Tableau(A, b, c, false)
end

nothing

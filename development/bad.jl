function bad4()
    A = [46 44 27 8; 63 21 25 29; 53 10 35 51; 88 44 66 90]
    b = [33, 75, 12, 38]
    c = [97, 72, 94, 90]

    return Tableau(A, b, c)
end

function bad3()
    A = [17 94 34; 3 14 39; 25 77 42]
    b = [80, 57, 23]
    c = [99, 10, 100]
    return Tableau(A, b, c)
end

function bad2()
    A = [7 86; 13 15]
    b = [95, 49]
    c = [48, 50]
    return Tableau(A, b, c)
end

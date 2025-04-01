"""
    find_pivot_column(T::Tableau)

Return the index of the column in `T` with the most negative 
value, or `0` if all entries in the bottom row are nonnegative.
"""
function find_pivot_column(T::Tableau)
    bottom = T.M[end, 1:(end - 1)]
    v, i = findmin(bottom)
    return v < 0 ? i : 0
end

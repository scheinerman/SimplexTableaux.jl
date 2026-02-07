"""
    verbose_pivot!(T::Tableau, i::Int, j::Int)

Perform `pivot!(T,i,j)` but narrate the process starting with scaling row `i`
and then adding multiples of row `i` to the other rows of the tableau to clear
column `j`.
"""
function verbose_pivot!(T::Tableau, i::Int, j::Int)
    m = T.n_cons
    n = T.n_vars

    if i<1 || i>m || j<1 || j>n
        println("($i,$j) is not a valid entry into a $m-by-$n tableau. No pivot performed.")
        return nothing
    end

    a = T.M[i + 1, j + 1]
    if a == 0
        println("Entry ($i,$j) of the tableau is zero. No pivot performed.")
        return nothing
    end

    println("Pivoting on the $(Exact(a)) at entry ($i,$j) of this tableau.")
    display(T)
    println("Scaling row $i by $(Exact(1//a)).")

    #M[i+1,:] .//= a

    scale_row!(T, i, 1//a)
    display(T)

    for r in 0:m
        coef = -T[r, j]
        if r==i
            continue
        end
        row_name = "top row"
        if r>0
            row_name = "row $r"
        end
        println("Adding $(Exact(coef)) times row $i to $row_name.")
        T.M[r + 1, :] += coef*T.M[i + 1, :]
        infer_basis!(T)
        display(T)
    end
    return nothing
end

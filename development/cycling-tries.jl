# source: https://web.ist.utl.pt/~mcasquilho/CD_Casquilho/LP2004Comp&OR_GassVinjamuri.pdf

using SimplexTableaux, SimpleGraphs, DrawSimpleGraphs, Plots



"""
    find_all_matrix_pivots(T::Tableau)

Return a list of tuples `(i,j)` at which `T` has a good matrix pivot 
at the `i,j`-entry. 
"""
function find_all_matrix_pivots(T::Tableau)
    top_row = T.M[1, 2:(end - 1)]
    m, n = size(T.A)
    col_list = [j for j in 1:n if top_row[j] > 0]

    result = Vector{Tuple{Int,Int}}()
    for j in col_list
        a = T.M[2:end, j + 1]
        b = T.M[2:end, end]
        rats = b .// a

        for i in 1:m
            if a[i] < 0 || rats[i] < 0
                rats[i] = 1//0
            end
        end

        min_rat = minimum(rats)

        if min_rat == 1//0
            continue
        end

        ilist = [i for i in 1:m if rats[i]==min_rat]

        for i in ilist
            p = (i, j)
            push!(result, p)
        end
    end
    return result
end

"""
    simplex_graph(T::Tableau)::DirectedGraph{Vector{Int}}

Create a `DirectedGraph` for every possible pivot of `T`.
"""
function simplex_graph(T::Tableau)::DirectedGraph{Vector{Int}}
    G = DirectedGraph{Vector{Int}}()

    blist = find_all_bases(T)
    for B in blist
        add!(G, B)
    end

    for B in blist
        set_basis!(T, B)
        plist = find_all_matrix_pivots(T)
        for ij in plist
            i, j = ij
            matrix_pivot!(T, i, j)
            BB = get_basis(T)
            add!(G, B, BB)
            println("$B --> $BB")
            set_basis!(T, B)
        end
    end

    return G
end

function _one_pass_trim(G::DirectedGraph)::Int
    kills = 0
    VV = vlist(G)
    for v in VV
        if in_deg(G, v)==0 || out_deg(G, v)==0
            delete!(G, v)
            kills+=1
        end
    end
    return kills
end

import SimpleGraphs.trim
function trim(G::DirectedGraph)
    while _one_pass_trim(G) > 0
    end
end

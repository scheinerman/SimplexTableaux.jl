# Pivoting Tableaux

## Row/Column Pivoting

The function `basis_pivot!` pivots on an element of a tableau. The syntax is 
`basis_pivot!(T, i, j)` will pivot on the entry corresponding to constraint `i` and variable `x_j`. 

For example:
```
julia> T
┌──────────┬───┬─────┬─────┬─────┬─────┬─────┐
│          │ z │ x_1 │ x_2 │ x_3 │ x_4 │ RHS │
│ Obj Func │ 1 │   1 │   3 │  -5 │   4 │   0 │
├──────────┼───┼─────┼─────┼─────┼─────┼─────┤
│   Cons 1 │ 0 │  -1 │   5 │  -4 │  -3 │  -3 │
│   Cons 2 │ 0 │   3 │  -2 │   0 │   2 │   6 │
└──────────┴───┴─────┴─────┴─────┴─────┴─────┘


julia> matrix_pivot!(T,2,4)
┌──────────┬───┬─────┬─────┬─────┬─────┬─────┐
│          │ z │ x_1 │ x_2 │ x_3 │ x_4 │ RHS │
│ Obj Func │ 1 │  -5 │   7 │  -5 │   0 │ -12 │
├──────────┼───┼─────┼─────┼─────┼─────┼─────┤
│   Cons 1 │ 0 │ 7/2 │   2 │  -4 │   0 │   6 │
│   Cons 2 │ 0 │ 3/2 │  -1 │   0 │   1 │   3 │
└──────────┴───┴─────┴─────┴─────┴─────┴─────┘
```
The pivot was performed on the `2` in the bottom row of `T`.

## Basis Pivoting

Once a basis has been specified for a tableau the function `basis_pivot!` can be used to specify which column should enter the basis and which column should leave.
```
julia> T
┌──────────┬───┬──────┬────────┬───────┬─────┬─────┬──────┐
│          │ z │  x_1 │    x_2 │   x_3 │ x_4 │ x_5 │  RHS │
│ Obj Func │ 1 │    2 │  -68/5 │ -18/5 │   0 │   0 │ 11/5 │
├──────────┼───┼──────┼────────┼───────┼─────┼─────┼──────┤
│   Cons 1 │ 0 │  1/3 │ -11/15 │  -2/5 │   1 │   0 │ 2/15 │
│   Cons 2 │ 0 │ -4/3 │ -16/15 │   3/5 │   0 │   1 │ 7/15 │
└──────────┴───┴──────┴────────┴───────┴─────┴─────┴──────┘


julia> get_basis(T)
2-element Vector{Int64}:
 4
 5

julia> basis_pivot!(T,1,4)
┌──────────┬───┬─────┬───────┬──────┬─────┬─────┬─────┐
│          │ z │ x_1 │   x_2 │  x_3 │ x_4 │ x_5 │ RHS │
│ Obj Func │ 1 │   0 │ -46/5 │ -6/5 │  -6 │   0 │ 7/5 │
├──────────┼───┼─────┼───────┼──────┼─────┼─────┼─────┤
│   Cons 1 │ 0 │   1 │ -11/5 │ -6/5 │   3 │   0 │ 2/5 │
│   Cons 2 │ 0 │   0 │    -4 │   -1 │   4 │   1 │   1 │
└──────────┴───┴─────┴───────┴──────┴─────┴─────┴─────┘


julia> get_basis(T)
2-element Vector{Int64}:
 1
 5
```

Here, we pivoted the tableau so that column 1 replaced column 4. 

## Finding Pivots

The function `find_pivot` returns a pair `(s,t)` as a recommended basis pivot for a `Tableau`. 
```
julia> T
┌──────────┬───┬─────┬──────┬──────┬─────┬─────┬──────┐
│          │ z │ x_1 │  x_2 │  x_3 │ x_4 │ x_5 │  RHS │
│ Obj Func │ 1 │  -2 │  3/2 │ -1/2 │   0 │   0 │ -1/2 │
├──────────┼───┼─────┼──────┼──────┼─────┼─────┼──────┤
│   Cons 1 │ 0 │  -1 │ -7/4 │ -7/4 │   1 │   0 │  1/4 │
│   Cons 2 │ 0 │ 1/2 │  5/8 │  5/8 │   0 │   1 │  5/8 │
└──────────┴───┴─────┴──────┴──────┴─────┴─────┴──────┘


julia> find_pivot(T)
(2, 5)

julia> basis_pivot!(T,2,5)
┌──────────┬───┬───────┬─────┬─────┬─────┬───────┬─────┐
│          │ z │   x_1 │ x_2 │ x_3 │ x_4 │   x_5 │ RHS │
│ Obj Func │ 1 │ -16/5 │   0 │  -2 │   0 │ -12/5 │  -2 │
├──────────┼───┼───────┼─────┼─────┼─────┼───────┼─────┤
│   Cons 1 │ 0 │   4/5 │   1 │   1 │   0 │   8/5 │   1 │
│   Cons 2 │ 0 │   2/5 │   0 │   0 │   1 │  14/5 │   2 │
└──────────┴───┴───────┴─────┴─────┴─────┴───────┴─────┘
```

Note that `find_pivot` returns `(0,0)` if there are no feasible pivots. 

### Finding a pivot for a specific column

The function `find_pivot` can be invoked with a third argument specifying a column in which to find a pivot. That is `find_pivot(T, j)` returns a pair `(i,j)` so that `pivot!(T,i,j)` is feasible. 


```
julia> T
┌──────────┬───┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┐
│          │ z │ x_1 │ x_2 │ x_3 │ x_4 │ x_5 │ x_6 │ x_7 │ x_8 │ RHS │
│ Obj Func │ 1 │  29 │  -5 │  24 │  -4 │  -5 │   0 │   0 │   0 │   6 │
├──────────┼───┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┤
│   Cons 1 │ 0 │  -2 │  -2 │   2 │   5 │   0 │   1 │   0 │   0 │   5 │
│   Cons 2 │ 0 │   5 │  -1 │   4 │   2 │  -2 │   0 │   1 │   0 │   6 │
│   Cons 3 │ 0 │  -2 │   0 │  -2 │   1 │  -1 │   0 │   0 │   1 │   7 │
└──────────┴───┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┘


julia> find_pivot(T,1)
(1, 7)

julia> find_pivot(T,3)
(3, 7)

julia> basis_pivot!(T,3,7)
┌──────────┬───┬──────┬──────┬─────┬─────┬──────┬─────┬──────┬─────┬─────┐
│          │ z │  x_1 │  x_2 │ x_3 │ x_4 │  x_5 │ x_6 │  x_7 │ x_8 │ RHS │
│ Obj Func │ 1 │   -1 │    1 │   0 │ -16 │    7 │   0 │   -6 │   0 │ -30 │
├──────────┼───┼──────┼──────┼─────┼─────┼──────┼─────┼──────┼─────┼─────┤
│   Cons 1 │ 0 │  5/4 │ -1/4 │   1 │ 1/2 │ -1/2 │   0 │  1/4 │   0 │ 3/2 │
│   Cons 2 │ 0 │ -9/2 │ -3/2 │   0 │   4 │    1 │   1 │ -1/2 │   0 │   2 │
│   Cons 3 │ 0 │  1/2 │ -1/2 │   0 │   2 │   -2 │   0 │  1/2 │   1 │  10 │
└──────────┴───┴──────┴──────┴─────┴─────┴──────┴─────┴──────┴─────┴─────┘
```

## Starting Over

Use `restore!(T)` to return `T` to its original values before any pivoting was performed or basis was specified. 
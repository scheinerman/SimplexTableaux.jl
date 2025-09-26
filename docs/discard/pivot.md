# Pivoting Tableaux

## Indexing

The `i,j`-entry of a tableau is the entry in constraint row `i` and in the column of `x_j`. 
The objective function row in the header is considered row 0 and the entries below `z` form
column 0. Pivoting is only permitted for positive `i` and `j`.

The `i,j`-entry of a tableau `T` can be accessed using `T[i,j]`. This is a read-only operation; values in the tableau cannot be changed.

```
julia> T
┌──────────┬───┬─────┬─────┬─────┬─────┬─────┬─────┐
│          │ z │ x_1 │ x_2 │ x_3 │ x_4 │ x_5 │ RHS │
│ Obj Func │ 1 │  -2 │  -4 │  -2 │  -1 │   1 │   0 │
├──────────┼───┼─────┼─────┼─────┼─────┼─────┼─────┤
│   Cons 1 │ 0 │   2 │   1 │   0 │   9 │  -1 │   9 │
│   Cons 2 │ 0 │   1 │   1 │  -1 │   5 │   1 │   7 │
└──────────┴───┴─────┴─────┴─────┴─────┴─────┴─────┘


julia> T[0,3]   # header row entry under x_3
-2

julia> T[2,5]   # entry in constraint 2 under x_5
1

julia> T[2,6]   # entry in constraint 2 under RHS
7
```


## Row/Column Pivoting

The function `pivot!` pivots on an element of a tableau. The `(i,j)`-entry in a tableau
corresponts to the entry the row labeled `Cons i` and in the column labeled `x_j`. 


The syntax is `pivot!(T, i, j)` which will pivot the tableau on the entry corresponding to constraint `i` and variable `x_j`; that is, it performs a pivot on the `i,j`-element of the tableau.

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


julia> pivot!(T,2,4)
┌──────────┬───┬─────┬─────┬─────┬─────┬─────┐
│          │ z │ x_1 │ x_2 │ x_3 │ x_4 │ RHS │
│ Obj Func │ 1 │  -5 │   7 │  -5 │   0 │ -12 │
├──────────┼───┼─────┼─────┼─────┼─────┼─────┤
│   Cons 1 │ 0 │ 7/2 │   2 │  -4 │   0 │   6 │
│   Cons 2 │ 0 │ 3/2 │  -1 │   0 │   1 │   3 │
└──────────┴───┴─────┴─────┴─────┴─────┴─────┘
```
The pivot was performed on the `2` in the bottom row of `T`.

## Finding Pivots

The function `find_pivot` returns a pair `(i,j)` as a recommended basis pivot for a tableau. 
```
julia> T
┌──────────┬───┬─────┬────────┬─────┬──────┬──────┐
│          │ z │ x_1 │    x_2 │ x_3 │  x_4 │  RHS │
│ Obj Func │ 1 │   0 │   -7/4 │   0 │ 25/4 │ -3/4 │
├──────────┼───┼─────┼────────┼─────┼──────┼──────┤
│   Cons 1 │ 0 │   1 │   -2/3 │   0 │  2/3 │    2 │
│   Cons 2 │ 0 │   0 │ -13/12 │   1 │ 7/12 │  1/4 │
└──────────┴───┴─────┴────────┴─────┴──────┴──────┘


julia> find_pivot(T)
(2, 4)

julia> pivot!(T,2,4)
┌──────────┬───┬─────┬───────┬───────┬─────┬───────┐
│          │ z │ x_1 │   x_2 │   x_3 │ x_4 │   RHS │
│ Obj Func │ 1 │   0 │  69/7 │ -75/7 │   0 │ -24/7 │
├──────────┼───┼─────┼───────┼───────┼─────┼───────┤
│   Cons 1 │ 0 │   1 │   4/7 │  -8/7 │   0 │  12/7 │
│   Cons 2 │ 0 │   0 │ -13/7 │  12/7 │   1 │   3/7 │
└──────────┴───┴─────┴───────┴───────┴─────┴───────┘
```

Note that `find_pivot` returns `(0,0)` if there are no feasible pivots. 

### Finding a pivot for a specific column

The function `find_pivot` can be invoked with a second argument specifying a column in which to find a pivot. 
That is `find_pivot(T, j)` returns a pair `(i,j)` so that `pivot!(T,i,j)` is feasible. 


```
julia> T
┌──────────┬───┬─────┬─────┬───────┬───────┬────────┬─────────┬─────┬────────┐
│          │ z │ x_1 │ x_2 │   x_3 │   x_4 │    x_5 │     x_6 │ x_7 │    RHS │
│ Obj Func │ 1 │   0 │   0 │ 85/42 │  17/7 │ 149/21 │ -145/42 │   0 │ 202/21 │
├──────────┼───┼─────┼─────┼───────┼───────┼────────┼─────────┼─────┼────────┤
│   Cons 1 │ 0 │   1 │   0 │  -1/3 │   1/2 │   -1/3 │     1/3 │   0 │    5/6 │
│   Cons 2 │ 0 │   0 │   1 │ 32/21 │ -1/14 │  86/21 │    1/21 │   0 │   5/42 │
│   Cons 3 │ 0 │   0 │   0 │ 13/42 │  1/14 │   5/21 │    5/42 │   1 │  23/42 │
└──────────┴───┴─────┴─────┴───────┴───────┴────────┴─────────┴─────┴────────┘


julia> find_pivot(T,3)
(2, 3)

julia> find_pivot(T,4)
(1, 4)

julia> find_pivot(T,5)
(2, 5)

julia> find_pivot(T,6)   # Column 6 is headed by a negative number
[ Info: Invalid column for pivot, 6.
(0, 0)
```

## Other row operations
### Scaling

The function `scale_row!(T, i, m)` modifies the tableau `T` by multiplying constraint row `i` by the nonzero scalar `m`. 

```
julia> T
┌──────────┬───┬─────┬─────┬─────┬─────┐
│          │ z │ x_1 │ x_2 │ x_3 │ RHS │
│ Obj Func │ 1 │  -3 │  -4 │   1 │   0 │
├──────────┼───┼─────┼─────┼─────┼─────┤
│   Cons 1 │ 0 │   0 │   1 │   2 │   4 │
│   Cons 2 │ 0 │   3 │   0 │  -1 │   5 │
└──────────┴───┴─────┴─────┴─────┴─────┘

julia> scale_row!(T, 2, 1//3)
┌──────────┬───┬─────┬─────┬──────┬─────┐
│          │ z │ x_1 │ x_2 │  x_3 │ RHS │
│ Obj Func │ 1 │  -3 │  -4 │    1 │   0 │
├──────────┼───┼─────┼─────┼──────┼─────┤
│   Cons 1 │ 0 │   0 │   1 │    2 │   4 │
│   Cons 2 │ 0 │   1 │   0 │ -1/3 │ 5/3 │
└──────────┴───┴─────┴─────┴──────┴─────┘
```

### Swapping

`swap_rows!(T, i, j)` swaps rows (contraints) `i` and `j`:
```
julia> T
┌──────────┬───┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┐
│          │ z │ x_1 │ x_2 │ x_3 │ x_4 │ x_5 │ x_6 │ x_7 │ RHS │
│ Obj Func │ 1 │  -9 │  -4 │  -2 │  -2 │  -7 │  -7 │  -3 │   0 │
├──────────┼───┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┤
│   Cons 1 │ 0 │   2 │   2 │   3 │   1 │   8 │   1 │   2 │   3 │
│   Cons 2 │ 0 │   3 │   1 │   3 │   2 │   5 │   2 │   8 │   7 │
│   Cons 3 │ 0 │   8 │   2 │   1 │   4 │   6 │   3 │   2 │   8 │
└──────────┴───┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┘


julia> swap_rows!(T,2,3)
┌──────────┬───┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┐
│          │ z │ x_1 │ x_2 │ x_3 │ x_4 │ x_5 │ x_6 │ x_7 │ RHS │
│ Obj Func │ 1 │  -9 │  -4 │  -2 │  -2 │  -7 │  -7 │  -3 │   0 │
├──────────┼───┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┤
│   Cons 1 │ 0 │   2 │   2 │   3 │   1 │   8 │   1 │   2 │   3 │
│   Cons 2 │ 0 │   8 │   2 │   1 │   4 │   6 │   3 │   2 │   8 │
│   Cons 3 │ 0 │   3 │   1 │   3 │   2 │   5 │   2 │   8 │   7 │
└──────────┴───┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┘
```


## Starting Over

Use `restore!(T)` to return `T` to its original values before any pivoting was performed or basis was specified. 
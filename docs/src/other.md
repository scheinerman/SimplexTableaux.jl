
# Other Features

## Status Functions

The `status` function returns a symbol indicating the state of the tableau, `T`. The result 
of `status(T)` is one of the following:
* `:no_basis` -- no basis has been established for this tableau.
* `:feasible` -- the tableau is in a feasible state, but not optimal (rhs is nonnegative).
* `:infeasible` -- the tableau is in an infeasible state (rhs contains negative values). 
* `:optimal` -- the tableau has reached a global minimization point, This supercedes `:feasible`. 
* `:unbounded` -- the tableau has reached a feasible state, but there are no pivots; the objective function value can be arbitrarily negative. This supercedes `:feasible`.


These functions are superfluous but may be convenient: 
* `in_feasible_state(T)` returns `true` if the current basic vector is in the feasible region (including if at optimality).
* `in_optimal_state(T)` returns `true` if the tableau has reached an optimal (minimal) state.


## Miscellaneous Functions

* `basic_vector(T)` returns the vector in which the nonbasic variables have been set to zero. 
* `header(T)` returns the top row of `T` (negative reduced costs). Does not include the `1` in column `0` nor the value in the last column. 
* `get_Abc(T)` returns the original matrix `A` and the vectors `b` and `c` for the standard presentation of the linear program.
* `get_basis(T)` returns the column numbers of the current basis.
* `is_infeasible(T)` returns `true` if the linear program's feasible region is empty. 
* `is_unbounded(T)` returns `true` if the linear program is unbounded (below).
* `rhs(T)` returns the righthand column of `T` (from row `1` onward -- does not include the value in row `0`).
* `value(T)` returns the objective function value of the current basic vector. 
* `value(T,x)` returns the objective function value for the vector `x`. May also be invoked as `T(x)`. 


## Return to Start

The function `restore!` returns the tableau to its state when it was constructed. 
```
julia> T
┌──────────┬───┬─────┬─────┬────────┬─────┬─────────┬──────────┐
│          │ z │ x_1 │ x_2 │    x_3 │ x_4 │     x_5 │      RHS │
│ Obj Func │ 1 │   0 │   0 │ -25/47 │   0 │ -110/47 │ 13500/47 │
├──────────┼───┼─────┼─────┼────────┼─────┼─────────┼──────────┤
│   Cons 1 │ 0 │   1 │   0 │   1/47 │   0 │   -5/47 │   400/47 │
│   Cons 2 │ 0 │   0 │   0 │ -25/47 │   1 │  -16/47 │  -600/47 │
│   Cons 3 │ 0 │   0 │   1 │  -5/47 │   0 │    3/94 │   350/47 │
└──────────┴───┴─────┴─────┴────────┴─────┴─────────┴──────────┘


julia> restore!(T)
┌──────────┬───┬─────┬─────┬─────┬─────┬─────┬─────┐
│          │ z │ x_1 │ x_2 │ x_3 │ x_4 │ x_5 │ RHS │
│ Obj Func │ 1 │ -25 │ -10 │   0 │   0 │   0 │   0 │
├──────────┼───┼─────┼─────┼─────┼─────┼─────┼─────┤
│   Cons 1 │ 0 │   3 │  10 │  -1 │   0 │   0 │ 100 │
│   Cons 2 │ 0 │   5 │   6 │   0 │  -1 │   0 │ 100 │
│   Cons 3 │ 0 │  10 │   2 │   0 │   0 │  -1 │ 100 │
└──────────┴───┴─────┴─────┴─────┴─────┴─────┴─────┘
```




## LaTeX Output

Using [LatexPrint](https://github.com/scheinerman/LatexPrint.jl) users can get the 
code for pasting into a LaTeX document.
```
julia> using LatexPrint

julia> T
┌──────────┬───┬─────┬─────┬─────┬─────┬──────┬─────┐
│          │ z │ x_1 │ x_2 │ x_3 │ x_4 │  x_5 │ RHS │
│ Obj Func │ 1 │   0 │  -3 │  -2 │   8 │    0 │   9 │
├──────────┼───┼─────┼─────┼─────┼─────┼──────┼─────┤
│   Cons 1 │ 0 │   1 │ 1/2 │   0 │ 9/2 │ -1/2 │ 9/2 │
│   Cons 2 │ 0 │   0 │ 1/2 │  -1 │ 1/2 │  3/2 │ 5/2 │
└──────────┴───┴─────┴─────┴─────┴─────┴──────┴─────┘


julia> lap(T)
\begin{tabular}{|c|ccccc|c|}\hline 
{\Large\strut}$z$ &$x_{1}$ & $x_{2}$ & $x_{3}$ & $x_{4}$ & $x_{5}$ & RHS \\
{\Large\strut}$1$ & $0$ & $-3$ & $-2$ & $8$ & $0$ & $9$\\
\hline 
{\Large\strut}$0$ & $1$ & $\frac{1}{2}$ & $0$ & $\frac{9}{2}$ & $\frac{-1}{2}$ & $\frac{9}{2}$\\
{\Large\strut}$0$ & $0$ & $\frac{1}{2}$ & $-1$ & $\frac{1}{2}$ & $\frac{3}{2}$ & $\frac{5}{2}$\\
\hline 
\end{tabular}
```

Here is the LaTeX output:

![](tableau.png)


## Other Public Functions

Presently, these functions are exported in `SimplexTableaux` but might be hidden in future releases. 
They are not likely to be useful to the users of this module. 
See the doc strings for more information:
 
* `big_M_tableau`
* `check_basis`
* `find_pivot_column`
* `infer_basis!`


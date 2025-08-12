
# Other Features

## Inspection Functions

* `basic_vector(T)` returns the vector in which the nonbasic variables have been set to zero. 
* `get_Abc(T)` returns the original matrix `A` and the vectors `b` and `c` for the standard presentation of the linear program.
* `get_basis(T)` returns the column numbers of the current basis.
* `is_feasible(T)` returns `true` if the current basic vector is in the feasible region.
* `is_optimal(T)` returns `true` if the tableau has reached an optimal (minimal) state.
* `value(T)` returns the objective function value of the current basic vector. 



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


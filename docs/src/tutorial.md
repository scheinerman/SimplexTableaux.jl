# Tutorial

This is a step-by-step guide for solving linear programs using the `SimplexTableau` module.

## Set up the problem


This module enables the user to solve linear program problems in one of the following two forms:
* **Standard**: ``\min c^T  x`` subject to ``A x = b, x ≥ 0``. Use: `Tableau(A,b,c,false)`. 
* **Canonical**: ``\min c^T  x`` subject to ``A x ≥ b, x ≥ 0``. Use: `Tableau(A,b,c)`.

Here, ``A`` is an ``m \times n``-matrix, ``b`` is an ``m``-vector, and ``c`` is an ``n``-vector. 

> Only minimization problems are supported. 



### Example: Standard form linear program

Let 
$A=\left[
\begin{array}{rrrrrr}
1 & 8 & -2 & 8 & 6 & -1 \\
2 & 6 & 2 & 9 & 2 & 1 \\
6 & 3 & 5 & 9 & 7 & 1 \\
\end{array}
\right]$, 
$b= \left[
\begin{array}{r}
-2 \\
4 \\
9 \\
\end{array}
\right]$,
and
$c = \left[
\begin{array}{r}
0 \\
3 \\
3 \\
-1 \\
2 \\
-4 \\
\end{array}
\right]$. 

Here is how to set up the standard LP $\min c^T x$ s.t. $Ax=b,x\ge0$:

```
julia> A = [1 8 -2 8 6 -1; 2 6 2 9 2 1; 6 3 5 9 7 1];

julia> b = [-2, 4, 9];

julia> c = [0, 3, 3, -1, 2, -4];

julia> T = Tableau(A, b, c, false)
┌──────────┬───┬─────┬─────┬─────┬─────┬─────┬─────┬─────┐
│          │ z │ x_1 │ x_2 │ x_3 │ x_4 │ x_5 │ x_6 │ RHS │
│ Obj Func │ 1 │   0 │  -3 │  -3 │   1 │  -2 │   4 │   0 │
├──────────┼───┼─────┼─────┼─────┼─────┼─────┼─────┼─────┤
│   Cons 1 │ 0 │   1 │   8 │  -2 │   8 │   6 │  -1 │  -2 │
│   Cons 2 │ 0 │   2 │   6 │   2 │   9 │   2 │   1 │   4 │
│   Cons 3 │ 0 │   6 │   3 │   5 │   9 │   7 │   1 │   9 │
└──────────┴───┴─────┴─────┴─────┴─────┴─────┴─────┴─────┘
```
Note the `false` in the function call; it indicates that this is not canoncial (that is, it is standard) so no slack variables are added. 

Written as a (partitioned) matrix, this tableau looks like this:

$\left[
\begin{array}{r|rrrrrr|r}
1 & 0 & -3 & -3 & 1 & -2 & 4 & 0 \\ \hline
0 & 1 & 8 & -2 & 8 & 6 & -1 & -2 \\
0 & 2 & 6 & 2 & 9 & 2 & 1 & 4 \\
0 & 6 & 3 & 5 & 9 & 7 & 1 & 9 \\
\end{array}
\right]
$


The top (header) two represents the objective function we wish to minimize:
$z = 0x_1 + 3x_2 + 3x_3 - x_4 + 2x_5 - 4x_6$. It is rearranged to appear in the form 
$z - 0x_1 - 3x_2 - 3x_3 + x_4 - 2x_5 + 4x_6 = 0$. 

The next three rows are the constraints from $A x = b$. For example, the first constraint is
$x_1 + 8x_2 - 2x_3 + 8x_4 + 6x_5 - x_6 = -2$.






### Example: Canonical form linear program

Let $A=\left[
\begin{array}{rrrr}
7 & 5 & 2 & 9 \\
5 & 9 & 5 & 5 \\
\end{array}
\right]$, 
$b=\left[
\begin{array}{r}
2 \\
5 \\
\end{array}
\right]
$, and
$c=\left[
\begin{array}{r}
7 \\
6 \\
3 \\
4 \\
\end{array}
\right]$. 

Here is how to set up the canonical LP $\min c^T x$ s.t. $Ax\ge b, x\ge0$:

```
julia> A = [7 5 2 9; 5 9 5 5];

julia> b = [2, 5];

julia> c = [7, 6, 3, 4];

julia> T = Tableau(A, b, c)
┌──────────┬───┬─────┬─────┬─────┬─────┬─────┬─────┬─────┐
│          │ z │ x_1 │ x_2 │ x_3 │ x_4 │ x_5 │ x_6 │ RHS │
│ Obj Func │ 1 │  -7 │  -6 │  -3 │  -4 │   0 │   0 │   0 │
├──────────┼───┼─────┼─────┼─────┼─────┼─────┼─────┼─────┤
│   Cons 1 │ 0 │   7 │   5 │   2 │   9 │  -1 │   0 │   2 │
│   Cons 2 │ 0 │   5 │   9 │   5 │   5 │   0 │  -1 │   5 │
└──────────┴───┴─────┴─────┴─────┴─────┴─────┴─────┴─────┘
```
Note that $x_5$ and $x_6$ are added as slack variables. Therefore the first constraint is
$7x_1 + 5x_2 +2 x_3 +9x_4 - x_5=2$ is equivalent to
$7x_1 + 5x_2 +2 x_3 +9x_4 \ge 2$. 

The objective function is $z = 7x_1 + 6x_2 + 3x_3 + 4x_4$ that is encoded in the tableau 
as $z-7x_1 -6x_2 -3x_3 -4x_4=0$. 


## Pivoting

Pivoting is a fundamental operation in linear algebra that is used extensively in the Simplex Method. A pivot on a element $a_{ij}$ of a matrix begins by multiplying row $i$ by $1/a_{ij}$. This leaves a $1$ in position $i,j$. Then multiples of row $i$ are added to the other rows so that all the other entries in column $j$ are now $0$. 

For example, suppose we wish to pivot on the $2$ in this matrix:

$\left[
\begin{array}{r|rrrrrr|r}
1 & -7 & -6 & -3 & -4 & 0 & 0 & 0 \\ \hline
0 & 7 & 5 & \fbox2 & 9 & -1 & 0 & 2 \\
0 & 5 & 9 & 5 & 5 & 0 & -1 & 5 \\
\end{array}
\right]$

The main body of the matrix lies below the header row and between the vertical dividers. This is considered to be the $1,3$-entry of the matrix: this corresponds to the constraint $1$ in the column of $x_3$. 

First we multiply row $1$ through by $1/2$:

$\left[
\begin{array}{r|rrrrrr|r}
1 & -7 & -6 & -3 & -4 & 0 & 0 & 0 \\ \hline
0 & 7/2 & 5/2 & 1 & 9/2 & -1/2 & 0 & 1 \\
0 & 5 & 9 & 5 & 5 & 0 & -1 & 5 
\end{array}
\right]$

Then we add $3$ times the first row to the header (row $0$) and $-5$ times the first row to the second row:

$\left[
\begin{array}{r|rrrrrr|r}
1 & 7/2 & 3/2 & 0 & 19/2 & -3/2 & 0 & 3 \\ \hline
0 & 7/2 & 5/2 & 1 & 9/2 & -1/2 & 0 & 1 \\
0 & -25/2 & -7/2 & 0 & -35/2 & 5/2 & -1 & 0 \\
\end{array}
\right]$

In the `SimplexTableau` module, this operation is accomplished with the `pivot!` function:
```
julia> T
┌──────────┬───┬─────┬─────┬─────┬─────┬─────┬─────┬─────┐
│          │ z │ x_1 │ x_2 │ x_3 │ x_4 │ x_5 │ x_6 │ RHS │
│ Obj Func │ 1 │  -7 │  -6 │  -3 │  -4 │   0 │   0 │   0 │
├──────────┼───┼─────┼─────┼─────┼─────┼─────┼─────┼─────┤
│   Cons 1 │ 0 │   7 │   5 │   2 │   9 │  -1 │   0 │   2 │
│   Cons 2 │ 0 │   5 │   9 │   5 │   5 │   0 │  -1 │   5 │
└──────────┴───┴─────┴─────┴─────┴─────┴─────┴─────┴─────┘


julia> pivot!(T,1,3)
[ Info: Unable to infer basis
┌──────────┬───┬───────┬──────┬─────┬───────┬──────┬─────┬─────┐
│          │ z │   x_1 │  x_2 │ x_3 │   x_4 │  x_5 │ x_6 │ RHS │
│ Obj Func │ 1 │   7/2 │  3/2 │   0 │  19/2 │ -3/2 │   0 │   3 │
├──────────┼───┼───────┼──────┼─────┼───────┼──────┼─────┼─────┤
│   Cons 1 │ 0 │   7/2 │  5/2 │   1 │   9/2 │ -1/2 │   0 │   1 │
│   Cons 2 │ 0 │ -25/2 │ -7/2 │   0 │ -35/2 │  5/2 │  -1 │   0 │
└──────────┴───┴───────┴──────┴─────┴───────┴──────┴─────┴─────┘
```





## Bases

The Simplex Method begins by finding a set of $m$ columns (where $m$ is the number of 
constraints) that are linearly independent. We pivot on elements of those columns to 
transform them into standard basis vectors. That is, in each of those columns there is a single $1$ 
all other elements of that column are $0$ (including in the header).

In the example we just considered, we see that pivoting on the $-1$ in the $(2,6)$ position 
will result in columns $3$ and $6$ forming a basis, and so those columns are called *basic*. 
```
julia> T
┌──────────┬───┬───────┬──────┬─────┬───────┬──────┬─────┬─────┐
│          │ z │   x_1 │  x_2 │ x_3 │   x_4 │  x_5 │ x_6 │ RHS │
│ Obj Func │ 1 │   7/2 │  3/2 │   0 │  19/2 │ -3/2 │   0 │   3 │
├──────────┼───┼───────┼──────┼─────┼───────┼──────┼─────┼─────┤
│   Cons 1 │ 0 │   7/2 │  5/2 │   1 │   9/2 │ -1/2 │   0 │   1 │
│   Cons 2 │ 0 │ -25/2 │ -7/2 │   0 │ -35/2 │  5/2 │  -1 │   0 │
└──────────┴───┴───────┴──────┴─────┴───────┴──────┴─────┴─────┘

julia> pivot!(T,2,6)
┌──────────┬───┬──────┬─────┬─────┬──────┬──────┬─────┬─────┐
│          │ z │  x_1 │ x_2 │ x_3 │  x_4 │  x_5 │ x_6 │ RHS │
│ Obj Func │ 1 │  7/2 │ 3/2 │   0 │ 19/2 │ -3/2 │   0 │   3 │
├──────────┼───┼──────┼─────┼─────┼──────┼──────┼─────┼─────┤
│   Cons 1 │ 0 │  7/2 │ 5/2 │   1 │  9/2 │ -1/2 │   0 │   1 │
│   Cons 2 │ 0 │ 25/2 │ 7/2 │   0 │ 35/2 │ -5/2 │   1 │   0 │
└──────────┴───┴──────┴─────┴─────┴──────┴──────┴─────┴─────┘

julia> get_basis(T)
2-element Vector{Int64}:
 3
 6
```
The `get_basis` function returns the current basis. If the tableau does not have a basis, a vector of all zeros is returned. 

On the computer display, the labels of the basic columns are green. 

![](basic-tableau.png)


### Setting a basis

The function `set_basis!` is used to select columns to be a basis. This is invoked as 
`set_basis(T, B)` where `B` is a list of $m$ indices specifying the columns to form a basis. 

For example:
```
julia> set_basis!(T,[2,4])
┌──────────┬───┬────────┬─────┬──────┬─────┬───────┬────────┬──────┐
│          │ z │    x_1 │ x_2 │  x_3 │ x_4 │   x_5 │    x_6 │  RHS │
│ Obj Func │ 1 │ -45/14 │   0 │  1/4 │   0 │ -3/28 │ -17/28 │ 13/4 │
├──────────┼───┼────────┼─────┼──────┼─────┼───────┼────────┼──────┤
│   Cons 1 │ 0 │   5/28 │   1 │  5/8 │   0 │  5/56 │  -9/56 │  5/8 │
│   Cons 2 │ 0 │  19/28 │   0 │ -1/8 │   1 │ -9/56 │   5/56 │ -1/8 │
└──────────┴───┴────────┴─────┴──────┴─────┴───────┴────────┴──────┘
```

However, this basis is not suitable for the Simplex Algorithm because the RHS column contains negative numbers. In other words, $\{2,4\}$  is an *infeasible* basis. On the other hand $\{3,6\}$ yields a 
feasible tableau.
```
julia> set_basis!(T,[3,6])
┌──────────┬───┬──────┬─────┬─────┬──────┬──────┬─────┬─────┐
│          │ z │  x_1 │ x_2 │ x_3 │  x_4 │  x_5 │ x_6 │ RHS │
│ Obj Func │ 1 │  7/2 │ 3/2 │   0 │ 19/2 │ -3/2 │   0 │   3 │
├──────────┼───┼──────┼─────┼─────┼──────┼──────┼─────┼─────┤
│   Cons 1 │ 0 │  7/2 │ 5/2 │   1 │  9/2 │ -1/2 │   0 │   1 │
│   Cons 2 │ 0 │ 25/2 │ 7/2 │   0 │ 35/2 │ -5/2 │   1 │   0 │
└──────────┴───┴──────┴─────┴─────┴──────┴──────┴─────┴─────┘
```


### Automatic basis selection

While any $m$ linearly independent columns may be selected to form a basis, finding a set of columns
that yield a feasible tableau can be difficult. Below we describe a method for finding a basis, 
but we also provide tools to make this easy.

The function `find_a_basis` will automatically find a feasible basis. Combined with `set_basis!` 
the resut is a tableau that has been pivoted to a feasible configuation. 
```
julia> T
┌──────────┬───┬─────┬─────┬─────┬─────┬─────┬─────┬─────┐
│          │ z │ x_1 │ x_2 │ x_3 │ x_4 │ x_5 │ x_6 │ RHS │
│ Obj Func │ 1 │  -7 │  -6 │  -3 │  -4 │   0 │   0 │   0 │
├──────────┼───┼─────┼─────┼─────┼─────┼─────┼─────┼─────┤
│   Cons 1 │ 0 │   7 │   5 │   2 │   9 │  -1 │   0 │   2 │
│   Cons 2 │ 0 │   5 │   9 │   5 │   5 │   0 │  -1 │   5 │
└──────────┴───┴─────┴─────┴─────┴─────┴─────┴─────┴─────┘


julia> find_a_basis(T)
2-element Vector{Int64}:
 2
 5

julia> set_basis!(T,[2,5])
┌──────────┬───┬───────┬─────┬─────┬───────┬─────┬──────┬──────┐
│          │ z │   x_1 │ x_2 │ x_3 │   x_4 │ x_5 │  x_6 │  RHS │
│ Obj Func │ 1 │ -11/3 │   0 │ 1/3 │  -2/3 │   0 │ -2/3 │ 10/3 │
├──────────┼───┼───────┼─────┼─────┼───────┼─────┼──────┼──────┤
│   Cons 1 │ 0 │   5/9 │   1 │ 5/9 │   5/9 │   0 │ -1/9 │  5/9 │
│   Cons 2 │ 0 │ -38/9 │   0 │ 7/9 │ -56/9 │   1 │ -5/9 │  7/9 │
└──────────┴───┴───────┴─────┴─────┴───────┴─────┴──────┴──────┘
```

Alternatively, invoking `set_basis!(T)` without specifying a basis will 
use `find_a_basis` to choose the basis for you. 

If the tableau does not have a feasible basis, `find_a_basis` returns a vector of all zeros.
```
julia> T
┌──────────┬───┬─────┬─────┬─────┬─────┬─────┬─────┐
│          │ z │ x_1 │ x_2 │ x_3 │ x_4 │ x_5 │ RHS │
│ Obj Func │ 1 │  -3 │  -1 │  -5 │  -2 │  -5 │   0 │
├──────────┼───┼─────┼─────┼─────┼─────┼─────┼─────┤
│   Cons 1 │ 0 │   3 │   2 │   2 │   2 │   3 │   4 │
│   Cons 2 │ 0 │   4 │   4 │   3 │   5 │   2 │   2 │
│   Cons 3 │ 0 │   1 │   2 │   4 │   2 │   1 │   1 │
└──────────┴───┴─────┴─────┴─────┴─────┴─────┴─────┘


julia> find_a_basis(T)
[ Info: No basis found.
3-element Vector{Int64}:
 0
 0
 0
```
### Listing all feasible bases

The function `find_all_bases` returns a list of all feasible bases for a tableau:
```
julia> T
┌──────────┬───┬─────┬─────┬─────┬─────┬─────┬─────┬─────┐
│          │ z │ x_1 │ x_2 │ x_3 │ x_4 │ x_5 │ x_6 │ RHS │
│ Obj Func │ 1 │   0 │  -3 │  -3 │   1 │  -2 │   4 │   0 │
├──────────┼───┼─────┼─────┼─────┼─────┼─────┼─────┼─────┤
│   Cons 1 │ 0 │   1 │   8 │  -2 │   8 │   6 │  -1 │  -2 │
│   Cons 2 │ 0 │   2 │   6 │   2 │   9 │   2 │   1 │   4 │
│   Cons 3 │ 0 │   6 │   3 │   5 │   9 │   7 │   1 │   9 │
└──────────┴───┴─────┴─────┴─────┴─────┴─────┴─────┴─────┘


julia> find_all_bases(T)
6-element Vector{Vector{Int64}}:
 [1, 2, 3]
 [1, 3, 4]
 [1, 3, 6]
 [2, 3, 5]
 [3, 4, 5]
 [3, 5, 6]
```

> The `find_all_bases` function is highly inefficient and only suitable for small linear programs. 


## Simplex Method

### Manually

### Fully automatic

## Two phase method (finding a first basis)

## Numerical solution
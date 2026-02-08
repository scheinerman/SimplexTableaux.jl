# Duality

## Mathematical Background

Minimization linear programs can be (sort-of metaphorically speaking) transposed into maximization problems by forming their duals.

* A canonical linear program is of the form $\min c^T x$ subject to $Ax \ge b$, $x\ge0$. The dual of this LP is $\max b^T y$ such that $A^Ty \le b$, $y\ge0$. 

* A standard linear program is of the form $\min c^T x$ subject to $Ax = b$, $x \ge 0$. The dual of this LP is $\max b^T y$ subject to $A^T y \le c$ (with no other restriction on $y$).

## Canonical Dual

The tableaux in this `SimplexTableaux` module are assumed to be for minimization problems. 
Canonical LPs are are converted to standard form using slack variables. 
Given a canonical LP (as described just above), the equivalent standard form LP looks like this:
$\min c^Tx + 0^Ts$ subject to $Ax - Is = b$, $x\ge0$, and $s\ge0$. 

For example, suppose
$A= \left[
\begin{array}{ccc}
3 & 2 & 1 \\
2 & 0 & 5 \\
\end{array}
\right]$, $b = \left[
\begin{array}{c}
5 \\
2 \\
\end{array}
\right]$, and 
$c = \left[
\begin{array}{c}
1 \\
2 \\
3 \\
\end{array}
\right]$.
The tableaux created by these instructions
```julia
A = [3 2 1; 2 0 5]
b = [5, 2]
c = [1, 2, 3]
T = Tableau(A, b, c, false)
```
is this
```
┌──────────┬───┬─────┬─────┬─────┬─────┬─────┬─────┐
│          │ z │ x_1 │ x_2 │ x_3 │ x_4 │ x_5 │ RHS │
│ Obj Func │ 1 │  -1 │  -2 │  -3 │   0 │   0 │   0 │
├──────────┼───┼─────┼─────┼─────┼─────┼─────┼─────┤
│   Cons 1 │ 0 │   3 │   2 │   1 │  -1 │   0 │   5 │
│   Cons 2 │ 0 │   2 │   0 │   5 │   0 │  -1 │   2 │
└──────────┴───┴─────┴─────┴─────┴─────┴─────┴─────┘
```
Note the addition of slack variables $x_4$ and $x_5$. 

The dual LP involves a maximization and $\le$-inequalities. To put this into a form suitable for this module, we replace $\max b^T y$ with $\min -b^Ty$ and we replace $A^Ty \le c$ with $-A^Ty \ge c$. This is now a minimization problem in canonical form that needs to be converted to standard form before processing by the Simplex Method. 

The `dual` function performs exactly these transformations to yield this:
```
julia> dT = dual(T)
┌──────────┬───┬─────┬─────┬─────┬─────┬─────┬─────┐
│          │ z │ x_1 │ x_2 │ x_3 │ x_4 │ x_5 │ RHS │
│ Obj Func │ 1 │   5 │   2 │   0 │   0 │   0 │   0 │
├──────────┼───┼─────┼─────┼─────┼─────┼─────┼─────┤
│   Cons 1 │ 0 │  -3 │  -2 │  -1 │   0 │   0 │  -1 │
│   Cons 2 │ 0 │  -2 │   0 │   0 │  -1 │   0 │  -2 │
│   Cons 3 │ 0 │  -1 │  -5 │   0 │   0 │  -1 │  -3 │
└──────────┴───┴─────┴─────┴─────┴─────┴─────┴─────┘
```

Running `simplex_solve!` on `T` and `dT` give these tableaux:
```
┌──────────┬───┬─────┬──────┬───────┬──────┬─────┬─────┐
│          │ z │ x_1 │  x_2 │   x_3 │  x_4 │ x_5 │ RHS │
│ Obj Func │ 1 │   0 │ -4/3 │  -8/3 │ -1/3 │   0 │ 5/3 │
├──────────┼───┼─────┼──────┼───────┼──────┼─────┼─────┤
│   Cons 1 │ 0 │   1 │  2/3 │   1/3 │ -1/3 │   0 │ 5/3 │
│   Cons 2 │ 0 │   0 │  4/3 │ -13/3 │ -2/3 │   1 │ 4/3 │
└──────────┴───┴─────┴──────┴───────┴──────┴─────┴─────┘
```
and
```
┌──────────┬───┬─────┬──────┬──────┬─────┬─────┬──────┐
│          │ z │ x_1 │  x_2 │  x_3 │ x_4 │ x_5 │  RHS │
│ Obj Func │ 1 │   0 │ -4/3 │ -5/3 │   0 │   0 │ -5/3 │
├──────────┼───┼─────┼──────┼──────┼─────┼─────┼──────┤
│   Cons 1 │ 0 │   1 │  2/3 │  1/3 │   0 │   0 │  1/3 │
│   Cons 2 │ 0 │   0 │ -4/3 │ -2/3 │   1 │   0 │  4/3 │
│   Cons 3 │ 0 │   0 │ 13/3 │ -1/3 │   0 │   1 │  8/3 │
└──────────┴───┴─────┴──────┴──────┴─────┴─────┴──────┘
```
Note that the opitmum value achieved for `dT` is `-5/3` because we replaced the function $b^Ty$ with $-b^Ty$. Hence, the maximum value of the actualy dual linear program is `5/3` (the same as the original LP).



## Standard Dual

The dual of $\min c^Tx$ s.t. $Ax=b$, $x\ge0$ is $\max b^Ty$ s.t. $A^Ty\le c$. To put this into standard form requires these modifications:

1. Replace $\max b^T y$ with $\min -b^Ty$.
1. Replace $y$ with $w'-w''$ where $w'\ge0$ and $w''\ge0$. 
1. Replace $A^Ty \le c$ with $-A^Ty \ge -c$ or, more expansively, $-A^T(w'-w'')\ge c$.

For example, suppose $A = \left[
\begin{array}{rrrrr}
2 & 0 & 1 & 1 & 3 \\
4 & 1 & 0 & 2 & 4 \\
3 & 1 & -1 & 2 & 2 \\
\end{array}
\right]$,
$b = \left[
\begin{array}{r}
8 \\
13 \\
8 \\
\end{array}
\right]$, and
$c = \left[
\begin{array}{r}
2 \\
2 \\
-1 \\
-3 \\
-2 \\
\end{array}
\right]$. 

The tableau is created by these instructions:
```julia
A = [2 0 1 1 3; 4 1 0 2 4; 3 1 -1 2 2]
b = [8; 13; 8]
c = [2; 2; -1; -3; -2]
T = Tableau(A, b, c, false)
```
is this
```
┌──────────┬───┬─────┬─────┬─────┬─────┬─────┬─────┐
│          │ z │ x_1 │ x_2 │ x_3 │ x_4 │ x_5 │ RHS │
│ Obj Func │ 1 │  -2 │  -2 │   1 │   3 │   2 │   0 │
├──────────┼───┼─────┼─────┼─────┼─────┼─────┼─────┤
│   Cons 1 │ 0 │   2 │   0 │   1 │   1 │   3 │   8 │
│   Cons 2 │ 0 │   4 │   1 │   0 │   2 │   4 │  13 │
│   Cons 3 │ 0 │   3 │   1 │  -1 │   2 │   2 │   8 │
└──────────┴───┴─────┴─────┴─────┴─────┴─────┴─────┘
```
We create the dual:
```
julia> dT = dual(T)
┌──────────┬───┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬──────┬──────┬─────┐
│          │ z │ x_1 │ x_2 │ x_3 │ x_4 │ x_5 │ x_6 │ x_7 │ x_8 │ x_9 │ x_10 │ x_11 │ RHS │
│ Obj Func │ 1 │   8 │  13 │   8 │  -8 │ -13 │  -8 │   0 │   0 │   0 │    0 │    0 │   0 │
├──────────┼───┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼──────┼──────┼─────┤
│   Cons 1 │ 0 │  -2 │  -4 │  -3 │   2 │   4 │   3 │  -1 │   0 │   0 │    0 │    0 │  -2 │
│   Cons 2 │ 0 │   0 │  -1 │  -1 │   0 │   1 │   1 │   0 │  -1 │   0 │    0 │    0 │  -2 │
│   Cons 3 │ 0 │  -1 │   0 │   1 │   1 │   0 │  -1 │   0 │   0 │  -1 │    0 │    0 │   1 │
│   Cons 4 │ 0 │  -1 │  -2 │  -2 │   1 │   2 │   2 │   0 │   0 │   0 │   -1 │    0 │   3 │
│   Cons 5 │ 0 │  -3 │  -4 │  -2 │   3 │   4 │   2 │   0 │   0 │   0 │    0 │   -1 │   2 │
└──────────┴───┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴──────┴──────┴─────┘
```
Please note that $x_7$ through $x_{10}$ are slack variables.

Solving these with `simplex_solve!` gives the following results for `T` and `dT`:
```
┌──────────┬───┬──────┬─────┬──────┬─────┬─────┬──────┐
│          │ z │  x_1 │ x_2 │  x_3 │ x_4 │ x_5 │  RHS │
│ Obj Func │ 1 │ -5/2 │   0 │ -1/2 │   0 │   0 │ -5/2 │
├──────────┼───┼──────┼─────┼──────┼─────┼─────┼──────┤
│   Cons 1 │ 0 │  1/2 │   0 │ -1/2 │   1 │   0 │  1/2 │
│   Cons 2 │ 0 │    1 │   1 │   -1 │   0 │   0 │    2 │
│   Cons 3 │ 0 │  1/2 │   0 │  1/2 │   0 │   1 │  5/2 │
└──────────┴───┴──────┴─────┴──────┴─────┴─────┴──────┘
```
and
```
┌──────────┬───┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬──────┬──────┬──────┐
│          │ z │ x_1 │ x_2 │ x_3 │ x_4 │ x_5 │ x_6 │ x_7 │ x_8 │ x_9 │ x_10 │ x_11 │  RHS │
│ Obj Func │ 1 │   0 │   0 │   0 │   0 │   0 │   0 │   0 │  -2 │   0 │ -1/2 │ -5/2 │  5/2 │
├──────────┼───┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼──────┼──────┼──────┤
│   Cons 1 │ 0 │   1 │   0 │   0 │  -1 │   0 │   0 │   0 │   2 │   0 │   -1 │    0 │    7 │
│   Cons 2 │ 0 │   0 │   0 │   1 │   0 │   0 │  -1 │   0 │   1 │   0 │ -3/2 │  1/2 │ 11/2 │
│   Cons 3 │ 0 │   0 │  -1 │   0 │   0 │   1 │   0 │   0 │   2 │   0 │ -3/2 │  1/2 │ 15/2 │
│   Cons 4 │ 0 │   0 │   0 │   0 │   0 │   0 │   0 │   1 │  -1 │   0 │ -1/2 │ -1/2 │  5/2 │
│   Cons 5 │ 0 │   0 │   0 │   0 │   0 │   0 │   0 │   0 │   1 │   1 │  1/2 │ -1/2 │  1/2 │
└──────────┴───┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴──────┴──────┴──────┘
```
As with canonical duals, the final objective value for `dT` is negative the desired maximum value for the actual dual. 



The final basic vector for `dT` is 
$\left[
\begin{array}{r}
0 \\
15/2 \\
0 \\
7 \\
0 \\
11/2 \\
\end{array}
\right]$ giving $w' = \left[
\begin{array}{r}
0 \\
15/2 \\
0 \\
\end{array}
\right]$ and 
$w'' =\left[
\begin{array}{r}
7 \\
0 \\
11/2 \\
\end{array}
\right]$. 
This yields 
$y= w'-w'' = \left[
\begin{array}{r}
-7 \\
15/2 \\
-11/2 \\
\end{array}
\right]$.

Check that $A^T y= \left[
\begin{array}{r}
-1/2 \\
2 \\
-3/2 \\
-3 \\
-2 \\
\end{array}
\right]$ which is, term by term, less than or equal to $c = \left[
\begin{array}{r}
2 \\
2 \\
-1 \\
-3 \\
-2 \\
\end{array}
\right]$ and that $b^T y = -5/2$. 

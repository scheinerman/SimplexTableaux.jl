# SimplexTableaux

This module can be used to solve linear programming problems using 
the Simplex Method by pivoting tableaux. 

This is an illusration project for solving feasible optimization problems of the form 
$\min c^T x$ subject to $Ax ≥ b$ and $x \ge 0$ (canonical form)
and of the form $\min c^T x$ subject to $Ax = b$ and $x \ge 0$ (standard form).

## Overview

The steps in solving linear programs with this module are as follows:
* Create a `Tableau` from the matrix $A$ and the vectors $b$ and $c$.
* Manipulate the `Tableau` using pivoting functions.
* Alternatively, use one of the solving methods:
    * `simplex_solve!`
    * `big_M_solve!`
    * `lp_solve`

# Caveats

* This is a demonstration project that is useful for illustrating the Simplex Method and for solving small linear programs. All arithmetic is exact (using arbitrary precision rational numbers).
* This is somewhat early days for this module. The 0.2.x versions should be consider to be sort-of beta releases.


> **Note**: This is early days for this module. Any version before 0.1.0 is subject to massive changes. 

# SimplexTableaux

This module can be used to show how to solve linear programming problems using 
the Simplex Method by pivoting tableaux. 

This is an illustration project for solving optimization problems of the form 
$\min c^T x$ subject to $Ax ≥ b$ and $x \ge 0$ (canonical form)
and of the form $\min c^T x$ subject to $Ax = b$ and $x \ge 0$ (standard form).


See [the documentation](https://docs.juliahub.com/General/SimplexTableaux/stable/) for information on how to use this module. 

## Caveats

* This is a demonstration project and is not suitable for solving large linear programming (LP) problems. 

* This module is set up for minimization problems only. 

* All data is stored using arbitrary precision integers (that is, `Rational{BigInt}`) which gives exact results, but is much slower than floating point arithmetic. These issues are negligible for small problems. 

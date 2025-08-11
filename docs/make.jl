# execute this file in the docs directory with this
# julia --color=yes --project make.jl

using Documenter, SimplexTableaux
makedocs(;
    pages=[
        "Overview" => "index.md",
        "Creating Tableaux" => "create.md",
        "Bases" => "bases.md",
        "Pivoting Tableaux" => "pivot.md",
        "Solving LPs" => "solve.md",
        "Other Functions" => "other.md",
    ],
    sitename="SimplexTableaux",
)

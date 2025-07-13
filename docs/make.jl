# execute this file in the docs directory with this
# julia --color=yes --project make.jl

using Documenter, SimplexTableaux
makedocs(;
    pages=[
        "Overview" => "index.md",
        "Creating and Solving LPs" => "create.md",
        "Other Functions" => "other.md",
    ],
    sitename="SimplexTableaux",
)

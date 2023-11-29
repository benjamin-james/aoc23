module AoC23

using BenchmarkTools
using Printf

## Skeleton taken from https://github.com/goggle/AdventOfCode2022.jl/blob/master/src/AdventOfCode2022.jl
solvedDays=1
for day in solvedDays
    ds = @sprintf("%02d", day)
    include(joinpath(@__DIR__, "day$ds.jl"))
end

# Read the input from a file:
function readInput(path::String)
    s = open(path, "r") do file
        read(file, String)
    end
    return s
end
function readInput(day::Integer)
    path = joinpath(@__DIR__, "..", "data", @sprintf("day%02d.txt", day))
    return readInput(path)
end
export readInput



# Benchmark a list of different problems:
function benchmark(days = solvedDays)
    results = []
    for day in days
        modSymbol = Symbol(@sprintf("Day%02d", day))
        fSymbol = Symbol(@sprintf("day%02d", day))
        input = readInput(joinpath(@__DIR__, "..", "data", @sprintf("day%02d.txt", day)))
        @eval begin
            bresult = @benchmark(AoC23.$modSymbol.$fSymbol($input))
        end
        push!(results, (day, time(bresult), memory(bresult)))
    end
    return results
end

# Write the benchmark results into a markdown string:
function _to_org_table(bresults)
    header = "| Day | Time | Allocated memory |\n" *
             "|-----|------|------------------|"
    lines = [header]
    for (d, t, m) in bresults
        ds = string(d)
        ts = BenchmarkTools.prettytime(t)
        ms = BenchmarkTools.prettymemory(m)
        push!(lines, "| $ds | $ts | $ms |")
    end
    return join(lines, "\n")
end
end

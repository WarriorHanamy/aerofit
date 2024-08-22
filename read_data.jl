using CSV
using DataFrames
using StatsPlots
# read csv ignore header
df = CSV.read("diffusion.csv", DataFrame, header = false)
# ERROR: Cannot convert DataFrame to series data for plotting

# plot other columns vs first column
using Plots
@df df plot(:Column1, [:Column2], 
            label=["Column2"], 
            xlabel="Alpha", ylabel="Cz")

# set xlim and ylim
# plot!(xlims = (-1, 6), ylims = (0, 1))
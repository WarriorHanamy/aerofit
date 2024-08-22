using DataFrames
using CSV

# Step 1: Read the CSV file into a DataFrame
cd = pwd()
filename = joinpath(cd, "aero-data.csv")
df = CSV.read(filename, DataFrame)

df[:,:pitch] = df[:,:pitch_deg] .* π / 180
df[:, :alpha] = π/2 .- df[:,:pitch]
df[:, :alpha_deg] = 90 .- df[:, :pitch_deg] 
# to INT64
# df[:, :pitch_deg] = INT64.(df[:, :pitch] .* 180 / π)
df[:, :acc] = 9.81 .* sin.(df[:, :pitch])

# df sort by alpha_deg
sort!(df, :alpha_deg)

CSV.write("aero-data.csv", df)
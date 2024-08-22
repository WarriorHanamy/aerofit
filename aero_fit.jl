using CairoMakie
using BSplineKit
# read csv
using CSV
using DataFrames


# get current directory
cd = pwd()
filename = joinpath(cd, "aero-data.csv")
df = CSV.read(filename, DataFrame)



alphas = df[:, :alpha]
# sort from low to high
czs = df[:, :cz]

# # # plot
fig = Figure()
ax = Axis(fig[1, 1], xlabel = "alpha", ylabel = "cz")
scatter!(ax, alphas, czs)
fig

# B = BSplineBasis(BSplineOrder(4), -1:0.1:1)
# interpolate
k = 4
Snat = interpolate(alphas, czs, BSplineOrder(k), Natural())
#get alpha min and max
alpha_min = minimum(alphas)
alpha_max = maximum(alphas)

x_interval = alpha_min..alpha_max

f = Snat
# this could change knots position
ξs = [alpha_min,
      45*π/180,
      50*π/180,
      55*π/180,
      60*π/180,
      65*π/180,
      75*π/180,
      105*π/180,
      130*π/180,
      alpha_max]
# kor is order = degree + 1
kor = 4
B = BSplineBasis(BSplineOrder(kor), ξs)
S_minL2 = approximate(f, B, MinimiseL2Error())
#knots(S_minL2)
#coefficients(S_minL2)

fig = Figure(size = (600, 400))
ax = Axis(fig[1, 1])
data = scatter!(ax,alphas, czs; label = "Data", color = :black)
nat_spl = lines!(x_interval, Snat; label = "k = $k (natural)", linewidth = 1)
S_min_spl = lines!(x_interval, S_minL2; label = "k = $k (original)", linestyle = :dash, linewidth = 2)

# axislegend to left up
Legend(fig[1, 2],
    [data, S_min_spl, nat_spl],
    ["Data", "k = $kor (S_min_spl)", "k = $k (natural)"]
    )
fig

# println("knots")
# println("{", join(knots(S_minL2), ", "), "}")

# # print coefficients with { } to get the coefficients array
# println("coefficients")
# println("{", join(coefficients(S_minL2), ", "), "}")
# println("[", join(coefficients(S_minL2), ", "), "]")
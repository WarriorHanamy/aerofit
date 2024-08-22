using CairoMakie
using BSplineKit
# read csv
using CSV
using DataFrames


# get current directory
cd = pwd()
filename = joinpath(cd, "sim-cz_vs_alpha.csv")
df = CSV.read(filename, DataFrame)

function plot_knots!(ax, ts; ybase = 0, knot_offset = 0.03, kws...)
  ys = zero(ts) .+ ybase
  # Add offset to distinguish knots with multiplicity > 1
  if knot_offset !== nothing
      for i in eachindex(ts)[(begin + 1):end]
          if ts[i] == ts[i - 1]
              ys[i] = ys[i - 1] + knot_offset
          end
      end
  end
  scatter!(ax, ts, ys; marker = '×', color = :gray, markersize = 24, kws...)
  ax
end

alphas = df[:, :alpha]
# sort from low to high
czs = df[:, :cz] / 1.5

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
      25*pi/180,
      35*π/180,
      45*π/180,
      55*π/180,
      75*π/180,
      135*π/180,
      150*π/180,
      alpha_max]
# kor is order = degree + 1
kor = 4
B = BSplineBasis(BSplineOrder(kor), ξs)
S_minL2 = approximate(f, B, MinimiseL2Error())
#knots(S_minL2)
#coefficients(S_minL2)

fig = Figure(size = (1000, 800))
# plot ax with more fine grainy
ax = Axis(fig[1, 1])


# data point is small
data = scatter!(ax,alphas, czs; label = "Data", color = :black, markersize = 5)
nat_spl = lines!(x_interval, Snat; label = "k = $k (natural)", linewidth = 1)
S_min_spl = lines!(x_interval, S_minL2; label = "k = $k (original)", linestyle = :dash, linewidth = 2)
# plot_knots!(ax, ξs; ybase = 0.2, knot_offset = 0.03, label = "knots")
# axislegend to left up
Legend(fig[1, 2],
    [data, S_min_spl, nat_spl],
    ["Data", "k = $kor (S_min_spl)", "k = $k (natural)"]
    )
fig
# print(knots(S_minL2))
# print knots with \{ \} to get the knots array


println("knots")
println("{", join(knots(S_minL2), ", "), "}")

# print coefficients with { } to get the coefficients array
println("coefficients")
println("{", join(coefficients(S_minL2), ", "), "}")


println("coefficients_p")
println("[", join(coefficients(S_minL2), ", "), "]")
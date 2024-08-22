using LinearAlgebra

module FitData
    global w    = 1.0
    global a0   = -11.8
    global a1   = -1.099
    global b1   = 22.35
    global a2   = 13.05
    global b2   = 1.314
    global a3   = 0.788
    global b3   = -5.099
    global a4   = -1.015
    global b4   = -0.2115
    global kPho = 1.225
    global kS   = 0.25
    global mass = 1.132
end



function get_cz_from_vb(vb::Vector{Float64})
    v = norm(vb)
    
    if v < 0.5
        return 0.24
    end
    
    alpha = atan(vb[1], vb[3])
    
    if alpha < 0.0
        return 0.0
    else
        if !isdefined(FitData, :initialized) || !FitData.initialized
            FitData.init()
            global FitData.initialized = true
        end
        
        # Fourier series about alpha
        cz = FitData.a0 + FitData.a1 * cos(FitData.w * alpha) + FitData.b1 * sin(FitData.w * alpha) +
             FitData.a2 * cos(2 * FitData.w * alpha) + FitData.b2 * sin(2 * FitData.w * alpha) +
             FitData.a3 * cos(3 * FitData.w * alpha) + FitData.b3 * sin(3 * FitData.w * alpha) +
             FitData.a4 * cos(4 * FitData.w * alpha) + FitData.b4 * sin(4 * FitData.w * alpha)

        # Factor using rho and area
        return 0.5 * FitData.kPho * FitData.kS * cz / FitData.mass
    end
end

function get_cz_from_alpha(alpha::Float64)    
    # Fourier series about alpha
    cz = FitData.a0 + FitData.a1 * cos(FitData.w * alpha) + FitData.b1 * sin(FitData.w * alpha) +
         FitData.a2 * cos(2 * FitData.w * alpha) + FitData.b2 * sin(2 * FitData.w * alpha) +
         FitData.a3 * cos(3 * FitData.w * alpha) + FitData.b3 * sin(3 * FitData.w * alpha) +
         FitData.a4 * cos(4 * FitData.w * alpha) + FitData.b4 * sin(4 * FitData.w * alpha)

    # Factor using rho and area
    return 0.5 * FitData.kPho * FitData.kS * cz / FitData.mass
end

# # plot from 0 to 120deg  using get_cz_from_alpha
using Plots
alpha = range(0, stop=pi * 2/3, length=100)

plot(alpha, get_cz_from_alpha.(alpha), label="Cz vs alpha", xlabel="alpha", ylabel="Cz", title="Cz vs alpha")


# using df to save the data
using DataFrames
using CSV
df = DataFrame(alpha=alpha, cz=get_cz_from_alpha.(alpha))
# create third column alpha in degrees
df.alpha_deg = df.alpha * 180 / pi

# add more rows, alpha 120 to 180, the cooresponding cz is using pi - alpha
append!(df, DataFrame(alpha=pi .- alpha, cz=get_cz_from_alpha.(pi .- alpha), alpha_deg=(pi .- alpha) * 180 / pi))
scatter(df.alpha_deg, df.cz, label="Cz vs alpha", xlabel="alpha", ylabel="Cz", title="Cz vs alpha")

# sort df according to alpha_deg 
sort!(df, :alpha_deg)
CSV.write("sim-cz_vs_alpha.csv", df)
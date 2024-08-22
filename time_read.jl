using CSV
using DataFrames
using Plots
using Statistics
# ignore header
df = CSV.read("time_record.csv", DataFrame, header = false)

# df.describe()
time = df[:,1]
histogram(time)

xlabel!("Time (ms)")
ylabel!("Frequency")


describe(df, :mean, :min, :max)

using TOML
data = """
[database]
server = "192.168.1.1"
ports = [ 8001, 8001, 8002 ]
""";

TOML.parse(data)
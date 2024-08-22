using PrettyTables
data = Any[f(a) for a = 0:30:90, f in (sind, cosd, tand)]

formatter = (v, i, j) -> round(v, digits = 3)
pretty_table(data; alignment=:l,backend = Val(:latex))
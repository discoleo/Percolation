

###############
### Geo-Physics

mod = function(K, ...) {
	UseMethod("mod");
}

### Bulk Modulus
mod.bulk = function(phi, K) {
	# Gassman's eq:
	# Ksat/(Kmin - Ksat) = Kdry/(Kmin - Kdry) + Kfl/(phi*(Kmin - Kfl))
	# (K[mineral], K[dry], K[fluid])
	if(length(K) < 3) {
		# Kfl: use Batzle & Wang's eqs;
	}
	dK = (K[1] - K[2:3]);
	Ks = K[2]/dK[2] + K[3]/(dK[3] * phi);
	Ksat = K[1] * Ks / (Ks + 1);
	return(Ksat);
}
mod.dry.bulk = function(phi, K) {
	# Kdry = (Ksat*(phi*Kmin/Kfl + 1 - phi) - Kmin) /
	#        (phi*Kmin/Kfl + Ksat/Kmin - 1 - phi);
	# Ksat[initial] = rho * (vp^2 - 4/3*vs^2);
}
mod.fluid.bulk = function(K, p) {
	# mixture of oil/fluids: p = proportion;
	if(length(K) - length(p) == 1) p = c(p, 1 - sum(p));
	1 / sum(p/K);
}
mod.min.bulk = function(type=c("quartz", "calcite", "dolomite", "muscovite",
		"feldspar", "albite", "halite", "anhydrite", "pyrite", "siderite")) {
	if(missing(type)) stop("Mineral name needed!")
	type = pmatch(type, formals(mod.min.bulk)$type[-1]);
	if(is.na(type)) stop("Mineral name not yet available!")
	
	K = c(36.6, 76.8, 94.9, 61.5, 75.6, 59.5, # albite: simulated 55;
		24.8, 56.1, 147.4, 123.7)
	return(K[type]);
	# albite:
	# https://www.ceramics-silikaty.cz/2015/pdf/2015_04_326.pdf
}


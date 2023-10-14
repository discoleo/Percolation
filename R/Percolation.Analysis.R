########################
###
### Leonard Mada
### [the one and only]
###
### Percolation
### Analysis
###
### draft v.0.4d


#############################
### Percolation Functions ###
#############################

### REV = Representative Elementary Volume
REV = function(m, w, h=w, base=0) {
	isPore = (m >= base);
	msc = apply(isPore, 1, cumsum);
	#
	r = matrix(0, nrow=nrow(m) - h , ncol=ncol(m) - w)
	for(nc in seq(ncol(m) - w)) {
		for(nr in seq(nrow(m) - h)) {
			r[nr, nc] = sum(msc[nr + h, seq(nc, nc+w-1)]) +
				- sum(msc[nr, seq(nc, nc+w-1)]);
		}
	}
	return(r);
}

### Percolating Channels

flood = function(m, pyx, val=1, val0=0) {
	vals = pyx; pos = 1;
	
	while(TRUE) {
		if(pos > length(vals)) return(m);
		if(m[vals[pos], vals[pos + 1]] != val0) {pos = pos + 2; next;}
		m[vals[pos], vals[pos + 1]] = val;
		if(vals[pos] > 1) vals = c(vals, vals[pos]-1, vals[pos + 1]);
		if(vals[pos] < nrow(m)) vals = c(vals, vals[pos]+1, vals[pos + 1]);
		if(vals[pos+1] > 1) vals = c(vals, vals[pos], vals[pos + 1] - 1);
		if(vals[pos+1] < ncol(m)) vals = c(vals, vals[pos], vals[pos + 1] + 1);
		pos = pos + 2;
	}
	invisible(m);
}

flood.all = function(m, type="Col1", val0=0, id.start, debug=TRUE) {
	type = match(type, c("Col1", "All"))
	if(is.na(type)) stop("Type NOT supported!")
	ncols = if(type == 2) seq(ncol(m)) else 1;
	
	if(missing(id.start)) {
		it = 1 + if(type == 2) max(m) else max(m[,1]);
	} else it = id.start;
	for(nc in ncols) {
		if(debug) print("Iteration: ");
		while(TRUE) {
			id.row = match(val0, m[,nc]);
			if(is.na(id.row)) break;
			if(debug) { cat(it); cat(", "); it = it + 1;}
			m = flood(m, c(id.row, nc), max(m)+1)
		}
		if(debug) cat("\n");
	}
	class(m) = c(class(m), if(type == 1) "filled" else "filledAll");
	invisible(m)
}

### Path Length
length.path = function(m, id, debug=TRUE) {
	if(missing(id)) {
		id = max.id(m);
		if(debug) print(id);
	}
	p.m = m;
	p.m[p.m != id] = -1;
	p.m[p.m == id] =  0;
	# TODO
	lvl = 1; pos = 1;
	# rep(c(y, x))
	vals = as.vector(rbind(seq(nrow(m)), 1));
	while(pos <= length(vals)) {
		nn = integer();
		while(pos <= length(vals)) {
			if(p.m[vals[pos], vals[pos + 1]] != 0) {pos = pos + 2; next;}
			p.m[vals[pos], vals[pos + 1]] = lvl;
			if(vals[pos] > 1) nn = c(nn, vals[pos]-1, vals[pos + 1]);
			if(vals[pos] < nrow(m)) nn = c(nn, vals[pos]+1, vals[pos + 1]);
			if(vals[pos+1] > 1) nn = c(nn, vals[pos], vals[pos + 1] - 1);
			if(vals[pos+1] < ncol(m)) nn = c(nn, vals[pos], vals[pos + 1] + 1);
			pos = pos + 2;
		}
		vals = nn;
		lvl = lvl + 1; pos = 1;
	}
	
	if(id != 0) p.m[m == 0] =  0;
	p.m[p.m < 0 & m > 0] =  0; # other non-connected "paths";
	return(p.m);
}
### Contact Area
contact.area = function(m, id) {
	area = 0;
	for(nc in 1:ncol(m)) {
		for(nr in 1:nrow(m)) {
			if(m[nr, nc] != id) next;
			if(nr > 1 && m[nr-1,nc] != id) area = area + 1;
			if(nr < nrow(m) && m[nr+1,nc] != id) area = area + 1;
			if(nc > 1 && m[nr,nc-1] != id) area = area + 1;
			if(nc < ncol(m) && m[nr,nc+1] != id) area = area + 1;
		}
	}
	return(area);
}
### Height
height.m = function(m) {
	ids = unique(as.vector(m));
	ids = ids[ids > 0];
	hm = array(as.integer(0), c(length(ids), 2, ncol(m)));
	
	for(nc in seq(ncol(m))) {
		for(nr in seq(nrow(m))) {
			val = m[nr, nc];
			val.id = match(val, ids);
			if(val <= 0) next;
			if(hm[val.id, 1, nc] == 0) {
				hm[val.id, 1, nc] = nr;
				hm[val.id, 2, nc] = nr;
			} else {
				hm[val.id, 2, nc] = nr;
			}
		}
	}
	invisible(hm);
}

### Count Area
count.fill = function(m, debug=TRUE) {
	isNotFilled = is.na(match("filledAll", class(m)))
	if(isNotFilled) m = flood.all(m, type="All");
	#
	count = table(m);
	ids   = as.integer(names(count));
	count = count[ids > 0];
	ids   = ids[ids > 0];
	if(debug) print(head(count), 20)
	# replace id with count:
	cn.m = m;
	for(id in seq(length(ids))) {
		cn.m[m == ids[id]] = count[id];
	}
	invisible(cn.m)
}

### Diffusion
# - simple diffusion;
diffusion = function(m, id, val0 = 1.0, debug=TRUE) {
	if(missing(id)) {
		id = max.id(m)
		if(debug) print(id);
	}
	#
	y.start = which(m[,1] %in% id)
	if(length(y.start) == 0) stop("NO such path!")
	vals = as.vector(rbind(y.start, 1, val0))
	# Init
	p.m = m;
	p.m[p.m != id] = -1;
	p.m[p.m == id] =  0;
	#
	p.m = diffusion.internal(p.m, vals)
	
	if(id != 0) p.m[m == 0] =  0;
	p.m[p.m < 0 & m > 0] =  0; # other non-connected "paths";
	invisible(p.m);
}
diffusion.internal = function(p.m, vals) {
	pos = 1;
	# TODO: mixing of flows!
	while(pos <= length(vals)) {
		nn = double();
		while(pos <= length(vals)) {
			if(p.m[vals[pos], vals[pos + 1]] != 0) {pos = pos + 3; next;}
			p.m[vals[pos], vals[pos + 1]] = vals[pos + 2];
			fflow = 0;
			if(vals[pos] > 1 && p.m[vals[pos]-1, vals[pos + 1]] == 0) {
				nn = c(nn, vals[pos]-1, vals[pos + 1], 0);
				fflow = fflow + 1; }
			if(vals[pos] < nrow(m) && p.m[vals[pos]+1, vals[pos + 1]] == 0) {
				nn = c(nn, vals[pos]+1, vals[pos + 1], 0);
				fflow = fflow + 1; }
			if(vals[pos+1] > 1 && p.m[vals[pos], vals[pos + 1] - 1] == 0) {
				nn = c(nn, vals[pos], vals[pos + 1] - 1, 0);
				fflow = fflow + 1; }
			if(vals[pos+1] < ncol(m) && p.m[vals[pos], vals[pos + 1] + 1] == 0) {
				nn = c(nn, vals[pos], vals[pos + 1] + 1, 0);
				fflow = fflow + 1;
			}
			if(fflow == 0) {pos = pos + 3; next; }
			n.len = length(nn);
			nn[n.len - seq(0, fflow-1)*3] = vals[pos + 2] / fflow;
			pos = pos + 3;
		}
		vals = nn;
		pos = 1;
	}
	invisible(p.m);
}
### Dynamic diffusion [old]
diffusion.dynamic.slow = function(m, id, iter=5, val0 = 1.0, max.size.scale=3, debug=TRUE) {
	if(missing(id)) {
		id = max.id(m)
		if(debug) print(id);
	}
	#
	y.start = which(m[,1] %in% id)
	if(length(y.start) == 0) stop("NO such path!")
	vals = as.vector(rbind(y.start, 1, val0))
	# Init
	p.m = m;
	p.m[p.m != id] = -1;
	p.m[p.m == id] =  0;
	# pre-compute Diffusion
	# - better results, but still extremely slow!
	p.m = diffusion.internal(p.m, vals);
	# next iterations
	vals = as.vector(rbind(y.start, 1, 0)); # 0 vs val0?
	pos = 1; tol = 1E-24;
	for(itN in seq(iter)) {
	while(pos <= length(vals)) {
		nn = double();
		while(pos <= length(vals)) {
			if(p.m[vals[pos], vals[pos + 1]] < 0) {pos = pos + 3; next;}
			# update Value
			valNew = p.m[vals[pos], vals[pos + 1]];
			valNew = valNew + vals[pos + 2];
			p.m[vals[pos], vals[pos + 1]] = valNew;
			cflow = 0; fflow = 0; # only push-forward Flow;
			nnew = double();
			if(vals[pos+1] < ncol(m) && p.m[vals[pos], vals[pos + 1] + 1] >= 0) {
				valC = p.m[vals[pos], vals[pos + 1] + 1];
				if(valNew > valC + tol) {
					nnew = c(nnew, vals[pos], vals[pos + 1] + 1, valC);
					cflow = cflow + 1;
					fflow = fflow + valC;
				} }
			if(vals[pos] < nrow(m) && p.m[vals[pos]+1, vals[pos + 1]] >= 0) {
				valC = p.m[vals[pos]+1, vals[pos + 1]];
				if(valNew > valC + tol) {
					nnew = c(nnew, vals[pos]+1, vals[pos + 1], valC);
					cflow = cflow + 1;
					fflow = fflow + valC;
				} }
			if(vals[pos+1] > 1 && p.m[vals[pos], vals[pos + 1] - 1] >= 0) {
				valC = p.m[vals[pos], vals[pos + 1] - 1];
				if(valNew > valC + tol) {
					nnew = c(nnew, vals[pos], vals[pos + 1] - 1, valC);
					cflow = cflow + 1;
					fflow = fflow + valC;
				} }
			if(vals[pos] > 1 && p.m[vals[pos]-1, vals[pos + 1]] >= 0) {
				valC = p.m[vals[pos]-1, vals[pos + 1]];
				if(valNew > valC + tol) {
					nnew = c(nnew, vals[pos]-1, vals[pos + 1], valC);
					cflow = cflow + 1;
					fflow = fflow + valC;
				}
			}
			if(cflow == 0) {pos = pos + 3; next; }
			# Update
			valNew = (valNew + fflow) / (cflow + 1);
			n.len = length(nnew); idNext = n.len - seq(0, cflow-1)*3;
			# Priority: lower initial value;
			n.id = order(nnew[idNext]);
			idSorted = idNext[n.id];
			nnew = nnew[rbind(idSorted-2, idSorted-1, idSorted)];
			# Propagate Update immediately
			p.m[vals[pos], vals[pos + 1]] = valNew;
			for(idN1 in idNext) {
				p.m[nnew[idN1 - 2], nnew[idN1 - 1]] = valNew;
			}
			nnew[idNext] = 0;
			nn = c(nn, nnew);
			pos = pos + 3;
			if(length(nn) > max.size.scale * prod(dim(m))) {
				print("Internal Break!")
				break;
			}
		}
		vals = nn;
		pos = 1;
	}
		if(debug) print(paste0("Iteration: ", itN));
		# TODO: evaluate NO new flow vs new flow;
		vals = as.vector(rbind(y.start, 1, 0));
		pos = 1;
	}
	
	if(id != 0) p.m[m == 0] =  0;
	p.m[p.m < 0 & m > 0] =  0; # other non-connected "paths";
	return(p.m);
}

### Dynamic diffusion:
# - new Sequential Algorithm;
diffusion.dynamic = function(m, id, iter=40, val0 = 1.0, debug=TRUE) {
	if(missing(id)) {
		id = max.id(m)
		if(debug) print(id);
	}
	#
	y.start = which(m[,1] %in% id)
	if(length(y.start) == 0) stop("NO such path!")
	# Init
	p.m = m;
	p.m[m != id] = -1;
	p.m[m == id] =  0;
	p.m[y.start, 1] = val0; # start of flow;
	tol = 1E-24;
	#
	for(itN in seq(iter)) {
		for(nc in seq(ncol(m))) {
		for(nr in seq(nrow(m))) {
			if(p.m[nr, nc] <= 0) next;
			valNew = p.m[nr, nc];
			nn = double();
			cflow = 0; fflow = 0;
			if(nc < ncol(m) && p.m[nr, nc + 1] >= 0) {
				valC = p.m[nr, nc + 1];
				if(valNew > valC + tol) {
					nn = c(nn, nr, nc + 1);
					cflow = cflow + 1;
					fflow = fflow + valC;
				} }
			if(nr < nrow(m) && p.m[nr + 1, nc] >= 0) {
				valC = p.m[nr + 1, nc];
				if(valNew > valC + tol) {
					nn = c(nn, nr + 1, nc);
					cflow = cflow + 1;
					fflow = fflow + valC;
				} }
			if(nc > 1 && p.m[nr, nc - 1] >= 0) {
				valC = p.m[nr, nc - 1];
				if(valNew > valC + tol) {
					nn = c(nn, nr, nc - 1);
					cflow = cflow + 1;
					fflow = fflow + valC;
				} }
			if(nr > 1 && p.m[nr - 1, nc] >= 0) {
				valC = p.m[nr - 1, nc];
				if(valNew > valC + tol) {
					nn = c(nn, nr - 1, nc);
					cflow = cflow + 1;
					fflow = fflow + valC;
				}
			}
			if(cflow == 0) next;
			# Update
			valNew = (valNew + fflow) / (cflow + 1);
			p.m[nr, nc] = valNew;
			n.len = length(nn); idNext = n.len - seq(0, cflow-1)*2;
			for(idNext in (n.len - seq(0, cflow-1)*2)) {
				p.m[nn[idNext - 1], nn[idNext]] = valNew;
			}
		}
		}
		if(debug) print(paste0("Iteration: ", itN))
		# add new flow;
		p.m[y.start, 1] = p.m[y.start, 1] + val0;
	}
	
	if(id != 0) p.m[m == 0] =  0;
	p.m[p.m < 0 & m > 0] =  0; # other non-connected "paths";
	return(p.m);
}

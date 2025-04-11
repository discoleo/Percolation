##########################
#
# Maintainer: Leonard Mada
#
# Student: Adrian Ivan
# Candidate BSc CS 2023
# West University, Timisoara
#
# Supervisors:
# Prof. Dr. Daniela Zaharie
# Dr. med. Leonard Mada (Syonic SRL)

### GitHub:
# https://github.com/discoleo/Percolation
# [old] https://github.com/adrian0010/Percolation

# Based on Previous Projects (2020-2022)

### Server

server = function(input, output, session) {
	output$txtTitleSimple = renderText("Percolation: Uniform Random Lattice")
	output$txtTitleLinear = renderText("Percolation: Linear Channels")
	output$txtTitleDetails = renderText("Detailed Analysis & Visualization")
	output$txtTitleLinearCorrelated = renderText("Percolation: Linearly Correlated Process")
	output$txtTitleBinaryCorrelated = renderText("Percolation: Binary Correlated Process")
	output$txtTitleLinearLevels = renderText("Channel Levels")
	output$txtTitleHelp = renderText("Help")
	
	### Grid Data
	values = reactiveValues();
	values$mSimple = NULL; # Material/Grid
	values$rSimple = NULL; # Flooded Material
	values$mLinear = NULL;
	values$rLinear = NULL;
	values$mLinearCorrelated = NULL;
	values$rLinearCorrelated = NULL;
	values$mBinaryCorrelated = NULL;
	values$rBinaryCorrelated = NULL;
	# Options
	values$opt = list(
		splitH = 120,
		splitHCh  = 150,
		Channel.H = 3,
		BinaryCorr.CF = FALSE, # as old code;
		NULL );
	
	
	### Grid/Material Generators
	
	### Simple
	imageGeneratorSimple = reactive({
		input$newSimple;
		m = rgrid.unif(c(input$heightSimple, input$widthSimple));
		values$mSimple = m;
	})
	
	imageGeneratorLinear = reactive({
		input$newLinear;
		m = rgrid.channel.poisson(input$heightLinear /3, input$widthLinear, 
			d = 1, type = input$blockTypeLinear, ppore = input$probPoreLinear, pBlock = input$probBlockLinear, val = 1.1);
		values$mLinear = m;
	})

	imageGeneratorLinearCorrelated = reactive({
		input$newLinearCorrelated;
		dim = c(input$heightLinearCorrelated, input$widthLinearCorrelated);
		m = rgrid.unifCor(dim,
			pChange = input$pChangeLinearCorrelated, type = input$typeLinearCorrelated);
		values$mLinearCorrelated = m;
	})

	imageGeneratorBinaryCorrelated = reactive({
		input$newBinaryCorrelated;
		dim = c(input$heightBinaryCorrelated, input$widthBinaryCorrelated);
		m = rgrid.correlPersist(dim,
			pChange = input$pChangeBinaryCorrelated,
			type = input$typeBinaryCorrelated);
		values$mBinaryCorrelated = m;
	})
	# [old]
	# imageGeneratorBinaryCorrelated = reactive({
	#	input$newBinaryCorrelated;
	#	dim = c(input$heightBinaryCorrelated, input$widthBinaryCorrelated);
	#	col1 = runif(dim[1]);
	#	m = rgrid.correl(dim,
	#		pChange = input$pChangeBinaryCorrelated,
	#		type = input$typeBinaryCorrelated);
	#	values$mBinaryCorrelated = list(r = col1, mTransitions = m);
	# })
	
	### Flood Fill
	
	### Basic Model
	floodSimple = reactive({
		imageGeneratorSimple();
		m = values$mSimple;
		p = input$probSimple;
		m = as.grid(m, p);
		r = flood.all(m);
		values$rSimple = r;
	})
	output$PercolationSimple = renderPlot({
		floodSimple();
		r = values$rSimple;
		if(nrow(values$mSimple) > values$opt$splitH) r = split.rs(r);
		plot.rs(r);
	})
	
	### Linearly-Correlated Process
	floodLinearCorrelated = reactive({
		imageGeneratorLinearCorrelated()
		m = values$mLinearCorrelated;
		p = input$probLinearCorrelated;
		m = as.grid(m, p);
		r = flood.all(m);
		values$rLinearCorrelated = r;
	})
	output$LinearCorrelated = renderPlot({
		floodLinearCorrelated();
		r = values$rLinearCorrelated;
		if(nrow(values$mLinearCorrelated) > values$opt$splitH) r = split.rs(r);
		plot.rs(r);
	})

	### Binary Correlated Process
	floodBinaryCorrelated = reactive({
		imageGeneratorBinaryCorrelated();
		m = values$mBinaryCorrelated;
		p = input$probBinaryCorrelated;
		m = as.grid.persMatrixInv(m, p, asOld = values$opt$BinaryCorr.CF);
		r = flood.all(m);
		values$rBinaryCorrelated = r;
	})
	output$BinaryCorrelated = renderPlot({
		floodBinaryCorrelated();
		r = values$rBinaryCorrelated;
		if(nrow(r) > values$opt$splitH) r = split.rs(r);
		plot.rs(r);
	})

	### Analyse
	
	### Statistics: Simple
	observe({
		m = values$rSimple;
		if(is.null(m)){
			return();
		}
		# Flood from Right
		m = flood.rev(m);
		#
		statChannels = analyse.Channels(m);
		statAreas = analyse.Area(m);
		output$StatisticsSimple = renderTable(statChannels);
		output$AreaSimple = renderTable(statAreas);
	})
	

	### Details
	
	# Update list of Percolating Channels
	observe({
		model = input$modelDetails;
		if(model == "Simple Model") {
			r = values$rSimple
		} else if (model == "Linearly Correlated") {
			r = values$rLinearCorrelated;
		} else {
			r = values$rBinaryCorrelated;
		}
		if(is.null(r)){
			return()
		}
		ids = which.percolates.orAny(r)
		updateSelectInput(session, "idDetails",
			choices  = ids,
			selected = head(ids, 1)
    	)
	})

	output$plotDetails = renderPlot({
		model = input$modelDetails;
		if(model == "Simple Model") {
			r = values$rSimple
		} else if (model == "Linearly Correlated") {
		   r = values$rLinearCorrelated
		} else {
		   r = values$rBinaryCorrelated
		}
		
		if(is.null(r)){
			return();
		}
		id = input$idDetails;
		doSplit = nrow(r) > values$opt$splitH;
		if(input$typeDetails == "Channel Length") {
			r = length.path(r, id);
			if(doSplit) r = split.rs(r);
			plot.rs(r);
		} else if(input$typeDetails == "Border") {
			plot.surface(r, id, split = doSplit);
		} else if(input$typeDetails == "Center") {
			cp = center.percol(r, id);
			p  = points.percol(round(cp), r, split = doSplit);
			plot.rs(p);
		}
		else {
			plot.minCut(r, id, split = doSplit);
		}
	})


	### Linear Channels
	output$channelsLinear = renderPlot({
		imageGeneratorLinear()
		m = values$mLinear;
		p = input$probLinear;
		m = as.grid(m, p);
		r = flood.all(m);
		values$rLinear = r;
		# Plot:
		r = expand.channel(r, values$opt$Channel.H);
		if(nrow(r) > values$opt$splitHCh) r = split.rs(r);
		plot.rs(r);
	})
	
	output$StatisticsLinear = renderTable({
		if(is.null(values$rLinear)){
			return();
		}
		statChannels = analyse.Channels(values$rLinear);
	})

	output$AreaLinear = renderTable({
		if(is.null(values$rLinear)){
			return();
		}
		areas = analyse.Area(values$rLinear);
	})
	
	### Stats: Linearly-Correlated
	observe({
		m = values$rLinearCorrelated;
		if(is.null(m)){
			return();
		}
		# Flood from Right
		m = flood.rev(m);
		#
		statChannels = analyse.Channels(m);
		statAreas = analyse.Area(m);
		output$StatisticsLinearCorrelated = renderTable(statChannels);
		output$AreaLinearCorrelated = renderTable(statAreas);
	})
	
	### Stats: Binary-Correlated
	observe({
		m = values$rBinaryCorrelated;
		if(is.null(m)){
			return();
		}
		# Flood from Right
		m = flood.rev(m);
		#
		statChannels = analyse.Channels(m);
		statAreas = analyse.Area(m);
		output$StatisticsBinaryCorrelated = renderTable(statChannels);
		output$AreaBinaryCorrelated = renderTable(statAreas);
	})
	
	
	### Stats: Channel Length
	output$LengthLinear = renderTable({
		r = values$rLinear;
		if(is.null(r)) {
			return();
		}
		length = length.channel.linear(r);
		length = merge(length, as.df.id(which.channels(r)), by = "id");
		length = tapply(length$Len, length$Group, function(x) {
			# Stats:
			data.frame(Length = mean(x), Median = median(x));
		});
		length = lapply(names(length), function(nm) {
			tmp = length[[nm]];
			tmp$Group = nm;
			return(tmp);
		});
		length = do.call(rbind, length);
		length = length[c("Group", "Length", "Median")];
		return(length);
	})

	### Channel Levels

	output$LinearLevels = renderPlot({
		if(is.null(values$rLinear)){
			return()
		}
		m = values$rLinear;
		m = height.channel.all(m)
		m[m > 1] = m[m > 1] + 2;
		r = expand.channel(m, values$opt$Channel.H);
		if(nrow(r) > values$opt$splitHCh) r = split.rs(r);
		plot.rs(r);
	})
	
	# <----- END CHANNELS ----->
	
	
	### Shuffle Colours
	
	observeEvent(input$shuffleSimple, {
		values$rSimple = shuffle.colors(values$rSimple);
	})
	observeEvent(input$shuffleLinearCorrelated, {
		values$rLinearCorrelated = shuffle.colors(values$rLinearCorrelated);
	})
	observeEvent(input$shuffleBinaryCorrelated, {
		values$rBinaryCorrelated = shuffle.colors(values$rBinaryCorrelated);
	})

	### Help

	idHelp = reactiveVal("Help1")
	output$HelpUI = renderUI({
		helper (id = idHelp())
	})
	checkHelp = function(tag){
		if (idHelp() == tag){
			idHelp("Help0")
		}
		else {
		   idHelp(tag);
		}
	}
	observeEvent(input$Help1, {
		checkHelp("Help1")
	})
	observeEvent(input$Help2, {
		checkHelp("Help2");
	})
	observeEvent(input$Help3, {
		checkHelp("Help3");
	})
	observeEvent(input$Help4, {
		checkHelp("Help4");
	})
	observeEvent(input$Help5, {
		checkHelp("Help5");
	})
}


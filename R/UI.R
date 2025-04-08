# Student: Adrian Ivan
# Candidate BSc CS 2023
# West University, Timisoara

# Supervisors:
# Prof. Dr. Daniela Zaharie
# Dr. med. Leonard Mada (Syonic SRL)

# URL: https://github.com/adrian0010/Percolation

# Based on Previous Projects (2020-2022)

source("Percolation.HelpUI.R")

height.min = 100;
height.max = 600;
width.max  = 200;
### Strings:
lblNew = "New Material";
strModelTypes    = c("Simple Model", "Linearly Correlated", "Binary Correlated");
strAnalysisTypes = c(
	"Channel Length" = "Channel Length",
	"Border" = "Border",
	"MinCut" = "MinCut", "Center" = "Center");


ui = fluidPage("Simulation of diffusion processes", shinyjs::useShinyjs(),
	tabsetPanel(
		### Material: Simple
		tabPanel("Percolation Process",
			fluidRow(
				column(4, textOutput("txtTitleSimple")) ),
			fluidRow(
				column(8, plotOutput("PercolationSimple")),
				column(4,
					column(12, fluidRow(tableOutput("Statistics"))),
					column(12, fluidRow(tableOutput("Area"))),
				)
			),
			fluidRow(
				column(4,
					sliderInput(inputId = "heightSimple", label = "Height",
						value = 100, min = height.min, max = height.max, step = 50)
				),
				column(4,
					sliderInput(inputId = "probSimple", label = "Probability Cutoff",
						value = 0.5, min = 0, max = 1, step = 0.01)
				)
			),
			fluidRow(
				column(4,
					sliderInput(inputId = "widthSimple", label = "Width", 
						value = 50, min = 20, max = width.max, step = 10))
			),
			fluidRow(
				column(4,
					actionButton("newSimple", lblNew) )
			)
		),
		### Material: Linearly-Correlated
		tabPanel("Linearly Correlated Process",
			fluidRow(
				column(4, textOutput("txtTitleLinearCorrelated"))),
			fluidRow(
				column(8, plotOutput("LinearCorrelated")),
				column(4,
					column(12, fluidRow(tableOutput("StatisticsLinearCorrelated"))),
					column(12, fluidRow(tableOutput("AreaLinearCorrelated"))),
				)
			),
			fluidRow(
				column(4,
					sliderInput(inputId = "heightLinearCorrelated",
						label = "Height",
						value = 100, min = height.min, max = height.max, step = 20)
				),
				column(4,
					sliderInput(inputId = "pChangeLinearCorrelated",
						label = "Probability of Column Change",
						value = 0.5, min = 0, max = 1, step = 0.01)
				),
				column(4,
					sliderInput(inputId = "probLinearCorrelated",
						label = "Probability Cutoff",
						value = 0.5, min = 0, max = 1, step = 0.01)
				)
			),
			fluidRow(
				column(4,
					sliderInput(inputId = "widthLinearCorrelated", label = "Width",
						value = 50, min = 20, max = width.max, step = 10)
				),
				column(4,
					selectInput(inputId = "typeLinearCorrelated", label = "Type",
					c("Constant"  = "Constant",
					  "Bernoulli" = "Bernoulli"))
				)
			),
			fluidRow(
				column(4,
					actionButton("newLinearCorrelated", lblNew) )
			)
		),
		### Material: Binary-Correlated
		tabPanel("Binary Correlated Process",
			fluidRow(
				column(4, textOutput("txtTitleBinaryCorrelated"))),
			fluidRow(
				column(8, plotOutput("BinaryCorrelated")),
				column(4,
					column(12, fluidRow(tableOutput("StatisticsBinaryCorrelated"))),
					column(12, fluidRow(tableOutput("AreaBinaryCorrelated"))),
					column(12,
						tag("b", "Warning: "), "Behaves non-uniformly!",
						"Lowering the probability of Column Change
						may aid percolation.")
				)
			),
			fluidRow(
				column(4,
					sliderInput(inputId = "heightBinaryCorrelated",
						label = "Height",
						value = 100, min = height.min, max = height.max, step = 20)
				),
				column(4,
					sliderInput(inputId = "pChangeBinaryCorrelated",
						label = "Probability of Column Change",
						value = 0.5, min = 0, max = 1, step = 0.01)
				),
				column(4,
					sliderInput(inputId = "probBinaryCorrelated",
						label = "Probability Cutoff",
						value = 0.5, min = 0, max = 1, step = 0.01)
				)
			),
			fluidRow(
				column(4,
					sliderInput(inputId = "widthBinaryCorrelated", label = "Width",
						value = 50, min = 20, max = width.max, step = 10)
				),
				column(4,
					selectInput(inputId = "typeBinaryCorrelated", label = "Type",
					c("Constant"  = "Constant",
					  "Bernoulli" = "Bernoulli"))
				)
			),
			fluidRow(
				column(4,
					actionButton("newBinaryCorrelated", lblNew) )
			)
		),
		### Stats: Details
		tabPanel("Details",
			fluidRow(column(4, textOutput("txtTitleDetails"))),
			fluidRow(
				column(4,
					selectInput(inputId = "modelDetails",
						label = "Model type", strModelTypes) ),
				column(4,
					selectInput(inputId = "typeDetails",
						label = "Analysis Type", strAnalysisTypes) ),
				column(4,
					selectInput(inputId = "idDetails", label = "Channel ID", 1) ),
			),
			fluidRow(
				column(8, plotOutput("plotDetails"))
			)
		),
		### Material: Linear Channels
		tabPanel("Linear Channels",
			fluidRow(
				column(4, textOutput("txtTitleLinear"))),
			fluidRow(
				column(8, plotOutput("channelsLinear")),
				column(4,
					column(12, fluidRow(tableOutput("StatisticsLinear"))),
					column(12, fluidRow(tableOutput("AreaLinear"))),
					column(12, fluidRow(tableOutput("LengthLinear")))
				)
			),
			fluidRow(
				column(4,
					sliderInput(inputId = "heightLinear", label = "Height",
						value = 100, min = height.min, max = height.max, step = 20)
				),
				column(4,
					sliderInput(inputId = "probLinear",
						label = "Probability Cutoff",
						value = 0.5, min = 0, max = 1, step = 0.01)
				),
				column(4,
					sliderInput(inputId = "probPoreLinear",
						label = "Pore prob",
						value = 4, min = 0, max = 10, step = 1)
				)
			),
			fluidRow(
				column(4,
					sliderInput(inputId = "widthLinear", label = "Width",
						value = 50, min = 20, max = width.max, step = 10)
				),
				column(4,
					selectInput(inputId = "blockTypeLinear", label = "Block Type",
						c("Poisson" = "Poisson",
						 "Constant" = "Constant",
						 "Range 0:n" = "0:n", 
						 "Range 1:n" = "1:n"))),
				column(4,
					sliderInput(inputId = "probBlockLinear", label = "Block prob",
						value = 5, min = 0, max = 10, step = 1)
				)
			),
			fluidRow(
				column(4,
					actionButton("newLinear", lblNew) )
			)
		),
		### Stats:
		tabPanel("Channel Levels",
			fluidRow(
				column(4, textOutput("txtTitleLinearLevels"))
			),
			fluidRow(
				column(8, plotOutput("LinearLevels"))
			)
		),
		### Help
		tabPanel("Help", uiOutput("HelpUI") )
	)
)

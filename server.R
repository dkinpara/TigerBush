# -----------------------------------------------------------------------------
#
# "Tiger Bush" simulation: Server side
#
# Author: Daniel Kinpara
# Date: September 22nd, 2015.
#
# The myImagePlot function (there's no author name) is available at:
#
# http://www.phaget4.org/R/image_matrix.html
#
# The model used is based on the paper published below:
#
# Thiery, J.M, D'Herbes, J.M., Valentin, C. A model simulating the genesis of
# banded vegetation patterns in Niger. Journal of Ecology, n.83, p.497-507,
# 1995.
#
# The paper can be downloaded here: http://goo.gl/TTjxCC
# -----------------------------------------------------------------------------

library(shiny)

# ----- Defining plot function ----- #

myImagePlot <- function(x, ...){
        min <- min(x)
        max <- max(x)
        yLabels <- rownames(x)
        xLabels <- colnames(x)
        title <-c()
        
# check for additional function arguments
        if( length(list(...)) ){
                Lst <- list(...)
                if( !is.null(Lst$zlim) ){
                        min <- Lst$zlim[1]
                        max <- Lst$zlim[2]
                }
                if( !is.null(Lst$yLabels) ){
                        yLabels <- c(Lst$yLabels)
                }
                if( !is.null(Lst$xLabels) ){
                        xLabels <- c(Lst$xLabels)
                }
                if( !is.null(Lst$title) ){
                        title <- Lst$title
                }
        }
        
# check for null values
        if( is.null(xLabels) ){
                xLabels <- c(1:ncol(x))
        }
        if( is.null(yLabels) ){
                yLabels <- c(1:nrow(x))
        }
        
        layout(matrix(data=c(1,2), nrow=1, ncol=2), widths=c(4,1), heights=c(1,1))
        
# Red and green range from 0 to 1 while Blue ranges from 1 to 0
        ColorRamp <- rgb( seq(0,1,length=256),  # Red
                          seq(0,1,length=256),  # Green
                          seq(1,0,length=256))  # Blue
        ColorLevels <- seq(min, max, length=length(ColorRamp))
        
# Reverse Y axis
        reverse <- nrow(x) : 1
        yLabels <- yLabels[reverse]
        x <- x[reverse,]
        
# Data Map
        par(mar = c(3,5,2.5,2))
        image(1:length(xLabels), 1:length(yLabels), t(x), col=ColorRamp, xlab="",
              ylab="", axes=FALSE, zlim=c(min,max))
        if( !is.null(title) ){
                title(main=title)
        }
        axis(BELOW<-1, at=1:length(xLabels), labels = FALSE, cex.axis=0.7)
        axis(LEFT <-2, at=1:length(yLabels), labels = FALSE, las= HORIZONTAL<-1,
             cex.axis=0.7)
        
# Color Scale
        par(mar = c(3,2.5,2.5,2))
        image(1, ColorLevels,
              matrix(data=ColorLevels, ncol=length(ColorLevels),nrow=1),
              col=ColorRamp,
              xlab="",ylab="",
              xaxt="n")
        layout(1)
}

# ----- END plot function ----- #

shinyServer(function(input, output) {
                
# parameters
     limiteInferior <- -1
     limiteSuperior <-  1

# number of rows and columns of the map matrix
     linha <- 100
     coluna <- linha
     ij <- linha * coluna

     output$mapa <- renderPlot({

# read the widgets in the UI
     a <- input$a
     b <- input$b
     floresta <- input$floresta
     fator <- input$fator
     iteracao <- input$iteracao
     arvores <- input$arvores/100

     if(floresta == 1) {
          flo <- c(.3, .1)
     }
     if(floresta == 2) {
          flo <- c(.2, .2)
     }
     else {
          flo <- c(.1, .3)
     }
          
     densidade <- c(1 - arvores, flo, arvores)

# kernel of the convolution matrix
     kernel <- matrix(c( 0,  0,  0,  0,  0,  0,  b,  0,  0,
                        -a, -a, -a, -a, -a, -a,  0,  3,  1,
                         0,  0,  0,  0,  0,  0,  b,  0,  0),
                         nrow = 9, ncol = 3)

     
# kernel was divided into three square matrix in order to run
# the convolve statement
     kernel1 <- as.vector(kernel[1:3,])
     kernel2 <- as.vector(kernel[4:6,])
     kernel3 <- as.vector(kernel[7:9,])

# define the initial forest coverage
     set.seed(1234)
     tipoCobertura <- 0:3
     cobertura <- sample(tipoCobertura, ij, replace = TRUE, 
                            prob = densidade)

# build the 100 x 100 map matrix
     figura <- matrix(cobertura, nrow = linha, ncol = coluna)

# copy a 3 x 9 matrix of the right border and the bottom in order to simulate a
# "infinite" forest coverage
     figura[, 1:3] <- figura[, 98:100]
     figura[1:9, ] <- figura[92:100, ]

# plot the initial stage of the forest        
     myImagePlot(figura[10:90, 10:90], title = c("Initial stage"))
})


# This is the code for the simulation map plot

output$mapaF <- renderPlot({

# Wait for a click in the "simulate" button
     if(input$go == 0) {
          return
     }

# the widgets input are not reactive, waiting for the "simulate" click     
     isolate({
          a <- input$a
          b <- input$b
          floresta <- input$floresta
          fator <- input$fator
          iteracao <- input$iteracao
          arvores <- input$arvores/100
     })        

# the following code is about the same of the previous code
     if(floresta == 1) {
           flo <- c(.3, .1)
     }
     if(floresta == 2) {
          flo <- c(.2, .2)
     }
     else {
          flo <- c(.1, .3)
     }

     densidade <- c(1 - arvores, flo, arvores)

# kernel
     kernel <- matrix(c( 0,  0,  0,  0,  0,  0,  b,  0,  0,
                        -a, -a, -a, -a, -a, -a,  0,  3,  1,
                         0,  0,  0,  0,  0,  0,  b,  0,  0),
                         nrow = 9, ncol = 3)
     kernel1 <- as.vector(kernel[1:3,])
     kernel2 <- as.vector(kernel[4:6,])
     kernel3 <- as.vector(kernel[7:9,])
        
# initial forest coverage
     set.seed(1234)
     tipoCobertura <- 0:3
     cobertura <- sample(tipoCobertura, ij, replace = TRUE,
                         prob = densidade)
        
# build map matrix
     figura <- matrix(cobertura, nrow = linha, ncol = coluna)
     figura[, 1:3] <- figura[, 98:100]
     figura[1:9, ] <- figura[92:100, ]

# simulation code using convolution matrix

# k iterations
     for(k in 1:iteracao) {

# loop through the rows
          for(i in 1:(linha - 8)) {

# loop through the columns
               for(j in 1:(coluna - 2)) {

# apply the convolve calculation through three kernel square matrix
                    cm1 <- convolve(as.vector(figura[i:(i+2), j:(j+2)]),
                                    kernel1, type = "filter")
                    cm2 <- convolve(as.vector(figura[(i+3):(i+5), j:(j+2)]),
                                    kernel2, type = "filter")
                    cm3 <- convolve(as.vector(figura[(i+6):(i+8), j:(j+2)]),
                                    kernel3, type = "filter")

# calculate the formula presented in Thiery, D'Herbes & Valentin (1995) paper
                    figura[(i+7), (j+1)] <- max(limiteInferior,
                                                min(limiteSuperior,
                                                    sum(cm1, cm2, cm3) *
                                                         fator)) +
                                             figura[(i+7), (j+1)]

# it corrects the values out of the 0-3 range
                    if(figura[(i+7), (j+1)] > 3) {figura[(i+7), (j+1)] <- 3}
                    if(figura[(i+7), (j+1)] < 0) {figura[(i+7), (j+1)] <- 0}
               }
          }

# adjusts for a "infinite" forest coverage          
          figura[, 1:3] <- figura[, 98:100]
          figura[1:9, ] <- figura[92:100, ]
     }

# plot the simulated map matrix
     myImagePlot(figura[10:90, 10:90],
                 title = paste("After", iteracao, "iterations"))
     })
})

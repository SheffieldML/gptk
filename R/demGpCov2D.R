demGpCov2D <- function(ind=c(1,2), path = getwd(),
  filename = paste('demGpCov2D', ind[1],'_', ind[2], sep=''), png=FALSE, gif=FALSE) {
  #require(fields)

#   for (i in 1:length(.libPaths())) { ## Get gptk library location.
#     if ('gptk' %in% .packages(T, lib.loc=.libPaths()[i])) {
#       path
#       source(paste(.libPaths()[i],'/gptk/demos/demGpSample.R', sep=''))
#       break
#     }
#   }

  sample = demGpSample()
  K = sample$K[ind, ind]
  f = sample$f[ind]
  x = sample$x[ind]
  print(K)

  graphics.off() ## kill all devices

#   close.screen(all=T)
#   split.screen(c(1,3)) ## Reset any existing sub-figures setup.
#   lo = layout(matrix(c(1:4),2,2,byrow=T)); layout.show(lo)

  dev.new(width=5,height=4) #   screen(1); erase.screen(1)
  basePlot(K)

  dev.new(width=5,height=4) #   screen(2); erase.screen(2)
  basePlot(K)
  cont2 = lines(c(f[1],f[1]), c(-1,1), col='green')

  dev.new(width=5,height=4) #   screen(3); erase.screen(3)
  basePlot(K)
  cont2 = lines(c(f[1],f[1]), c(-1,1), col='green')
  ## Compute conditional mean and variance
  f2Mean = K[1, 2]/K[1,1]*f[1]
  f2Var = K[2, 2] - K[1, 2]/K[1, 1]*K[1, 2]
  yval = as.matrix(seq(-1, 1, length=200))
  pdfVal = 1/sqrt(2*pi*f2Var)*exp(-0.5*(yval-f2Mean)*(yval-f2Mean)/f2Var)
  pdf = lines(pdfVal*0.25, yval, col='red')

  if (png) {
    for (figNo in 1:3) {
      dev.set(figNo+1) #screen(figNo)
      pathfilename = paste(path,'/',filename,'_', figNo, '.eps', sep='')
      dev.copy2eps(file = pathfilename) ## Save plot as eps
      ## Convert to png. Needs the 'eps2png' facility. If not already installed: 'sudo apt-get install eps2png'
      system(paste('eps2png ', pathfilename, sep=''))
    }
  }

  ## Convert the .png files to one .gif file using ImageMagick. 
  ## The -delay flag sets the time between showing
  ## the frames, i.e. the speed of the animation.
  if (gif)
    system(paste('convert -delay 80 ',path,'/',filename,'*.png ', path,'/',filename,'.gif', sep=''))
}


basePlot <- function (K) {
## BASEPLOT Plot a contour of the 2D Gaussian distribution with covariance matrix K.
## FORMAT
## DESC Creates the basic plot as an ellipse with major and minor radii as the
## square root of the two eigenvalues respectively.
## ARG K : the covariance matrix.
##
## COPYRIGHT : Neil D. Lawrence, 2008; Alfredo Kalaitzis, 2010

  eigVecs = eigen(K)
  U = eigVecs$vectors[ , 2:1] ## Reverse order of eigenvectors(columns).
  V = eigVecs$values
  V[V<0] = as.complex(V[V<0])
  r = Re(sqrt(V))
  theta = seq(0, 2*pi, length=200)
  xy = cbind(r[1]*sin(theta), r[2]*cos(theta))%*%U
  plot(0, type = "n", xlim=c(min(xy[,1]), max(xy[,1])),
    ylim=c(min(xy[,2]), max(xy[,2])), xlab='', ylab='') 
  cont = lines(xy[, 1], xy[, 2], col='blue') ## 'lines' only applies on existing plots.

  zeroAxes()
}

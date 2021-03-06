% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pram.R
\docType{methods}
\name{pram}
\alias{pram}
\alias{pram,data.frame-method}
\alias{pram,matrix-method}
\alias{pram,sdcMicroObj-method}
\alias{pram,vector-method}
\alias{pram-methods}
\title{Post Randomization}
\usage{
pram(obj, variables = NULL, strata_variables = NULL, pd = 0.8,
  alpha = 0.5)
}
\arguments{
\item{obj}{Input data. Allowed input data are objects of class 'matrix',
'data.frame', 'vector' or \code{\link{sdcMicroObj-class}}.}

\item{variables}{Names of variables in 'obj' on which post-randomization
should be applied. If obj is a vector, this argument is ignored.}

\item{strata_variables}{Names of variables for stratification (will be set
automatically for an object of class \code{\link{sdcMicroObj-class}}. One can also specify
an integer vector or factor that specifies that desired groups. This vector must match the dimension
of the input data set, however. For a possible use case, have a look at the examples.}

\item{pd}{minimum diagonal entries for the generated transition matrix P.
Either a vector of length 1 or a vector of length ( number of categories ).}

\item{alpha}{amount of perturbation for the invariant Pram method}

\item{...}{further input, currently ignored.}
}
\value{
a modified \code{\link{sdcMicroObj-class}} object or a new object containing
original and post-randomized variables (with suffix "_pram").
}
\description{
To be used on categorical data. It randomly change the values of variables
on selected records (usually the risky ones) according to an invariant
probability transition matrix.
}
\note{
Deprecated method 'pram_strata'is no longer available
in sdcMicro > 4.5.0
}
\section{Methods}{
 \describe{
\item{list("signature(obj = \"sdcMicroObj\")")}{...}
\item{list("signature(obj = \"data.frame\")")}{...}
\item{list("signature(obj = \"matrix\")")}{...}
\item{list("signature(obj = \"vector\")")}{...}}
}
\examples{

data(testdata)
res <- pram(testdata,
  variables="roof",
  strata_variables=c("urbrur","sex"))
print(res)

res1 <- pram(testdata,variables=c("roof","walls","water"),strata_variables=c("urbrur","sex"))
print(res1)

res2 <- pram(testdata,variables=c("roof","walls","water"),
  strata_variables=NULL)
print(res2)

## for objects of class sdcMicro:
data(testdata2)
sdc <- createSdcObj(testdata2,
  keyVars=c('roof','walls','water','electcon','relat','sex'),
  numVars=c('expend','income','savings'), w='sampling_weight')
sdc <- pram(sdc, variables=c("urbrur"))

# this is equal to the previous application:
sdc <- createSdcObj(testdata2,
  keyVars=c('roof','walls','water','electcon','relat','sex'),
  numVars=c('expend','income','savings'), w='sampling_weight',
  pramVars="urbrur")
sdc <- pram(sdc)

## using a custom strata variable
# we want to apply pram to variable 'urbrur' for each group of variable 'urbrur'
# however: values no value should be changed where roof==4
# thus, we are creating a new value for these observations
data(testdata)
sdc <- createSdcObj(testdata,
  keyVars=c('walls','water','electcon','relat','sex'),
  numVars=c('expend','income','savings'), w='sampling_weight')
sv <- testdata$urbrur
# new category for those that observations that should not change:
sv[testdata$roof==4] <- max(sv)+1
sdc <- pram(sdc, variables=c("roof"), strata_variables=sv)
orig <- get.sdcMicroObj(sdc, "origData")$roof
pramed <- get.sdcMicroObj(sdc, "manipPramVars")$roof
all(pramed[orig==4]==4) # nothing has changed!
}
\author{
Alexander Kowarik, Matthias Templ, Bernhard Meindl
}
\references{
\url{http://www.gnu.org/software/glpk}

\url{http://www.ccsr.ac.uk/sars/guide/2001/pram.pdf}
}
\keyword{manip}


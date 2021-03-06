% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/metafeatures.R
\name{metafeatures}
\alias{metafeatures}
\alias{metafeatures.default}
\title{Extract meta-features from a dataset}
\usage{
metafeatures(...)

\method{metafeatures}{default}(x, groups = "all", summary = c("mean", "sd"), ...)
}
\arguments{
\item{...}{Optional arguments to the summary methods.}

\item{x}{A data.frame contained only the input attributes.}

\item{groups}{A list of meta-features groups, \code{"default"} for traditional
groups of meta-features or \code{"all"} to include all them. The details 
section describes the valid values for this parameter.}

\item{summary}{A list of summarization functions or empty for all values. See
\link{post.processing} method to more information. (Default: 
\code{c("mean", "sd")})}
}
\value{
A numeric vector named by the meta-features from the specified 
groups.
}
\description{
This is a simple way to extract the meta-features from a dataset, where all
meta-features from each group is extracted.
}
\details{
The following groups are allowed for this method:
 \describe{
   \item{"infotheo"}{Include all information theoretical meta-features. See
     \link{infotheo} for more details.}
   \item{"general"}{Include all general (simple) meta-features. See
     \link{general} for more details.}
   \item{"statistical"}{Include all statistical meta-features. See
     \link{statistical} for more details.}
   \item{"dimensionality"}{The dimensionality measures compute information on
     how smoothly the examples are distributed within the attributes. See 
     \link{dimensionality} for more details.}
   \item{"itemset"}{Include all itemset meta-features. See
     \link{itemset} for more details.}
 }
}
\examples{
## Extract all meta-features
metafeatures(iris[,1:4])

## Extract some groups of meta-features
metafeatures(iris[1:4], c("general", "statistical", "infotheo"))

## Use another summary methods
metafeatures(iris[1:4], summary=c("min", "median", "max"))
}

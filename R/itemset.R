#' Itemset Meta-features
#'
#' Itemset characterization features measure measure the distribution of values 
#' of both single attributes and pairs of attributes.
#'
#' @family meta-features
#' @param x A data.frame contained only the input attributes.
#' @param features A list of features names or \code{"all"} to include all them.
#' @param summary A list of summarization functions or empty for all values. See
#'  \link{post.processing} method to more information. (Default: 
#'  \code{c("mean", "sd")})
#' @param ... Further arguments passed to the summarization functions.
#' @details
#'  The following features are allowed for this method:
#'  \describe{
#'    \item{"oneitemset"}{Individual frequency of each attributes' value.}
#'    \item{"twoitemset"}{Correlation information of the two attributes' 
#'      value pairs.}
#'  }
#' @return A list named by the requested meta-features.
#'
#' @references
#' Song, Q., Wang, G., & Wang, C. (2012). Automatic recommendation of 
#'   classification algorithms based on data set characteristics. Pattern 
#'   Recognition, 45(7), 2672-2689.
#'   
#' Wang, G., Song, Q., & Zhu, X. (2015). An improved data characterization 
#'   method and its application in classification algorithm recommendation. 
#'   Applied Intelligence, 43(4), 892-912.
#'
#' @examples
#' ## Extract all meta-features using formula
#' itemset(iris[,1:4])
#'
#' ## Extract some meta-features
#' itemset(iris[,1:4], c("oneitemset"))
#'
#' ## Use another summarization function
#' itemset(iris[,1:4], summary=c("min", "median", "max"))
#' @export
itemset <- function(...) {
  UseMethod("itemset")
}

#' @rdname itemset
#' @export
itemset.default <- function(x, features="all",
                               summary=c("mean", "sd"),
                               ...) {
  if(!is.data.frame(x)) {
    stop("data argument must be a data.frame")
  }

  if(features[1] == "all") {
    features <- ls.itemset()
  }
  features <- match.arg(features, ls.itemset(), TRUE)
  colnames(x) <- make.names(colnames(x), unique=TRUE)

  if (length(summary) == 0) {
    summary <- "non.aggregated"
  }

  x <- categorize(x)
  
  sapply(features, function(f) {
    fn <- paste("m", f, sep=".")
    measure <- eval(call(fn, x=x))
    post.processing(measure, summary, f %in% ls.itemset.multiples(), ...)
  }, simplify=FALSE)
}

#' List the itemset meta-features
#'
#' @return A list of itemset meta-features names.
#' @export
#'
#' @examples
#' ls.itemset()
ls.itemset <- function() {
  c("oneitemset", "twoitemset")
}

ls.itemset.multiples <- function() {
  ls.itemset()
}

m.oneitemset <- function(x, ...) {
  unlist(c(apply(x, 2, table)))/nrow(x)
}

m.twoitemset <- function(x, ...) {
  unlist(c(apply(utils::combn(seq(ncol(x)), 2), 2, function(pair){
    v1 <- table(x[,as.numeric(pair[1])])/nrow(x)
    v2 <- table(x[,as.numeric(pair[2])])/nrow(x)
    
    v12 <- table(apply(x[,as.numeric(pair)], 1, paste, collapse='_'))/nrow(x)
    
    apply(expand.grid(names(v1), names(v2)), 1, function(twop){
      val <- v12[paste(twop, collapse='_')]
      (v1[twop[1]] + v2[twop[2]]) - ifelse(is.na(val), 0, 2*val)
    })
  })))
}

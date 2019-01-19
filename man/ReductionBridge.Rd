% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/seuratFunctions.R
\name{ReductionBridge}
\alias{ReductionBridge}
\alias{ReductionBridge.seurat}
\alias{ReductionBridge.Seurat}
\alias{ReductionBridge.SingleCellExperiment}
\title{ReductionBridge}
\usage{
ReductionBridge(object, ...)

\method{ReductionBridge}{seurat}(object, reduction.use, reduction.save,
  function.use, ...)

\method{ReductionBridge}{Seurat}(object, reduction.use, reduction.save,
  function.use, ...)

\method{ReductionBridge}{SingleCellExperiment}(object, reduction.use,
  reduction.save, function.use, ...)
}
\arguments{
\item{...}{Extra parameters to pass to the dimensional reduction function.}

\item{reduction.use}{Prior dimensional reduction to use for calculations
(i.e. pca, ica, cca, etc...)}

\item{reduction.save}{Name to use for the reduction (i. e. tsne, umap,
etc...)}

\item{function.use}{Dimensional reduction function to call.}
}
\description{
Generalized helper function that pulls the data from a Seurat object, passes
the dataframe to a Python function and places the resulting dataframe in the
appropriate slot
}
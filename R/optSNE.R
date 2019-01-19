#' opt-SNE
#'
#' An R wrapper for the opt-SNE Python module found at
#' https://github.com/omiq-ai/Multicore-opt-SNE
#'
#' @param r.data.frame
#' @param n.components integer (default: 3) Dimension of the embedded space.
#' @param perplexity numeric (default: 30) The perplexity is related to the
#'   number of nearest neighbors that is used in other manifold learning
#'   algorithms. Larger datasets usually require a larger perplexity. Consider
#'   selecting a value between 5 and 50. The choice is not extremely critical
#'   since t-SNE is quite insensitive to this parameter.
#' @param early.exaggeration numeric (default: 12.0) Controls how tight natural
#'   clusters in the original space are in the embedded space and how much space
#'   will be between them. For larger values, the space between natural clusters
#'   will be larger in the embedded space. Again, the choice of this parameter
#'   is not very critical. If the cost function increases during initial
#'   optimization, the early exaggeration factor or the learning rate might be
#'   too high.
#' @param learning.rate numeric (default: 200.0) The learning rate for t-SNE is
#'   usually in the range [10.0, 1000.0]. If the learning rate is too high, the
#'   data may look like a ‘ball’ with any point approximately equidistant from
#'   its nearest neighbours. If the learning rate is too low, most points may
#'   look compressed in a dense cloud with few outliers. If the cost function
#'   gets stuck in a bad local minimum increasing the learning rate may help.
#' @param n.iter integer (default: 1000) Maximum number of iterations for the
#'   optimization. Should be at least 250.
#' @param n.iter.without.progress integer (default: 300) Maximum number of
#'   iterations without progress before we abort the optimization, used after
#'   250 initial iterations with early exaggeration. Note that progress is only
#'   checked every 50 iterations so this value is rounded to the next multiple
#'   of 50.
#' @param min.grad.norm numeric (default: 1e-7) If the gradient norm is below
#'   this threshold, the optimization will be stopped.
#' @param metric character or callable The metric to use when calculating distance
#'   between instances in a feature array. If metric is a character, it must be one
#'   of the options allowed by scipy.spatial.distance.pdist for its metric
#'   parameter, or a metric listed in pairwise.PAIRWISE.DISTANCE.FUNCTIONS. If
#'   metric is “precomputed”, X is assumed to be a distance matrix.
#'   Alternatively, if metric is a callable function, it is called on each pair
#'   of instances (rows) and the resulting value recorded. The callable should
#'   take two arrays from X as input and return a value indicating the distance
#'   between them. The default is “euclidean” which is interpreted as squared
#'   euclidean distance.
#' @param init character or numpy array (default: “random”) Initialization of
#'   embedding. Possible options are ‘random’, ‘pca’, and a numpy array of shape
#'   (n.samples, n.components). PCA initialization cannot be used with
#'   precomputed distances and is usually more globally stable than random
#'   initialization.
#' @param verbose integer (default: 0) Verbosity level.
#' @param random.state int, RandomState instance or NULL (default: NULL) If int,
#'   random.state is the seed used by the random number generator; If
#'   RandomState instance, random.state is the random number generator; If NULL,
#'   the random number generator is the RandomState instance used by np.random.
#'   Note that different initializations might result in different local minima
#'   of the cost function.
#' @param method character (default: ‘barnes.hut’) By default the gradient
#'   calculation algorithm uses Barnes-Hut approximation running in O(NlogN)
#'   time. method=’exact’ will run on the slower, but exact, algorithm in O(N^2)
#'   time. The exact algorithm should be used when nearest-neighbor errors need
#'   to be better than 3%. However, the exact method cannot scale to millions of
#'   examples.
#' @param angle numeric (default: 0.5) Only used if method=’barnes.hut’ This is
#'   the trade-off between speed and accuracy for Barnes-Hut T-SNE. ‘angle’ is
#'   the angular size (referred to as theta in [3]) of a distant node as
#'   measured from a point. If this size is below ‘angle’ then it is used as a
#'   summary node of all points contained within it. This method is not very
#'   sensitive to changes in this parameter in the range of 0.2 - 0.8. Angle
#'   less than 0.2 has quickly increasing computation time and angle greater 0.8
#'   has quickly increasing error.#'
#' @param auto_iter boolean (default: TRUE) Should optimal parameters be determined?
#'   If false, behaves like stock MulticoreTSNE
#' @param auto_iter_end int (default: 5000) Number of iterations for parameter
#'   optimization.
#'
#' @importFrom reticulate import
#' @importFrom parallel detectCores
#'
#' @return dataframe
#' @export
#'
#' @examples
optSNE <- function(r.data.frame,
                          n.components = 3,
                          perplexity = 30.,
                          early.exaggeration = 12.0,
                          learning.rate = 200.0,
                          n.iter = 1000,
                          n.iter.without.progress = 300,
                          min.grad.norm = 1e-07,
                          metric = 'euclidean',
                          init = 'random',
                          verbose = 1,
                          random.state = NULL,
                          method = 'barnes_hut',
                          angle = 0.5,
                          auto_iter = TRUE,
                          auto_iter_end = 5000,
                          n.jobs = NULL
){
  if(!py_module_available('MulticoreTSNE')){
    stop("The Multicore-opt-SNE module is unavailable.  Please activate the appropriate environment or install the module.")
  }

  optsne.module <- import(module = 'MulticoreTSNE', delay_load = TRUE)
  if (is.null(n.jobs)){
    n.jobs <- detectCores()
  }
  optsne <- optsne.module$MulticoreTSNE(n_components = as.integer(n.components),
                                        perplexity = as.numeric(perplexity),
                                        early_exaggeration = as.numeric(early.exaggeration),
                                        learning_rate = as.numeric(learning.rate),
                                        n_iter = as.integer(n.iter),
                                        n_iter_without_progress = as.integer(n.iter.without.progress),
                                        min_grad_norm = as.numeric(min.grad.norm),
                                        metric = metric,
                                        init = init,
                                        verbose = as.integer(verbose),
                                        random_state = random.state,
                                        method = method,
                                        angle = as.numeric(angle),
                                        auto_iter = auto_iter,
                                        auto_iter_end = auto_iter_end,
                                        n_jobs = n.jobs)

  optsne.df <- optsne$fit_transform(r.data.frame)
  return(optsne.df)
}
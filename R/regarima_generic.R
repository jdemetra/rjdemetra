# USER:
# Method "regarima" for the function coef
#' @export
coef.regarima <- function(object, component = c("regression", "arima", "both"), ...){
  if (is.null(object))
    return(NULL)

  component <- match.arg(component)
  if (component == "regression") {
    object$regression.coefficients[, "Estimate"]
  } else if (component == "arima") {
    object$arima.coefficients[, "Estimate"]
  } else{
    c(object$arima.coefficients[, "Estimate"],
      object$regression.coefficients[, "Estimate"])
  }
}
#' @export
coef.SA <- function(object, component = c("regression", "arima", "both"), ...){
  coef.regarima(object$regarima, component, ...)
}
# USER:
# Method "regarima" for the function logLik
# attributes: df = number of parameters, nobs = number of effective observations
#' @export
logLik.regarima <- function(object, ...) {

  if (is.null(object) || is.null(object$loglik["logvalue", ])) {
    res <- NA
  }else{
    res <- structure(object$loglik["logvalue", ],
                     df = object$loglik["np",],
                     nobs = object$loglik["neffectiveobs", ])
  }
  class(res) <- "logLik"
  res
}
#' @export
logLik.SA <- function(object, ...) {
  logLik.regarima(object$regarima, ...)
}
#' @export
vcov.regarima <- function(object, component = c("regression", "arima"), ...){
  if (is.null(object))
    return(NULL)
  component <- match.arg(component)
  y <- get_ts(object)
  jmod <- jregarima(y, object)
  if (component == "regression") {
    result <- get_indicators(jmod, "model.covar")[[1]]
    if (!is.null(result))
      rownames(result) <- colnames(result) <-
        get_indicators(jmod, "model.description")[[1]]
  } else if (component == "arima") {
    result <- get_indicators(jmod, "model.pcovar")[[1]]
  }

  result
}
#' @export
vcov.SA <- function(object, component = c("regression", "arima"), ...){
  component <- match.arg(component)
  if (component == "regression" & "preprocessing.model.covar" %in% names(object$user_defined)) {
    result <- object$user_defined$preprocessing.model.covar
    if(!is.null(result))
      rownames(result) <- colnames(result) <- rownames(object$regarima$regression.coefficients)
  } else if (component == "arima" & "preprocessing.model.pcovar" %in% names(object$user_defined)){
    result <- vcov.regarima(object$regarima, ...)
  } else {
    result <- vcov.regarima(object$regarima, component = component, ...)
  }
  result
}
#' @export
df.residual.regarima <- function(object, ...){
  if (is.null(object))
    return(NULL)

  object$loglik["neffectiveobs",] - object$loglik["np",]
}
#' @export
df.residual.SA <- function(object, ...){
  df.residual.regarima(object$regarima, ...)
}
#' @export
nobs.regarima <- function(object, ...){
  if (is.null(object))
    return(NULL)

 object$loglik["neffectiveobs",]
}
#' @export
nobs.SA <- function(object, ...){
  nobs.regarima(object$regarima, ...)
}
#' @export
residuals.regarima <- function(object, ...){
  if (is.null(object))
    return(NULL)

  object$residuals
}
#' @export
residuals.SA <- function(object, ...){
  residuals.regarima(object$regarima, ...)
}

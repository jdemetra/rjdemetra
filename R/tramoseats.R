setClass(
  Class="TramoSeats_java",
  contains = "ProcResults"
)

#' Seasonal Adjustment with TRAMO-SEATS
#'
#' @description
#' Function to estimate the seasonally adjusted series (sa) with the TRAMO-SEATS method.
#' This is achieved by decomposing the time series (y) into the: trend-cycle (t), seasonal component (s) and irregular component (i).
#' The final seasonally adjusted series shall be free of seasonal and calendar-related movements.
#' \code{tramoseats} returns a preformatted result while \code{jtramoseats} returns the Java objects of the seasonal adjustment.
#'
#' @param series a univariate time series
#' @param spec model specification TRAMO-SEATS. It can be a \code{character} of the predefined TRAMO-SEATS 'JDemetra+' model specification (see \emph{Details}), or an object of class \code{c("SA_spec","TRAMO_SEATS")}. The default is \code{"RSAfull"}.
#' @param userdefined vector with characters for additional output variables (see \code{\link{user_defined_variables}}).
#'
#' @details
#' The first step of the seasonal adjustment consist of pre-adjusting the time series by removing from it the deterministic effects by means of a regression model with ARIMA noise (RegARIMA, see: \code{\link{regarima}}).
#' In the second part, the pre-adjusted series is decomposed into the following components: trend-cycle (t), seasonal component (s) and irregular component (i). The decomposition can be: additive  (\eqn{y = t + s + i}) or multiplicative (\eqn{y = t * s * i}). The final seasonally adjusted series (sa) shall be free of seasonal and calendar-related movements.
#'
#' In the TRAMO-SEATS method, the second step - SEATS ("Signal Extraction in ARIMA Time Series") - performs an ARIMA-based decomposition of an observed time series into unobserved components. More information on the method can be found on the Bank of Spian website (\url{https://www.bde.es/bde/es/}).
#'
#' As regards the available predefined 'JDemetra+' TRAMO-SEATS model specifications, they are described in the table below.
#' \tabular{rrrrrrrr}{
#' \strong{Identifier} |\tab \strong{Log/level detection} |\tab \strong{Outliers detection} |\tab \strong{Calendar effects} |\tab \strong{ARIMA}\cr
#' RSA0 |\tab \emph{NA} |\tab \emph{NA} |\tab \emph{NA} |\tab Airline(+mean)\cr
#' RSA1 |\tab automatic |\tab AO/LS/TC |\tab \emph{NA} |\tab Airline(+mean)\cr
#' RSA2 |\tab automatic |\tab AO/LS/TC |\tab 2 td vars + Easter |\tab Airline(+mean)\cr
#' RSA3 |\tab automatic |\tab AO/LS/TC |\tab \emph{NA} |\tab automatic\cr
#' RSA4 |\tab automatic |\tab AO/LS/TC |\tab 2 td vars + Easter |\tab automatic\cr
#' RSA5 |\tab automatic |\tab AO/LS/TC |\tab 7 td vars + Easter |\tab automatic\cr
#' RSAfull |\tab automatic |\tab AO/LS/TC |\tab automatic |\tab automatic
#' }
#'
#' @return
#'
#' \code{jtramoseats} returns a \code{\link{jSA}} object. It contains the Java objects of the result of the seasonal adjustment without any formatting. Therefore the computation is faster than with \code{tramoseats}. The results can the seasonal adjustment can be extract by \code{\link{get_indicators}}.
#'
#' \code{tramoseats} returns an object of class \code{c("SA","TRAMO_SEATS")}, a list containing the following components:
#'
#' \item{regarima}{object of class \code{c("regarima","TRAMO_SEATS")}. See \emph{Value} of the function \code{\link{regarima}}.}
#'
#' \item{decomposition}{object of class \code{"decomposition_SEATS"}, five elements list:
#' \itemize{
#' \item \code{specification} list with the SEATS algorithm specification. See also function \code{\link{tramoseats_spec}}
#' \item \code{mode} decomposition mode
#' \item \code{model} list with the SEATS models: \code{model, sa, trend, seasonal, transitory, irregular}. Each of them is a matrix with the estimated coefficients.
#' \item \code{linearized} time series matrix (mts) with the stochastic series decomposition (input series \code{y_lin}, seasonally adjusted \code{sa_lin}, trend \code{t_lin}, seasonal \code{s_lin}, irregular \code{i_lin})
#' \item \code{components} time series matrix (mts) with the decomposition components (input series \code{y_cmp}, seasonally adjusted \code{sa_cmp}, trend \code{t_cmp}, seasonal \code{s_cmp}, irregular \code{i_cmp})
#' }
#' }
#'
#' \item{final}{object of class \code{c("final","mts","ts","matrix")}. Matrix with the final results of the seasonal adjustment.
#' It includes time series: original time series (\code{y}), forecast of the original series (\code{y_f}), trend (\code{t}), forecast of the trend (\code{t_f}),
#' seasonally adjusted series (\code{sa}), forecast of the seasonally adjusted series (\code{sa_f}),
#' seasonal component (\code{s}), forecast of the seasonal component (\code{s_f}), irregular component (\code{i}) and the forecast of the irregular component (\code{i_f}).}
#'
#' \item{diagnostics}{object of class \code{"diagnostics"}, list with three type of diagnostics tests:
#' \itemize{
#' \item \code{variance_decomposition} data.frame with the tests on the relative contribution of the components to the stationary portion of the variance in the original series, after the removal of the long term trend.
#' \item \code{residuals_test} data.frame with the tests on the presence of seasonality in the residuals (includes the statistic, p-value and parameters description)
#' \item \code{combined_test}  combined tests for stable seasonality in the entire series. Two elements list with: \code{tests_for_stable_seasonality} - data.frame with the tests (includes the statistic, p-value and parameters description) and \code{combined_seasonality_test} - the summary.
#' }}
#' \item{user_defined}{object of class \code{"user_defined"}. List containing the userdefined additional variables defined in the \code{userdefined} argument.}
#'
#' @references
#' Info on 'JDemetra+', usage and functions:
#' \url{https://ec.europa.eu/eurostat/cros/content/documentation_en}
#'
#' BOX G.E.P. and JENKINS G.M. (1970), "Time Series Analysis: Forecasting and Control", Holden-Day, San Francisco.
#'
#' BOX G.E.P., JENKINS G.M., REINSEL G.C. and LJUNG G.M. (2015), "Time Series Analysis: Forecasting and Control", John Wiley & Sons, Hoboken, N. J., 5th edition.
#'
#' @seealso \code{\link{tramoseats_spec}}, \code{\link{x13}}
#'
#' @examples \donttest{
#' myseries <- ipi_c_eu[, "FR"]
#' myspec <- tramoseats_spec("RSAfull")
#' mysa <- tramoseats(myseries, myspec)
#' mysa
#'
#' # Equivalent to:
#' mysa1 <- tramoseats(myseries, spec = "RSAfull")
#' mysa1
#'
#' var1 <- ts(rnorm(length(myseries))*10, start = start(myseries), frequency = 12)
#' var2 <- ts(rnorm(length(myseries))*100, start = start(myseries), frequency = 12)
#' var <- ts.union(var1, var2)
#' myspec2 <- tramoseats_spec(myspec, tradingdays.mauto = "Unused",
#'                            tradingdays.option = "WorkingDays",
#'                            easter.type = "Standard",
#'                            automdl.enabled = FALSE, arima.mu = TRUE,
#'                            usrdef.varEnabled = TRUE, usrdef.var = var)
#' s_preVar(myspec2)
#' mysa2 <- tramoseats(myseries, myspec2,
#'                     userdefined = c("decomposition.sa_lin_f",
#'                                     "decomposition.sa_lin_e"))
#' mysa2
#' plot(mysa2)
#' plot(mysa2$regarima)
#' plot(mysa2$decomposition)
#' }
#' @export
tramoseats <- function(series, spec = c("RSAfull", "RSA0", "RSA1", "RSA2", "RSA3", "RSA4", "RSA5"),
                       userdefined = NULL){
  if (!is.ts(series)) {
    stop("series must be a time series")
  }
  UseMethod("tramoseats", spec)
}
#' @export
tramoseats.SA_spec <- function(series, spec,
                      userdefined = NULL){
  jsa_obj <- jtramoseats.SA_spec(series, spec)
  jrslt <- jsa_obj[["result"]]@internal
  jrspec <- jsa_obj[["spec"]]

  # Or, using the fonction x13JavaResults:
  # return(tramoseatsJavaResults(jrslt = jrslt, spec = jrspec, userdefined = userdefined))

  jrarima <- .jcall(jrslt, "Lec/tstoolkit/jdr/regarima/Processor$Results;", "regarima")
  jrobct_arima <- new (Class = "TRAMO_java",internal = jrarima)
  jrobct <- new (Class = "TramoSeats_java", internal = jrslt)

  if (is.null(jrobct@internal)){
    return (NaN)
  }else{

    #Error with preliminary check
    if(is.null(jrslt$getDiagnostics()) & !jrslt$getResults()$getProcessingInformation()$isEmpty()){
      proc_info <- jrslt$getResults()$getProcessingInformation()
      error_msg <- proc_info$get(0L)$getErrorMessages(proc_info)
      if(!error_msg$isEmpty())
        stop(error_msg$toString())
    }
    reg <- regarima_TS(jrobj = jrobct_arima, spec = spec$regarima)
    deco <- decomp_TS(jrobj = jrobct, spec = spec$seats)
    fin <- final(jrobj = jrobct)
    diagn <- diagnostics(jrobj = jrobct)

    z <- list(regarima = reg, decomposition = deco, final = fin,
              diagnostics = diagn,
              user_defined = user_defined(userdefined, jrobct))

    class(z) <- c("SA","TRAMO_SEATS")
    return(z)
  }
}
#' @export
tramoseats.character <- function(series, spec = c("RSAfull", "RSA0", "RSA1", "RSA2", "RSA3", "RSA4", "RSA5"),
                           userdefined = NULL){
  jsa_obj <- jtramoseats.character(series, spec)
  jrslt <- jsa_obj[["result"]]@internal
  jrspec <- jsa_obj[["spec"]]

  return(tramoseatsJavaResults(jrslt = jrslt, spec = jrspec, userdefined = userdefined))
}

tramoseatsJavaResults <- function(jrslt, spec,
                                  userdefined = NULL,
                                  context_dictionary = NULL,
                                  extra_info = FALSE,
                                  freq = NA){
  jrarima <- .jcall(jrslt, "Lec/tstoolkit/jdr/regarima/Processor$Results;", "regarima")
  jrobct_arima <- new(Class = "TRAMO_java",internal = jrarima)
  jrobct <- new(Class = "TramoSeats_java", internal = jrslt)

  if (is.null(jrobct@internal))
    return(NaN)

  #Error with preliminary check
  if(is.null(jrslt$getDiagnostics()) & !jrslt$getResults()$getProcessingInformation()$isEmpty()){
    proc_info <- jrslt$getResults()$getProcessingInformation()
    error_msg <- proc_info$get(0L)$getErrorMessages(proc_info)
    if(!error_msg$isEmpty())
      stop(error_msg$toString())
  }

  reg <- regarima_defTS(jrobj = jrobct_arima, spec = spec,
                        context_dictionary = context_dictionary,
                        extra_info = extra_info,
                        freq = freq)
  deco <- decomp_defTS(jrobj = jrobct, spec = spec)
  fin <- final(jrobj = jrobct)
  diagn <- diagnostics(jrobj = jrobct)

  z <- list(regarima = reg, decomposition = deco, final = fin,
            diagnostics = diagn,
            user_defined = user_defined(userdefined, jrobct))

  class(z) <- c("SA","TRAMO_SEATS")
  return(z)

}

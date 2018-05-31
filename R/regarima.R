#Define the S4 java object
setClass(
  Class="JD2_RegArima_java",
  contains = "JD2_ProcResults"
)
setClass(
  Class="JD2_TRAMO_java",
  contains = "JD2_ProcResults"
)
#' RegARIMA model, pre-adjustment in X13 and TRAMO-SEATS
#' @description
#' \code{regarima/regarimaDefX13/regarimaDefTS} decomposes the time series in a linear deterministic component and in a stochastic component. The deterministic part of the series can contain outliers, calendar effects and regression effects. The stochastic part is defined by a seasonal multiplicative ARIMA model, as discussed by BOX, G.E.P., and JENKINS, G.M. (1970).
#'
#' @param series a univariate time series
#' @param spec model specification. For the function:
#' \itemize{
#' \item \code{regarima}, object of class \code{c("regarima_spec","X13") or c("regarima_spec","TRAMO_SEATS")}).
#' See functions \code{\link{regarima_specX13}, \link{regarima_specDefX13}, \link{regarima_specTS}}, and \code{\link{regarima_specDefTS}}.
#' \item \code{regarimaDefX13}, predefined X13 \emph{JDemetra+} model specification (see \emph{Details}). The default is "RG5c".
#' \item \code{regarimaDefTS}, predefined TRAMO-SEATS \emph{JDemetra+} model specification (see \emph{Details}). The default is "TRfull".
#'}
#'
#' @details
#' In the X13 and TRAMO-SEATS seasonal adjustment the first step consists of pre-adjusting the original series with a RegARIMA model, where the original series is corrected for any deterministic effects and missing observations. This step is also referred as linearization of the original series.
#'
#' The RegARIMA model (model with ARIMA errors) is specified as below.
#'
#' \deqn{z_t=y_t\beta+x_t}
#'
#' where:
#' \itemize{
#' \item \eqn{z_t} - is the original series;
#' \item \eqn{\beta = (\beta_1,...,\beta_n)} - a vector of regression coefficients;
#' \item \eqn{y_t = (y_{1t},...,y_{nt})} - \eqn{n} regression variables (outliers, calendar effects, user-defined variables);
#' \item \eqn{x_t} - a disturbance that follows the general ARIMA process:
#' \eqn{\phi(B)\delta(B)x_t=\theta(B)a_t}; \eqn{\phi(B), \delta(B)} and \eqn{\theta(B)} are the finite polynomials in \eqn{B}; \eqn{a_t} is a white-noise variable with zero mean and a constant variance.
#' }
#'
#' The polynomial \eqn{\phi(B)} is a stationary autoregressive (AR) polynomial in \eqn{B}, which is a product of the stationary regular AR polynomial in \eqn{B} and the stationary seasonal polynomial in \eqn{B^s}:
#'
#' \deqn{\phi(B)=\phi_p(B)\Phi_{bp}(B^s)=(1+\phi_1B+...+\phi_pB^p)(1+\Phi_1B^s+...+\Phi_{bp}B^{bps})}
#'
#' where:
#' \itemize{
#' \item \eqn{p} - number of regular AR terms (here and in \emph{JDemetra+} \eqn{p \le 3});
#' \item \eqn{bp} - number of seasonal AR terms (here and in \emph{JDemetra+} \eqn{bp \le 1});
#' \item \eqn{s} - number of observations per year (frequency of the time series).
#' }
#'
#' The polynomial \eqn{\theta(B)} is an invertible moving average (MA) polynomial in \eqn{B}, which is a product of the invertible regular MA polynomial in \eqn{B} and the invertible seasonal MA polynomial in \eqn{B^s}:
#'
#' \deqn{\theta(B)=\theta_q(B)\Theta_{bq}(B^s)=(1+\theta_1B+...+\theta_qB^q)(1+\Theta_1B^s+...+\Theta_{bq}B^{bqs})}
#'
#' where:
#' \itemize{
#' \item \eqn{q} - number of regular MA terms (here and in \emph{JDemetra+} \eqn{q \le 3});
#' \item \eqn{bq} - number of seasonal MA terms (here and in \emph{JDemetra+} \eqn{bq \le 1});
#' }
#'
#' The polynomial \eqn{\delta(B)} is the non-stationary AR polynomial in \eqn{B} (unit roots):
#'
#' \deqn{\delta(B)=(1-B)^d(1-B^s)^{d_s}}
#'
#' where:
#' \itemize{
#' \item \eqn{d} - regular differencing order (here and in \emph{JDemetra+} \eqn{d \le 1});
#' \item \eqn{d_s} - seasonal differencing order (here and in \emph{JDemetra+} \eqn{d_s \le 1});
#' }
#'
#' Notations used for AR and MA processes, model denoted as ARIMA \eqn{(P,D,Q)(BP,BD,BQ)}, are consistent with those in \emph{JDemetra+}.
#'
#' As regards the available predefined \emph{JDemetra+} X13 and TRAMO-SEATS model specifications, they are described in the tables below.
#'
#' \strong{X13:}
#' \tabular{rrrrrrr}{
#' \strong{Identifier} |\tab \strong{Log/level detection} |\tab \strong{Outliers detection} |\tab \strong{Calender effects} |\tab \strong{ARIMA}\cr
#' RG0 |\tab \emph{NA} |\tab \emph{NA} |\tab \emph{NA} |\tab Airline(+mean)\cr
#' RG1 |\tab automatic |\tab AO/LS/TC  |\tab \emph{NA} |\tab Airline(+mean)\cr
#' RG2c |\tab automatic |\tab AO/LS/TC |\tab 2 td vars + Easter |\tab Airline(+mean)\cr
#' RG3 |\tab automatic |\tab AO/LS/TC |\tab \emph{NA} |\tab automatic\cr
#' RG4c |\tab automatic |\tab AO/LS/TC |\tab 2 td vars + Easter |\tab automatic\cr
#' RG5c |\tab automatic |\tab AO/LS/TC |\tab 7 td vars + Easter |\tab automatic
#' }
#'
#' \strong{TRAMO-SEATS:}
#' \tabular{rrrrrrrr}{
#' \strong{Identifier} |\tab \strong{Log/level detection} |\tab \strong{Outliers detection} |\tab \strong{Calender effects} |\tab \strong{ARIMA}\cr
#' TR0 |\tab \emph{NA} |\tab \emph{NA} |\tab \emph{NA} |\tab Airline(+mean)\cr
#' TR1 |\tab automatic |\tab AO/LS/TC |\tab \emph{NA} |\tab Airline(+mean)\cr
#' TR2 |\tab automatic |\tab AO/LS/TC |\tab 2 td vars + Easter |\tab Airline(+mean)\cr
#' TR3 |\tab automatic |\tab AO/LS/TC |\tab \emph{NA} |\tab automatic\cr
#' TR4 |\tab automatic |\tab AO/LS/TC |\tab 2 td vars + Easter |\tab automatic\cr
#' TR5 |\tab automatic |\tab AO/LS/TC |\tab 7 td vars + Easter |\tab automatic\cr
#' TRfull |\tab automatic |\tab AO/LS/TC |\tab automatic |\tab automatic
#' }
#'
#' @return
#' \code{regarima/regarimaDefX13/regarimaDefTS} return an object of class \code{"regarima"} and sub-class \code{"X13"} or \code{"TRAMO_SEATS"}. \code{regarimaDefX13} returns an object of class \code{c("regarima","X13")} and \code{regarimaDefTS} an object of class \code{c("regarima","TRAMO_SEATS")}.
#' For the function \code{regarima}, the sub-class of the object depends on the used method that is defined by the class of the \code{spec} object.
#'
#' An object of class \code{"regarima"} is a list containing the following components:
#'
#' \item{specification}{list with the model specification as defined by the \code{spec} argument. See also Value of the \code{\link{regarima_specX13}} and  \code{\link{regarima_specTS}} functions.}
#'
#' \item{arma}{vector with the orders of the autoregressive (AR), moving average (MA), seasonal AR and seasonal MA processes, as well as with the regular and seasonal differencing orders (P,D,Q) (BP,BD,BQ).}
#'
#' \item{arima.coefficients}{ matrix with the regular and seasonal AR and MA coefficients. The matrix contains the estimated coefficients, standard errors and t-statistics values. The estimated coefficients can be also extracted with the function \code{\link[stats]{coef}} (the output includes also the regression coefficients).}
#'
#' \item{regression.coefficients}{ matrix with the regression variables (i.e.: mean, calendar effect, outliers and user-defined regressors) coefficients. The matrix contains the estimated coefficients, standard errors and t-statistics values. The estimated coefficients can be also extracted with the function \code{\link[stats]{coef}} (output includes also the arima coefficients). }
#'
#' \item{loglik}{ matrix containing the log-likelihood of the RegARIMA model as well as the associated model selection criteria statistics (AIC, AICC, BIC and BICC) and parameters (\code{np} = number of parameters in the likelihood, \code{neffectiveobs} = number of effective observations in the likelihood). These statistics can be also extracted with the function \code{\link[stats]{logLik}}.}
#'
#' \item{model}{list containing the information on the model specification after its estimation (\code{spec_rslt}), as well as the decomposed elements of the input series (ts matrix, \code{effects}). The model specification includes the information on the estimation method (\code{Model}) and time span (\code{T.span}), whether the original series was log transformed (\code{Log transformation}) and details on the regression part of the RegARIMA model; i.e. if it includes a \code{Mean}, \code{Trading days} effects (if yes, it provides the number of regressors), \code{Leap year} effect, \code{Easter} effect and whether outliers were detected (\code{Outliers}; if yes, it provides the number of outliers). The decomposed elements of the input series contain the linearised series (\code{y_lin}) and the deterministic components; i.e.: trading days effect (\code{tde}), Easter effect (\code{ee}), other moving holidays effect (\code{omhe}) and outliers effect (total - \code{out}, related to irregular - \code{out_i}, related to trend - \code{out_t}, related to seasonal - \code{out_s}).}
#'
#' \item{residuals}{ the residuals (time series). They can be also extracted with the function \code{\link[stats]{residuals}}.}
#'
#' \item{residuals.stat}{List containing statistics on the RegARIMA residuals. It provides residuals standard error (\code{st.error}) and results for the tests on the normality, independence and linearity of the residuals (\code{tests}) - object of class \code{c("regarima_rtests","data.frame")}.}
#'
#' \item{forecast}{ts matrix containing the forecast of the original series (\code{fcst}) and it's standard error (\code{fcsterr}).}
#'
#'
#' @references
#' Info on JDemtra+, usage and functions:
#' \url{https://ec.europa.eu/eurostat/cros/content/documentation_en}
#'
#' BOX G.E.P. and JENKINS G.M. (1970), "Time Series Analysis: Forecasting and Control", Holden-Day, San Francisco.
#'
#' BOX G.E.P., JENKINS G.M., REINSEL G.C. and LJUNG G.M. (2015), "Time Series Analysis: Forecasting and Control", John Wiley & Sons, Hoboken, N. J., 5th edition.
#'
#'
#' @examples
#'
#' # X13 method
#'   myreg <- regarimaDefX13(myseries, spec=c("RG5c"))
#'
#'   myspec1 <- regarima_specX13(myreg,tradingdays.option = "WorkingDays")
#'   myreg1 <- regarima(myseries, myspec1)
#'   summary(myreg1)
#'
#'   myspec2<-regarima_specX13(myreg, usrdef.outliersEnabled = TRUE,
#'                              usrdef.outliersType = c("LS","AO"),
#'                              usrdef.outliersDate=c("2008-10-01","2002-01-01"),
#'                              usrdef.outliersCoef = c(36000,14000),
#'                              transform.function = "None")
#'   myreg2 <- regarima(myseries, myspec2)
#'   myreg2
#'
#'   myspec3 <- regarima_specX13(myreg, automdl.enabled =FALSE,
#'                                arima.p=1,arima.q=1, arima.bp=0, arima.bq=1,
#'                                arima.coefEnabled = TRUE,
#'                                arima.coef = c(-0.8,-0.6,0),
#'                                arima.coefType = c(rep("Fixed",2),"Undefined"))
#'   s_arimaCoef(myspec3)
#'   myreg3 <- regarima(myseries, myspec3)
#'   summary(myreg3)
#'   plot(myreg3)
#'
#' # TRAMO-SEATS method
#'   myspec<-regarima_specDefTS("TRfull")
#'   myreg <-regarima(myseries,myspec)
#'   myreg1 <- regarimaDefTS(myseries, spec = "TRfull")
#'   myreg
#'   myreg1
#'
#'   myspec2 <-regarima_specTS(myspec,tradingdays.mauto="Unused",tradingdays.option ="WorkingDays",
#'                              easter.type = "Standard", automdl.enabled = FALSE, arima.mu = TRUE)
#'   myreg2 <- regarima(myseries, myspec2)
#'
#'   var1 <- ts(rnorm(length(myseries))*10,start = c(2001, 12), frequency = 12)
#'   var2 <- ts(rnorm(length(myseries))*100,start = c(2001, 12), frequency = 12)
#'   var<-ts.union(var1,var2)
#'   myspec3 <- regarima_specTS(myspec,
#'                               usrdef.varEnabled = TRUE, usrdef.var = var)
#'   s_preVar(myspec3)
#'   myreg3 <- regarima(myseries,myspec3)
#'   myreg3
#' @export
# Generic function to create a "regarima" S3 class object from a user-defined specification (for X13 or TRAMO-SEATS method)
regarima<-function(series, spec = NA){
  if (!inherits(spec, "regarima_spec")){
    stop("use only with \"regarima_spec\" object", call. = FALSE)
  }else{
    UseMethod("regarima", spec)
  }
}
# Method: "X13"
#' @export
regarima.X13 <-function(series, spec = NA){
  if (!is.ts(series))
    stop("series must be a time series")
  if (!inherits(spec, "regarima_spec") | !inherits(spec, "X13"))
    stop("use only with c(\"regarima_spec\",\"X13\") class object")

  # create the java objects
  jrspec <-.jcall("jdr/spec/x13/RegArimaSpec", "Ljdr/spec/x13/RegArimaSpec;", "of", "RG1")
  # introduce modifications from the spec and create the java dictionary with the user-defined variables
  jdictionary <- specX13_r2jd(spec,jrspec)
  jspec<-.jcall(jrspec, "Lec/tstoolkit/modelling/arima/x13/RegArimaSpecification;", "getCore")
  jrslt<-.jcall("ec/tstoolkit/jdr/regarima/Processor", "Lec/tstoolkit/jdr/regarima/Processor$Results;", "x12", ts_r2jd(series), jspec, jdictionary)
  jrobct <- new (Class = "JD2_RegArima_java", internal = jrslt)

  if (is.null(jrobct@internal)){
    return (NaN)
  }else{
    z <- regarima_X13(jrobj = jrobct, spec = spec)
    return(z)
  }
}

# Method: "TRAMO_SEATS"
#' @export
regarima.TRAMO_SEATS<-function(series, spec = NA){
  if (!is.ts(series))
    stop("series must be a time series")
  if (!inherits(spec, "regarima_spec") | !inherits(spec, "TRAMO_SEATS"))
    stop("use only with c(\"regarima_spec\",\"TRAMO_SEATS\") class object")

  # create the java objects
  jrspec<-.jcall("jdr/spec/tramoseats/TramoSpec", "Ljdr/spec/tramoseats/TramoSpec;", "of", "TR1")
  # introduce modifications from the spec and create the java dictionary with the user-defined variables
  jdictionary <- specTS_r2jd(spec,jrspec)
  jspec<-.jcall(jrspec, "Lec/tstoolkit/modelling/arima/tramo/TramoSpecification;", "getCore")
  jrslt<-.jcall("ec/tstoolkit/jdr/regarima/Processor", "Lec/tstoolkit/jdr/regarima/Processor$Results;", "tramo", ts_r2jd(series), jspec, jdictionary)
  jrobct<- new (Class = "JD2_TRAMO_java", internal = jrslt)

  if (is.null(jrobct@internal)){
    return (NaN)
  }else{
    z <- regarima_TS(jrobj = jrobct, spec = spec)
    return(z)
  }
}

# The function creates a "regarima" S3 class object from a JD+ defined specification for TRAMO-SEATS method
#' @rdname regarima
#' @name regarima
#' @export
regarimaDefTS <-function(series, spec=c("TRfull", "TR0", "TR1", "TR2", "TR3", "TR4", "TR5")){
  if (!is.ts(series)){
    stop("series must be a time series")
  }
  spec<-match.arg(spec)

  # create the java objects
  jrspec<-.jcall("jdr/spec/tramoseats/TramoSpec", "Ljdr/spec/tramoseats/TramoSpec;", "of", spec)
  jspec<-.jcall(jrspec, "Lec/tstoolkit/modelling/arima/tramo/TramoSpecification;", "getCore")
  jdictionary <- .jnull("jdr/spec/ts/Utility$Dictionary")
  jrslt<-.jcall("ec/tstoolkit/jdr/regarima/Processor", "Lec/tstoolkit/jdr/regarima/Processor$Results;", "tramo", ts_r2jd(series), jspec, jdictionary)
  jrobct<- new (Class = "JD2_TRAMO_java", internal = jrslt)

  if (is.null(jrobct@internal)){
    return (NaN)
  }else{
    z <- regarima_defTS(jrobj = jrobct, spec = jrspec)
    return(z)
  }
}

# The function creates a "regarima" S3 class object from a JD+ defined specification for X13 method
#' @rdname regarima
#' @name regarima
#' @export
regarimaDefX13 <-function(series, spec = c("RG5c", "RG0", "RG1", "RG2c", "RG3", "RG4c")){
  if (!is.ts(series)){
    stop("series must be a time series")
  }
  spec<-match.arg(spec)

  # create the java objects
  jrspec<-.jcall("jdr/spec/x13/RegArimaSpec", "Ljdr/spec/x13/RegArimaSpec;", "of", spec)
  jspec<-.jcall(jrspec, "Lec/tstoolkit/modelling/arima/x13/RegArimaSpecification;", "getCore")
  jdictionary <- .jnew("jdr/spec/ts/Utility$Dictionary")
  jrslt<-.jcall("ec/tstoolkit/jdr/regarima/Processor", "Lec/tstoolkit/jdr/regarima/Processor$Results;", "x12", ts_r2jd(series), jspec, jdictionary)

  jrobct <- new (Class = "JD2_RegArima_java", internal = jrslt)

  if (is.null(jrobct@internal)){
    return (NaN)
  }else{
    z <- regarima_defX13(jrobj = jrobct, spec = jrspec)
    return(z)
  }
}

regarima_defX13 <- function(jrobj, spec){
  # extract model specification from the java object
  rspec <- specX13_jd2r(spec = spec)

  estimate<-data.frame(span = rspec$estimate.span, tolerance = rspec$estimate.tol, row.names="", stringsAsFactors=FALSE)
  transform <- data.frame(tfunction=rspec$transform.function,adjust=rspec$transform.adjust,aicdiff=rspec$transform.aicdiff, row.names="", stringsAsFactors=FALSE)
  trading.days<-data.frame( option = rspec$tradingdays.option, autoadjust=rspec$tradingdays.autoadjust, leapyear = rspec$tradingdays.leapyear,
                            stocktd = rspec$tradingdays.stocktd, test = rspec$tradingdays.test, row.names="", stringsAsFactors=FALSE)
  easter<-data.frame(enabled=rspec$easter.enabled,julian=rspec$easter.julian,duration=rspec$easter.duration,test=rspec$easter.test, row.names="",stringsAsFactors=FALSE)
  usrdef <- data.frame(outlier=FALSE, outlier.coef= FALSE, variables = FALSE, variables.coef = FALSE, stringsAsFactors=FALSE)
  userdef <-list(specification = usrdef, outliers = NA, variables = list(series = NA, description = NA))
  regression<-list(userdef=userdef, trading.days = trading.days, easter = easter)
  outliers<-data.frame(enabled=rspec$outlier.enabled,span=rspec$outlier.span,ao=rspec$outlier.ao, tc=rspec$outlier.tc, ls = rspec$outlier.ls,
                       so=rspec$outlier.so,usedefcv=rspec$outlier.usedefcv,cv=rspec$outlier.cv,method=rspec$outlier.method,
                       tcrate=rspec$outlier.tcrate, row.names="", stringsAsFactors=FALSE)
  arima.dsc <-data.frame(enabled=rspec$automdl.enabled,automdl.acceptdefault=rspec$automdl.acceptdefault,automdl.cancel=rspec$automdl.cancel,
                         automdl.ub1=rspec$automdl.ub1,automdl.ub2=rspec$automdl.ub2,automdl.mixed=rspec$automdl.mixed,automdl.balanced=rspec$automdl.balanced,
                         automdl.armalimit=rspec$automdl.armalimit,automdl.reducecv=rspec$automdl.reducecv, automdl.ljungboxlimit=rspec$automdl.ljungboxlimit,
                         automdl.ubfinal=rspec$automdl.ubfinal,arima.mu=rspec$arima.mu,arima.p=rspec$arima.p,arima.d =rspec$arima.d,arima.q=rspec$arima.q,
                         arima.bp=rspec$arima.bp,arima.bd=rspec$arima.bd,arima.bq=rspec$arima.bq, arima.coef = FALSE,row.names="",stringsAsFactors=FALSE)
  arima <- list(specification = arima.dsc, coefficients = NA)
  forecast <- data.frame(horizon = c(-2),row.names = c(""), stringsAsFactors=FALSE)
  span <-rspec$span
  # specification
  specification <- list(estimate=estimate, transform=transform, regression=regression, outliers=outliers,
                        arima=arima, forecast = forecast, span=span)
  # results
  jd_results <- regarima_rslts(jrobj,as.numeric(forecast))

  # new S3 class "regarima"
  z<- list( specification = specification,
            arma=jd_results$arma,
            arima.coefficients =jd_results$arima.coefficients,
            regression.coefficients = jd_results$regression.coefficients,
            loglik=jd_results$loglik,
            model=jd_results$model,
            residuals = jd_results$residuals,
            residuals.stat = jd_results$residuals.stat,
            forecast = jd_results$forecast)

  class(z) <- c("regarima","X13")
  return(z)
}

regarima_defTS <- function(jrobj, spec){
  # extract model specification from the java object
  rspec <- specTS_jd2r( spec = spec)

  estimate<-data.frame(span = rspec$estimate.span, tolerance = rspec$estimate.tol, exact_ml = rspec$estimate.eml, urfinal = rspec$estimate.urfinal,
                       row.names = "", stringsAsFactors=FALSE)
  transform <- data.frame(tfunction=rspec$transform.function,fct=rspec$transform.fct,row.names = "", stringsAsFactors=FALSE)
  usrdef <- data.frame(outlier=FALSE, outlier.coef= FALSE, variables = FALSE, variables.coef = FALSE, stringsAsFactors=FALSE)
  userdef <-list(specification = usrdef, outliers = NA, variables = list(series = NA, description = NA))
  trading.days<-data.frame( automatic = rspec$tradingdays.mauto, pftd = rspec$tradingdays.pftd, option = rspec$tradingdays.option,
                            leapyear = rspec$tradingdays.leapyear,stocktd = rspec$tradingdays.stocktd, test = rspec$tradingdays.test,
                            row.names = "", stringsAsFactors=FALSE)
  easter<-data.frame(type=rspec$easter.type,julian=rspec$easter.julian,duration=rspec$easter.duration,test=rspec$easter.test,
                     row.names = "", stringsAsFactors=FALSE)
  regression<-list(userdef = userdef, trading.days = trading.days, easter = easter)
  outliers<-data.frame(enabled=rspec$outlier.enabled,span=rspec$outlier.span,ao=rspec$outlier.ao, tc=rspec$outlier.tc, ls = rspec$outlier.ls,
                       so=rspec$outlier.so,usedefcv=rspec$outlier.usedefcv,cv=rspec$outlier.cv,eml=rspec$outlier.eml,
                       tcrate=rspec$outlier.tcrate, row.names = "", stringsAsFactors=FALSE)
  arima.dsc <-data.frame(enabled=rspec$automdl.enabled,automdl.acceptdefault=rspec$automdl.acceptdefault,automdl.cancel=rspec$automdl.cancel,
                         automdl.ub1=rspec$automdl.ub1,automdl.ub2=rspec$automdl.ub2,automdl.armalimit=rspec$automdl.armalimit,
                         automdl.reducecv=rspec$automdl.reducecv, automdl.ljungboxlimit=rspec$automdl.ljungboxlimit, compare = rspec$automdl.compare,
                         arima.mu=rspec$arima.mu,arima.p=rspec$arima.p,arima.d =rspec$arima.d,arima.q=rspec$arima.q,
                         arima.bp=rspec$arima.bp,arima.bd=rspec$arima.bd,arima.bq=rspec$arima.bq, arima.coef = FALSE,
                         row.names = "", stringsAsFactors=FALSE)
  arima <- list(specification = arima.dsc, coefficients = NA)
  forecast <- data.frame(horizon = c(-2),row.names = c(""), stringsAsFactors=FALSE)
  span <-rspec$span
  # specification
  specification <- list(estimate=estimate, transform=transform, regression=regression, outliers=outliers, arima=arima,
                        forecast = forecast, span=span)

  # results
  jd_results <- regarima_rslts(jrobj,as.numeric(forecast))

  # new S3 class "regarima"
  z<- list( specification = specification,
            arma=jd_results$arma,
            arima.coefficients =jd_results$arima.coefficients,
            regression.coefficients = jd_results$regression.coefficients,
            loglik=jd_results$loglik,
            model=jd_results$model,
            residuals = jd_results$residuals,
            residuals.stat = jd_results$residuals.stat,
            forecast = jd_results$forecast)

  class(z) <- c("regarima","TRAMO_SEATS")
  return(z)
}

regarima_X13 <- function(jrobj, spec){
  # results
  jd_results <- regarima_rslts(jrobj,as.numeric(s_fcst(spec)))
  # import the model specification
  estimate <- s_estimate(spec)
  transform <- s_transform(spec)
  usrdef <- s_usrdef(spec)
  predef.outliers <- s_preOut(spec)
  predef.variables <- s_preVar(spec)
  trading.days <- s_td(spec)
  easter <- s_easter(spec)
  outliers <- s_out(spec)
  arima.dsc <- s_arima(spec)
  predef.coef <- s_arimaCoef(spec)
  span <- s_span(spec)
  userdef <-list(specification = usrdef, outliers = predef.outliers, variables = predef.variables)
  regression <- list(userdef=userdef, trading.days=trading.days, easter = easter)
  arima <- list(specification = arima.dsc, coefficients = predef.coef)
  forecast <- s_fcst(spec)
  # specification
  specification <- list(estimate=estimate, transform=transform, regression=regression,
                        outliers=outliers, arima=arima, forecast = forecast, span=span)
  # new S3 class "regarima"
  z<- list( specification = specification,
            arma=jd_results$arma,
            arima.coefficients =jd_results$arima.coefficients,
            regression.coefficients = jd_results$regression.coefficients,
            loglik=jd_results$loglik,
            model=jd_results$model,
            residuals = jd_results$residuals,
            residuals.stat = jd_results$residuals.stat,
            forecast = jd_results$forecast)

  class(z) = c("regarima","X13")
  return(z)
}

regarima_TS <- function(jrobj, spec){
  # results
  jd_results <- regarima_rslts(jrobj,as.numeric(s_fcst(spec)))
  # import the model specification
  estimate <- s_estimate(spec)
  transform <- s_transform(spec)
  usrdef <- s_usrdef(spec)
  predef.outliers <- s_preOut(spec)
  predef.variables <- s_preVar(spec)
  trading.days <- s_td(spec)
  easter <- s_easter(spec)
  outliers <- s_out(spec)
  arima.dsc <- s_arima(spec)
  predef.coef <- s_arimaCoef(spec)
  span <- s_span(spec)
  userdef <-list(specification = usrdef, outliers = predef.outliers, variables = predef.variables)
  regression <- list(userdef=userdef, trading.days=trading.days, easter = easter)
  arima <- list(specification = arima.dsc, coefficients = predef.coef)
  forecast <- s_fcst(spec)
  # specification
  specification <- list(estimate=estimate, transform=transform, regression=regression,
                        outliers=outliers, arima=arima, forecast = forecast, span=span)
  # new S3 class "regarima"
  z<- list( specification = specification,
            arma=jd_results$arma,
            arima.coefficients =jd_results$arima.coefficients,
            regression.coefficients = jd_results$regression.coefficients,
            loglik=jd_results$loglik,
            model=jd_results$model,
            residuals = jd_results$residuals,
            residuals.stat = jd_results$residuals.stat,
            forecast = jd_results$forecast)

  class(z) = c("regarima","TRAMO_SEATS")
  return(z)
}




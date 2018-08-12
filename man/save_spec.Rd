% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/saveSpec.R
\name{save_spec}
\alias{save_spec}
\alias{save_spec}
\alias{load_spec}
\title{Saving and loading a model specification, SA and pre-adjustment in X13 and TRAMO-SEATS}
\usage{
save_spec(object, file = "spec.RData")

load_spec(file = "spec.RData")
}
\arguments{
\item{object}{object of one of the classes: \code{c("SA_spec","X13")}, \code{c("SA_spec","TRAMO_SEATS")}, \code{c("SA","X13")}, \code{c("SA","TRAMO_SEATS")}, \code{c("regarima_spec","X13")}, \code{c("regarima_spec","TRAMO_SEATS")}, \code{c("regarima","X13")}, \code{c("regarima","TRAMO_SEATS")}.}

\item{file}{(path and) name of the file where the model specification will be saved (have been saved).}
}
\value{
\code{load_spec}  returns an object of class \code{"SA_spec"} or \code{"regarima_spec"}.
}
\description{
\code{save_spec} saves a SA or RegARIMA model specification. \code{load_spec} loads the previously saved model specification.
}
\details{
\code{save_spec} saves the final model specification of a \code{"SA_spec"}, \code{"SA"}, \code{"regarima_spec"} or \code{"regarima"} class object.
\code{load_spec} loads the previously saved model specification. It creates a \code{c("SA_spec","X13")}, \code{c("sA_spec","TRAMO_SEATS")}, \code{c("regarima_spec","X13")} or \code{c("regarima_spec","TRAMO_SEATS")} class object, in line with the class of the previously saved model specification.
}
\examples{
  myreg1 <-regarima_def_x13(myseries, spec=c("RG5c"))
  myspec2 <-regarima_spec_x13(myreg1, estimate.from = "2005-10-01", outlier.from = "2010-03-01")
  myreg2 <-regarima(myseries,myspec2)

  myreg3 <-regarima_def_tramoseats(myseries, spec=c("TRfull"))
  myspec4 <-regarima_spec_tramoseats(myreg3, tradingdays.mauto = "Unused",
                                     tradingdays.option ="WorkingDays",
                                     easter.type = "Standard",
                                     automdl.enabled = FALSE, arima.mu = TRUE)
  myreg4 <-regarima(myseries,myspec4)

  myspec6 <- x13_spec_def("RSA5c")
  mysa6 <- x13(myseries,myspec6)

  myspec7 <- tramoseats_spec_def("RSAfull")
  mysa7 <- tramoseats(myseries,myspec7)

  # Save the model specification from a c("regarima_spec","X13") class object
  save_spec(myspec2,"specx13.RData")
  # Save the model specification from a c("regarima","X13") class object
  save_spec(myreg2,"regx13.RData")
  # Save the model specification from a c("regarima_spec","TRAMO_SEATS") class object
  save_spec(myspec4,"specTS.RData")
  # Save the model specification from a c("regarima","TRAMO_SEATS") class object
  save_spec(myreg4,"regTS.RData")
  # Save model from a c("SA_spec","X13") class object
  save_spec(myspec6,"specFullx13.RData")
  # Save model from a c("SA","X13") class object
  save_spec(mysa6,"sax13.RData")
  # Save model from a c("SA_spec","TRAMO_SEATS") class object
  save_spec(myspec7,"specFullTS.RData")
  # Save model from a c("SA","TRAMO_SEATS") class object
  save_spec(mysa7,"saTS.RData")

  # Load the model specification
  myspec2a <- load_spec("specx13.RData")
  myspec2b <- load_spec("regx13.RData")
  myspec4a <- load_spec("specTS.RData")
  myspec4b <- load_spec("regTS.RData")
  myspec6a <- load_spec("specFullx13.RData")
  myspec6b <- load_spec("sax13.RData")
  myspec7a <- load_spec("specFullTS.RData")
  myspec7b <- load_spec("saTS.RData")

  regarima(myseries,myspec2a)
  regarima(myseries,myspec4a)
  x13(myseries,myspec6a)
  x13(myseries,myspec6b)
  tramoseats(myseries,myspec7a)
  tramoseats(myseries,myspec7b)

}
\references{
Info on JDemtra+, usage and functions:
\url{https://ec.europa.eu/eurostat/cros/content/documentation_en}
}
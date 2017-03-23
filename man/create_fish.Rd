% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/create_fish.R
\name{create_fish}
\alias{create_fish}
\title{create_fish creates a fish list object with all the life history goodies}
\usage{
create_fish(common_name = "white seabass",
  scientific_name = "Atractoscion nobilis", linf = NA, vbk = NA,
  t0 = NA, length_units = "cm", max_age = 20, weight_a = NA,
  weight_b = NA, weight_units = "kg", length_50_mature = NA,
  length_95_mature = NA, age_50_mature = NA, age_95_mature = NA,
  age_mature = NA, length_mature = NA, m = 0.2, steepness = 0.8,
  r0 = 1000, density_dependence_form = "blah", adult_movement = 2,
  larval_movement = 2, query_fishbase = T, lmat_to_linf_ratio = 0.6)
}
\arguments{
\item{r0}{}
}
\value{
a fish list object
}
\description{
create_fish creates a fish list object with all the life history goodies
}
\examples{
white_seabass = create_fish(scientific_name = "Atractoscion nobilis")

}
#' create_fleet
#'
#' @param eq_f
#' @param length_50_sel
#' @param delta cm above length50 at 95 selectivity
#' @param mpa_reaction
#' @param fish
#' @param cost
#' @param beta
#' @param theta
#' @param q
#' @param fleet_model
#' @param effort_allocation
#' @param initial_effort
#' @param cost_function
#' @param cost_slope
#' @param tech_rate
#' @param target_catch
#' @param catches
#' @param sigma_effort
#' @param profit_lags
#' @param theta_tuner
#' @param q_cv
#' @param q_ac
#' @param cost_cv
#' @param cost_ac
#'
#' @return a fleet object
#' @export
#'
#' @examples create_fleet(eq_f = 2,length_50_sel = 25, length_95_sel = 27, fish = bluefish)
create_fleet <- function(eq_f = NA,
                         length_50_sel = 1,
                         delta = 2,
                         fish,
                         mpa_reaction = 'concentrate',
                         cost = .1,
                         beta = 1.3,
                         theta = 1e-1,
                         q = 1e-3,
                         q_cv = 0,
                         q_ac = 0,
                         cost_cv = 0,
                         cost_ac = 0,
                         fleet_model = 'constant-effort',
                         effort_allocation = 'gravity',
                         cost_function = 'constant',
                         cost_slope = 0,
                         tech_rate = 0,
                         initial_effort = 100,
                         target_catch = 0,
                         catches = NA,
                         sigma_effort = 0,
                         profit_lags = 4,
                         theta_tuner = 0.25,
                         oa_ratio = 0.25,
                         mey_buffer = 2,
                         effort_ac = 0) {
  p_selected <- function(mu, sigma, l50, delta) {
    length_dist <- pmax(0, rnorm(1000, mu, sigma))

    sel_dist <-   ((1 / (1 + exp(-log(
      19
    ) * ((length_dist - l50) / (delta)
    )))))

    mean_p_selected <- mean(sel_dist)

  }

  sel_at_age <-
    data_frame(age = seq(fish$min_age, fish$max_age, by = fish$time_step)) %>%
    mutate(mean_length_at_age = fish$length_at_age) %>%
    mutate(sd_at_age = mean_length_at_age * fish$cv_len) %>%
    mutate(
      mean_sel_at_age = map2_dbl(
        mean_length_at_age,
        sd_at_age,
        p_selected,
        l50 = length_50_sel,
        delta = delta
      )
    )


  length_95_sel <- (length_50_sel + delta)

  sel_at_age <-  sel_at_age$mean_sel_at_age

  mey_buffer <- mey_buffer

  rm(fish)

  fleet <- list(mget(ls()))

  fleet <- fleet[[1]]

  return(fleet)
}

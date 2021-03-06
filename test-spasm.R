library(tidyverse)
library(FishLife)
library(spasm)
library(ggridges)

fish <-
  create_fish(
    scientific_name = "Lutjanus campechanus",
    query_fishlife = T,
    mat_mode = "length",
    time_step = 1,
    sigma_r = 0,
    price = 5,
    price_cv = 0,
    price_ac = 0,
    steepness = 0.6,
    r0 = 1000,
    rec_ac = 0,
    density_movement_modifier = 0
  )


fleet <- create_fleet(
  fish = fish,
  cost_cv =  0.25,
  cost_ac = 0.25,
  q_cv = 0,
  q_ac = 0,
  fleet_model = "constant-effort",
  theta = 0.5,
  cost = 2,
  sigma_effort = 0,
  length_50_sel = 0.25 * fish$linf,
  initial_effort = 1000,
  profit_lags =  4,
  beta = 1.3
)

sim_noad <- spasm::sim_fishery(
  fish = fish,
  fleet = fleet,
  manager = create_manager(mpa_size = 0.5),
  num_patches = 10,
  sim_years = 100,
  burn_year = 50,
  time_step = fish$time_step,
  est_msy = F,
  tune_costs = F,
  b_v_bmsy_oa = 0.75,
  random_mpas = F
)


fish <-
  create_fish(
    scientific_name = "Lutjanus campechanus",
    query_fishlife = T,
    mat_mode = "length",
    time_step = 1,
    sigma_r = 0,
    price = 5,
    price_cv = 0,
    price_ac = 0,
    steepness = 0.6,
    r0 = 1000,
    rec_ac = 0,
    density_movement_modifier = 1
  )


fleet <- create_fleet(
  fish = fish,
  cost_cv =  0.25,
  cost_ac = 0.25,
  q_cv = 0,
  q_ac = 0,
  fleet_model = "constant-effort",
  theta = 0.5,
  cost = 2,
  sigma_effort = 0,
  length_50_sel = 0.25 * fish$linf,
  initial_effort = 1000,
  profit_lags =  4,
  beta = 1.3
)

sim_ad <- spasm::sim_fishery(
  fish = fish,
  fleet = fleet,
  manager = create_manager(mpa_size = 0.5),
  num_patches = 10,
  sim_years = 100,
  burn_year = 50,
  time_step = fish$time_step,
  est_msy = F,
  tune_costs = F,
  b_v_bmsy_oa = 0.75,
  random_mpas = F
)

noad <- sim_noad %>%
  group_by(year, patch) %>%
  summarise(b = sum(biomass),
            effort = unique(effort),
            mpa = unique(mpa)) %>%
  mutate(adult_density_effect = "none")

ad <- sim_ad %>%
  group_by(year, patch) %>%
  summarise(b = sum(biomass),
            effort = unique(effort),
            mpa = unique(mpa)) %>%
  mutate(adult_density_effect = "full")


noad %>%
  bind_rows(ad) %>%
  ungroup() %>%
  filter(year > 140) %>%
  ggplot(aes(patch, year, height = b, group =interaction(year,adult_density_effect) , fill = adult_density_effect)) +
  geom_density_ridges(stat = "identity", alpha = 0.5)
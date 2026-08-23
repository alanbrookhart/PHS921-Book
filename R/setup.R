# Shared setup: every chapter sources this file so it can render standalone.
library(tidyverse)
library(NAMCS)

data(ns)   # NSAID cohort: new users of nonselective NSAIDs vs Cox-2 inhibitors
data(sta)  # Statin cohort: initiators vs non-initiators, survival outcomes

ns <- ns |>
  mutate(
    cox2_init = as.integer(cox2_initiation == "Yes"),
    pud       = as.integer(incident_pud == "Yes")
  )

# Baseline confounders used in adjustment models throughout the book
ns_covs <- c(
  "age", "sex", "race", "region", "year",
  "arthritis", "asthma", "cancer", "chronic_kidney_disease",
  "heart_failure", "diabetes", "hypertension",
  "coronory_artery_disease", "osteoporosis",
  "corticosteroid_use", "aspirin_use", "anti_coagulant_use",
  "ppi_use", "h2_antagonist_use"
)

admin_end <- 10  # administrative end of follow-up (years)

sta <- sta |>
  mutate(
    statin     = as.integer(statin_use == "Statin"),
    event_time = pmin(cv_time, death_time, loss_fu_time, admin_end, na.rm = TRUE),
    cv_event   = as.integer(!is.na(cv_time) & cv_time <= event_time)
  )

sta_covs <- c(
  "age", "sex", "race", "region", "year",
  "diabetes", "hypertension", "hyperlipidemia",
  "coronory_artery_disease", "cerebrovascular_disease",
  "chronic_kidney_disease", "heart_failure", "obesity",
  "tobacco_use", "aspirin_use", "anti_hypertensive_use", "mi"
)

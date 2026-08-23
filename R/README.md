# R/

Shared code sourced by the book's chapters. Every chapter's first chunk
runs `source("R/setup.R")`, which supplies the data and the shared
variables; the other files below are sourced, as they are needed, by the
chapters that use them.

- `setup.R` — sourced at the top of every chapter so it can render
  standalone. Loads tidyverse and the NAMCS package, loads the two
  running-example datasets (`ns`, the NSAID cohort; `sta`, the statin
  cohort), derives the analysis variables used throughout the book
  (`ns$cox2_init`, `ns$pud`, `sta$statin`, `sta$event_time`,
  `sta$cv_event`), and defines the baseline confounder vectors
  (`ns_covs`, `sta_covs`) used in adjustment models. This file is the
  single source of truth for these variable lists — if a covariate name
  errors in a later model fit, correct it here.
- `table1.R` — `table1_continuous()` and `table1_categorical()`,
  descriptive "Table 1" helpers, introduced in Chapter 2.
- `standardize.R` — `standardize()`, regression standardization
  (parametric g-formula) for a point treatment, introduced in Chapter 7.
- `propensity.R` — `est_ps()` and `ps_match()`, propensity-score
  estimation and greedy 1:1 nearest-neighbor matching, introduced in
  Chapter 8.
- `iptw_estimator.R` — `iptw_estimator()`, inverse probability of
  treatment weighting for a point treatment, introduced in Chapter 9.
  Calls `est_ps()`, so source `propensity.R` too.
- `km.R` — `plot_km()`, Kaplan-Meier cumulative incidence curves for a
  point treatment, introduced in Chapter 10.
- `ipcw.R` — `make_person_period()` and `ipcw_estimator()`, person-period
  data expansion and inverse probability of censoring weighting,
  introduced in Chapter 11.
- `ccw_estimator.R` — `ccw_estimator()`, clone-censor-weight risk
  curves for sustained treatment strategies, introduced in Chapter 12.
- `iv_estimator.R` — `iv_estimator()`, a two-stage least squares
  instrumental-variable estimator with a bootstrap confidence interval,
  introduced in Chapter 13.
- `sensitivity.R` — `evalue_rr()` and `adjust_rr_unmeasured()`,
  sensitivity analysis for unmeasured confounding, introduced in
  Chapter 14.

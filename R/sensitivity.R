# Sensitivity analysis for unmeasured confounding, Chapter 14.

evalue_rr <- function(rr, conf_low = NULL, conf_high = NULL) {
  ev <- function(x) {
    if (is.na(x)) return(NA_real_)
    if (x < 1) x <- 1 / x
    x + sqrt(x * (x - 1))
  }
  ci_bound <- if (!is.null(conf_low) && !is.null(conf_high)) {
    # E-value for the bound closest to the null
    if (conf_low > 1) conf_low else if (conf_high < 1) conf_high else 1
  } else NA_real_
  tibble(
    quantity = c("point estimate", "confidence limit"),
    value    = c(rr, ci_bound),
    e_value  = c(ev(rr), if (is.na(ci_bound)) NA_real_ else if (ci_bound == 1) 1 else ev(ci_bound))
  )
}

adjust_rr_unmeasured <- function(rr_obs, p_u1, p_u0, rr_ud) {
  rr_obs * (p_u0 * (rr_ud - 1) + 1) / (p_u1 * (rr_ud - 1) + 1)
}

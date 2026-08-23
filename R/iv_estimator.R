# Two-stage least squares IV estimator with bootstrap CI, Chapter 13.
iv_estimator <- function(data, instrument, treat, outcome, covs = NULL,
                         n_boot = 200, conf_level = 0.95, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)

  tsls <- function(d) {
    s1 <- lm(reformulate(c(instrument, covs), treat), data = d)
    d$.that <- predict(s1)
    coef(lm(reformulate(c(".that", covs), outcome), data = d))[".that"]
  }

  est <- tsls(data)
  boot_est <- replicate(n_boot, tsls(slice_sample(data, prop = 1, replace = TRUE)))
  alpha <- 1 - conf_level

  tibble(
    estimate  = unname(est),
    conf_low  = quantile(boot_est, alpha / 2),
    conf_high = quantile(boot_est, 1 - alpha / 2)
  )
}

# Regression standardization (parametric g-formula) for a point treatment.
# Introduced in Chapter 7.
standardize <- function(data, outcome_model, treat, family = binomial(),
                        n_boot = 200, conf_level = 0.95, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)

  point_estimates <- function(d) {
    fit <- glm(outcome_model, family = family, data = d)
    d1 <- d |> mutate("{treat}" := 1)
    d0 <- d |> mutate("{treat}" := 0)
    risk1 <- mean(predict(fit, newdata = d1, type = "response"))
    risk0 <- mean(predict(fit, newdata = d0, type = "response"))
    c(risk0 = risk0, risk1 = risk1, rd = risk1 - risk0, rr = risk1 / risk0)
  }

  est <- point_estimates(data)
  boot_est <- replicate(n_boot, {
    point_estimates(slice_sample(data, prop = 1, replace = TRUE))
  })
  alpha <- 1 - conf_level

  tibble(
    estimand  = names(est),
    estimate  = unname(est),
    conf_low  = apply(boot_est, 1, quantile, probs = alpha / 2),
    conf_high = apply(boot_est, 1, quantile, probs = 1 - alpha / 2)
  )
}

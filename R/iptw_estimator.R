# IPTW estimator for a point treatment, introduced in Chapter 9.
# Modeled on the DPHS921 ipw_estimator: data first, model formulas as
# arguments, robust variance from geepack.
iptw_estimator <- function(data, treat_model, outcome, treat,
                           family = gaussian(), stabilize = TRUE,
                           truncate_at = NULL) {
  data <- est_ps(data, treat_model)
  p_treat <- mean(data[[treat]])

  data <- data |>
    mutate(
      wt = if_else(.data[[treat]] == 1, 1 / ps, 1 / (1 - ps)),
      wt = if (stabilize) {
        if_else(.data[[treat]] == 1, p_treat * wt, (1 - p_treat) * wt)
      } else wt
    )

  if (!is.null(truncate_at)) {
    data <- data |> mutate(wt = pmin(wt, quantile(wt, truncate_at)))
  }

  fit <- geepack::geeglm(
    reformulate(treat, outcome),
    id = seq_len(nrow(data)), weights = data$wt,
    family = family, data = data
  )
  broom::tidy(fit, conf.int = TRUE)
}

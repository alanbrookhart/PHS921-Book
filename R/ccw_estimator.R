# Clone-censor-weight risk curves, introduced in Chapter 12.
# pp_data: person-period data with per-interval `event` and `deviated`
# indicators; censor_model models deviation from the assigned strategy.
ccw_estimator <- function(pp_data, censor_model, treat, id = ".row_id",
                          numerator_model = NULL, truncate_at = 0.99) {
  dev_fit <- glm(censor_model, family = binomial(), data = pp_data)
  pp_data <- pp_data |> mutate(p_stay = 1 - predict(dev_fit, type = "response"))

  if (!is.null(numerator_model)) {
    num_fit <- glm(numerator_model, family = binomial(), data = pp_data)
    pp_data <- pp_data |> mutate(p_stay_num = 1 - predict(num_fit, type = "response"))
  } else {
    pp_data <- pp_data |> mutate(p_stay_num = 1)
  }

  pp_data <- pp_data |>
    group_by(.data[[id]]) |>
    arrange(tstop, .by_group = TRUE) |>
    mutate(w = cumprod(p_stay_num) / cumprod(p_stay)) |>
    ungroup() |>
    mutate(w = pmin(w, quantile(w, truncate_at)))

  # A patient's last row is a stub ending at her exact follow-up time, so raw
  # `tstop` is continuous; hazards are pooled over the interval it falls in.
  pp_data |>
    mutate(interval = ceiling(tstop)) |>
    group_by(.data[[treat]], interval) |>
    summarise(hazard = weighted.mean(event, w), .groups = "drop_last") |>
    arrange(interval, .by_group = TRUE) |>
    mutate(surv = cumprod(1 - hazard), risk = 1 - surv) |>
    ungroup() |>
    rename(tstop = interval)
}

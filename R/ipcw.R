# Person-period expansion and IPCW, introduced in Chapter 11.

make_person_period <- function(data, time, event, cuts) {
  data <- data |> mutate(.row_id = dplyr::row_number())
  survival::survSplit(
    as.formula(paste0("Surv(", time, ", ", event, ") ~ .")),
    data = data, cut = cuts, start = "tstart", end = "tstop",
    event = event
  ) |> as_tibble()
}

ipcw_estimator <- function(pp_data, censor_model, outcome_formula,
                           id = ".row_id", numerator_model = NULL,
                           truncate_at = 0.99) {
  cens_fit <- glm(censor_model, family = binomial(), data = pp_data)
  pp_data <- pp_data |> mutate(p_uncens = 1 - predict(cens_fit, type = "response"))

  if (!is.null(numerator_model)) {
    num_fit <- glm(numerator_model, family = binomial(), data = pp_data)
    pp_data <- pp_data |> mutate(p_uncens_num = 1 - predict(num_fit, type = "response"))
  } else {
    pp_data <- pp_data |> mutate(p_uncens_num = 1)
  }

  pp_data <- pp_data |>
    group_by(.data[[id]]) |>
    arrange(tstop, .by_group = TRUE) |>
    mutate(w_cens = cumprod(p_uncens_num) / cumprod(p_uncens)) |>
    ungroup() |>
    mutate(w_cens = pmin(w_cens, quantile(w_cens, truncate_at)))

  # geeglm() looks up `id` and `weights` in the environment of the formula it
  # is handed; ours was built by the caller, so re-home it here.
  environment(outcome_formula) <- environment()

  fit <- geepack::geeglm(
    outcome_formula, id = pp_data[[id]], weights = pp_data$w_cens,
    family = binomial(), data = pp_data
  )
  list(fit = broom::tidy(fit, conf.int = TRUE), data = pp_data)
}

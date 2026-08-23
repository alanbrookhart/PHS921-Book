# Propensity-score tools, introduced in Chapter 8.

est_ps <- function(data, treat_model) {
  fit <- glm(treat_model, family = binomial(), data = data)
  data |> mutate(ps = predict(fit, type = "response"))
}

# Greedy 1:1 nearest-neighbor matching without replacement.
ps_match <- function(data, treat, ps = "ps", caliper = 0.05) {
  treated <- data |> filter(.data[[treat]] == 1) |> arrange(desc(.data[[ps]]))
  controls <- data |> filter(.data[[treat]] == 0)
  used <- rep(FALSE, nrow(controls))
  pairs <- vector("list", nrow(treated))
  for (i in seq_len(nrow(treated))) {
    dist <- abs(controls[[ps]] - treated[[ps]][i])
    dist[used] <- Inf
    j <- which.min(dist)
    if (dist[j] <= caliper) {
      used[j] <- TRUE
      pairs[[i]] <- bind_rows(treated[i, ], controls[j, ])
    }
  }
  bind_rows(pairs, .id = "pair_id")
}

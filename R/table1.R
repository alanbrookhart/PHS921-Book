# Descriptive "Table 1" helpers, introduced in Chapter 2.

table1_continuous <- function(data, vars, by) {
  data |>
    select(all_of(c(by, vars))) |>
    pivot_longer(all_of(vars), names_to = "variable") |>
    group_by(.data[[by]], variable) |>
    summarise(
      stat = sprintf("%.1f (%.1f)",
                     mean(value, na.rm = TRUE), sd(value, na.rm = TRUE)),
      .groups = "drop"
    ) |>
    pivot_wider(names_from = all_of(by), values_from = stat)
}

table1_categorical <- function(data, vars, by) {
  data |>
    select(all_of(c(by, vars))) |>
    mutate(across(all_of(vars), as.character)) |>
    pivot_longer(all_of(vars), names_to = "variable", values_to = "level") |>
    count(.data[[by]], variable, level) |>
    group_by(.data[[by]], variable) |>
    mutate(stat = sprintf("%d (%.1f%%)", n, 100 * n / sum(n))) |>
    ungroup() |>
    select(-n) |>
    pivot_wider(names_from = all_of(by), values_from = stat)
}

# Kaplan-Meier risk curves for a point treatment, introduced in Chapter 10.
# Tidies a survfit into cumulative incidence and plots it by arm; `wt` names a
# column of weights, so a weighted Kaplan-Meier can be drawn the same way.
plot_km <- function(data, treat, time = "event_time", event = "cv_event",
                    wt = NULL, labels = NULL) {
  form <- reformulate(treat, sprintf("Surv(%s, %s)", time, event))
  fit  <- survfit(form, data = data,
                  weights = if (!is.null(wt)) data[[wt]])
  curves <- broom::tidy(fit) |>
    mutate(arm  = str_remove(strata, ".*="),
           arm  = if (is.null(labels)) arm else unname(labels[arm]),
           risk = 1 - estimate)
  ggplot(curves, aes(time, risk, colour = arm, fill = arm)) +
    geom_ribbon(aes(ymin = 1 - conf.high, ymax = 1 - conf.low),
                alpha = 0.15, colour = NA) +
    geom_step() +
    scale_y_continuous(labels = scales::percent) +
    labs(x = "Years since time zero", y = "Cumulative incidence of CV event",
         colour = NULL, fill = NULL) +
    theme_minimal()
}

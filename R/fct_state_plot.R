#' state_plot 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
state_plot <- function(plot_data, n_states) {
  ggplot2::ggplot(plot_data, ggplot2::aes(x = date)) +
    ggplot2::geom_rect(
      data = plot_data %>% dplyr::filter(!is.na(dplyr::lead(date))),
      ggplot2::aes(
        xmin = date,
        xmax = dplyr::lead(date),
        ymin = -Inf,
        ymax = Inf,
        fill = state
      ),
      alpha = 0.3
    ) +
    ggplot2::geom_line(
      ggplot2::aes(y = index),
      color = "blue",
      size = 1
    ) +
    ggplot2::geom_hline(
      yintercept = c(-0.5, 0.5),
      linetype = "dashed",
      color = "gray"
    ) +
    ggplot2::scale_fill_manual(
      values = scales::hue_pal()(n_states),
      name = "HMM State"
    ) +
    ggplot2::scale_x_date(date_breaks = "1 year", date_labels = "%Y") +
    ggplot2::labs(
      title = paste(n_states, "State Index from User Data"),
      x = "Date",
      y = "Index"
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      legend.position = "bottom",
      axis.text.x = ggplot2::element_text(angle = 90)
    )
}
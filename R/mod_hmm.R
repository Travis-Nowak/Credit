#' hmm UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_hmm_ui <- function(id) {
  ns <- NS(id)
  tagList(
    shiny::h3("Hidden Markov Model Analysis"),
    shiny::p("We will build a model from your selected data"),
    shiny::numericInput(
      inputId = ns("num_states"),
      label = "Number of States:",
      value = 2,
      min = 2,
      step = 1
    ),
    shiny::radioButtons(
      inputId = ns("scaling_type"),
      label = "Summary Table Scaling:",
      choices = c("Raw" = "raw", "Normalized" = "normalized"),
      selected = "normalized",
      inline = TRUE
    ),
    shiny::actionButton(
      inputId = ns("fit_hmm"),
      label = "Run HMM Model"
    ),
    shiny::br(), shiny::br(),
    shiny::verbatimTextOutput(ns("hmm_summary")),
    shiny::plotOutput(ns("state_plot"))
  )
}

#' hmm Server Functions
#'
#' @noRd 
mod_hmm_server <- function(id, r) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    rv <- reactiveValues(
      summary_raw = NULL,
      summary_std = NULL,
      plot_data = NULL
    )

    output$hmm_summary <- renderPrint({ })
    output$state_plot <- renderPlot({ })

    observeEvent(input$fit_hmm, {
      req(r$stored_data)
      
      # Helper for data cleaning (works w/ FRED only atm)
      processed_data <- process_data(r$stored_data)

      cleaned_data <- processed_data$cleaned_data
      standardized_data <- processed_data$standardized_data
      
      formula_list <- lapply(names(standardized_data)[-1], function(var) {
        as.formula(paste(var, "~ 1"))
      })
      
      n_states <- input$num_states
      
      # Helper function for fitting hmm; maybe let user choose own seed for replication?
      hmm_fit_result <- fit_hmm(standardized_data, n_states = n_states, seed = 123)
      standardized_data <- hmm_fit_result$data
      
      raw_data_with_state <- cleaned_data
      raw_data_with_state$state <- standardized_data$state
      
      summary_raw <- raw_data_with_state %>%
        dplyr::group_by(state) %>%
        dplyr::summarise(dplyr::across(where(is.numeric), mean, .names = "mean_{.col}"))
      
      summary_std <- standardized_data %>%
        dplyr::group_by(state) %>%
        dplyr::summarise(dplyr::across(where(is.numeric), mean, .names = "mean_{.col}"))
      
      rv$summary_raw <- summary_raw
      rv$summary_std <- summary_std
      
      graph_state_means <- summary_std %>% dplyr::select(-state)
      state_means_for_graph <- scale(graph_state_means) %>% as.data.frame()
      
      dist_matrix <- dist(state_means_for_graph)
      mds_coords <- cmdscale(dist_matrix, k = 1)
      mds_scaled <- scales::rescale(mds_coords, to = c(-1, 1))
      weights <- mds_scaled
      names(weights) <- summary_std$state
      
      standardized_data$index <- weights[as.character(standardized_data$state)]
      
      rv$plot_data <- standardized_data
      
      output$hmm_summary <- renderPrint({
        if (input$scaling_type == "normalized") {
          print(knitr::kable(rv$summary_std, digits = 2))
        } else {
          print(knitr::kable(rv$summary_raw, digits = 2))
        }
      })
      
      output$state_plot <- renderPlot({
        ggplot2::ggplot(rv$plot_data, ggplot2::aes(x = date)) +
          ggplot2::geom_rect(
            data = rv$plot_data %>% dplyr::filter(!is.na(dplyr::lead(date))),
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
      })
    })
  })
}

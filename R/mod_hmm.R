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
      req(!is.null(r$stored_data) && length(r$stored_data) > 0)
      
      result <- run_hmm(
        stored_data = r$stored_data,
        n_states = input$num_states,
        seed = 123
      )
      
      rv$summary_raw <- result$summary_raw
      rv$summary_std <- result$summary_std
      rv$plot_data <- result$plot_data
      rv$fit_model <- result$fit_model 
      
      output$hmm_summary <- renderPrint({
        if (input$scaling_type == "normalized") {
          print(knitr::kable(rv$summary_std, digits = 2))
        } else {
          print(knitr::kable(rv$summary_raw, digits = 2))
        }
      })
      
      output$state_plot <- renderPlot({
        state_plot(rv$plot_data, input$num_states)
      })
    })
  })
}

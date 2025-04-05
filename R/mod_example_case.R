#' example_case UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_example_case_ui <- function(id) {
  ns <- NS(id)
  tagList(
    h2("Example Credit Regime Case"),
    p("Click below to automatically model the credit cycle using: VIXCLS, AAA, and TEDRATE."),
    
    shiny::actionButton(ns("load_example"), "Run Example Model"),
    shiny::radioButtons(
      inputId = ns("scaling_type"),
      label = "Summary Table Scaling:",
      choices = c("Raw" = "raw", "Normalized" = "normalized"),
      selected = "normalized",
      inline = TRUE
    ),
    shiny::br(), shiny::br(),
    shiny::verbatimTextOutput(ns("summary_output")),
    shiny::plotOutput(ns("example_plot"))
  )
}

    
#' example_case Server Functions
#'
#' @noRd 
mod_example_case_server <- function(id, r){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    rv <- reactiveValues(
      summary_raw = NULL,
      summary_std = NULL,
      plot_data = NULL
    )
    
    observeEvent(input$load_example, {
      req(r$user_key)
      fredr::fredr_set_key(r$user_key)
      
      series_ids <- c("VIXCLS", "AAA", "TEDRATE")

        example_data <- lapply(series_ids, function(series_id) {
          df <- fredr::fredr(
            series_id = series_id,
            observation_start = as.Date("1990-01-01")
          ) %>% tidyr::drop_na()
          names(df)[names(df) == "value"] <- paste0("value_", series_id)
          df[[paste0("series_id_", series_id)]] <- series_id
          df
        })
        names(example_data) <- series_ids
        
        # Store example only temporarily (not in r$stored_data to avoid polluting Data tab)
        result <- run_model_pipeline(example_data, n_states = 4)
        
        state_map <- c(
          "1" = "Stressed",
          "2" = "Accommodative",
          "3" = "Loose",
          "4" = "Cautious"
        )
        
        result$summary_raw$state <- factor(state_map[as.character(result$summary_raw$state)],
                                           levels = unique(state_map))
        result$summary_std$state <- factor(state_map[as.character(result$summary_std$state)],
                                           levels = unique(state_map))
        result$plot_data$state <- factor(state_map[as.character(result$plot_data$state)],
                                         levels = unique(state_map))
        
        rv$summary_raw <- result$summary_raw
        rv$summary_std <- result$summary_std
        rv$plot_data <- result$plot_data

    })
    
    output$summary_output <- renderPrint({
      req(rv$summary_raw, rv$summary_std)
      if (input$scaling_type == "normalized") {
        print(knitr::kable(rv$summary_std, digits = 2))
      } else {
        print(knitr::kable(rv$summary_raw, digits = 2))
      }
    })
    
    output$example_plot <- renderPlot({
      req(rv$plot_data)
      generate_state_plot(rv$plot_data, n_states = 4)
    })
  })
}

    
## To be copied in the UI
# mod_example_case_ui("example_case_1")
    
## To be copied in the server
# mod_example_case_server("example_case_1")

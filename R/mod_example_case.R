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
    p("Click below to automatically model the credit cycle using: VIXCLS, AAA, and TEDRATE. Ensure you have input your API key in the Data tab."),
    
    shiny::actionButton(ns("load_example"), "Run Example Model"),
        shiny::hr(),
    shiny::h4("How to Read the Summary Table"),
    shiny::p("The table below shows the average value of each indicator within each inferred regime. These averages reveal how each regime behaves in terms of credit volatility and cost."),
    shiny::tags$ul(
      shiny::tags$li(shiny::strong("Stressed:"), " Highest VIX values and elevated AAA bond yields. This regime corresponds to periods of financial turmoil and widespread risk aversion."),
      shiny::tags$li(shiny::strong("Accommodative:"), " VIX remains elevated but bond yields are low. This typically follows stress events and aligns with aggressive monetary easing amid ongoing uncertainty — such as post-crisis QE periods."),
      shiny::tags$li(shiny::strong("Loose:"), " Low volatility and relatively low credit spreads. This regime reflects times of strong investor confidence and easy financial conditions."),
      shiny::tags$li(shiny::strong("Cautious:"), " A transitional regime — VIX is low but AAA yields are climbing. This represents late-cycle tightening or pre-stress conditions.")
    ),
    shiny::p("These patterns help explain how the model classifies hidden states, and how different credit regimes affect the joint behavior of volatility and interest rates."),
    

    shiny::radioButtons(
      inputId = ns("scaling_type"),
      label = "Summary Table Scaling:",
      choices = c("Raw" = "raw", "Normalized" = "normalized"),
      selected = "normalized",
      inline = TRUE
    ),
    
    shiny::verbatimTextOutput(ns("summary_output")),
    
    shiny::hr(),
    shiny::h4("How to Interpret the Credit Regime Chart"),
    shiny::p("This chart visualizes a one-dimensional index created by a Hidden Markov Model (HMM) trained on three credit indicators: VIX (volatility), AAA bond yields (credit cost), and the TED spread (liquidity stress)."),
    shiny::p("Each colored background band represents a latent regime — a state that the model infers based on patterns across all three indicators. The blue line shows the model’s scaled credit index over time, ranging from -1 (easiest credit) to +1 (most stressed)."),
    shiny::tags$ul(
      shiny::tags$li(shiny::strong("Loose:"), " A regime with low credit spreads, low volatility, and generally strong liquidity."),
      shiny::tags$li(shiny::strong("Accommodative:"), " Intermediate state where conditions are not ultra-loose but still relatively easy."),
      shiny::tags$li(shiny::strong("Cautious:"), " Reflects early signs of stress, rising yields, or volatility without full-blown crisis."),
      shiny::tags$li(shiny::strong("Stressed:"), " Regimes historically aligned with market dislocations — e.g., late 2008 or March 2020.")
    ),
    shiny::p("This model does not predict specific events but shows when the underlying indicators jointly signal a shift in credit conditions. The closer the index is to +1, the tighter or more fragile credit markets are likely to be."),
    
    shiny::br(), shiny::br(),
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
      
      # Build and name example_data properly
      example_data <- list()
      for (series_id in series_ids) {
        df <- fredr::fredr(
          series_id = series_id,
          observation_start = as.Date("1990-01-01")
        ) %>%
          tidyr::drop_na() %>%
          dplyr::rename(!!paste0("value_", series_id) := value) %>%
          dplyr::mutate(!!paste0("series_id_", series_id) := series_id)
        
        example_data[[series_id]] <- df
      }
      
      # Assign to global reactiveValues
      r$stored_data <- example_data
      
      # Use same model pipeline as in mod_hmm.R
      result <- run_hmm(r$stored_data, n_states = 4)
      
      # Map state labels
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
      
      # Save to local rv
      rv$summary_raw <- result$summary_raw
      rv$summary_std <- result$summary_std
      rv$plot_data <- result$plot_data
    })
    
    output$summary_output <- renderPrint({
      req(rv$summary_raw, rv$summary_std)
      
      if (input$scaling_type == "normalized") {
        tbl <- rv$summary_std
      } else {
        tbl <- rv$summary_raw
      }
      
      colnames(tbl) <- c("State", "VIXCLS", "AAA", "TEDRATE")
      
      print(knitr::kable(tbl, digits = 2))
    })
    
    
    output$example_plot <- renderPlot({
      req(rv$plot_data)
      state_plot(rv$plot_data, n_states = 4)
    })
  })
}

    
## To be copied in the UI
# mod_example_case_ui("example_case_1")
    
## To be copied in the server
# mod_example_case_server("example_case_1")

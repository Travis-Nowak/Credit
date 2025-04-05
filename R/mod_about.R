#' about UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_about_ui <- function(id) {
  ns <- NS(id)
  fluidPage(
    div(style = "position: relative;",
        h2(tags$u("Hidden Markov Models")),
        p("The purpose of this application is to allow users to model and analyze regime shifts throughout time using FRED data."),
        
        h3("Features"),
        div(style = "overflow: hidden;",
            tags$ul(
              tags$li("Cycle Index: Identify periods of expansion, contraction, and crisis using HMM-based regime detection."),
              tags$li("Dynamic Data Integration: Automatically process and standardize FRED time series to compare key market indicators."),
              tags$li("Interactive Visualization: View a regime index that ranges from -1 to +1, indicating shifts in market conditions over time."),
              tags$li("Modular Analysis: Easily switch between raw and normalized summaries to inspect state-level averages.")
            )
        )
    ),
    
    h4("Regime Detection and Analysis"),
    p("Using a Hidden Markov Model, the app identifies latent regimes in the examined data based on selected FRED indicators. These regimes are then translated into a cycle index that provides a quantitative measure of market conditions, ranging from -1 to +1."),
    
    h4("Interactive Visualization"),
    p("Users can toggle between raw and normalized summary tables, adjust model parameters, and view the evolution of the cycle index over time. This dynamic visualization aids in understanding how current market conditions compare with historical regimes."),
    
    div(style = "bottom: 0; width: 100%; text-align: center; padding: 10px;",
        HTML(
          '<a href="https://www.linkedin.com/in/travis-nowak-072010147/" target="_blank" text-decoration: none;">Travis Nowak</a>')
    )
  )
}
    
#' about Server Functions
#'
#' @noRd 
mod_about_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_about_ui("about_1")
    
## To be copied in the server
# mod_about_server("about_1")


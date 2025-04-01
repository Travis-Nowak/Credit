#' methodology UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_methodology_ui <- function(id) {
  ns <- NS(id)
  bslib::page_fluid(
    div(style = "overflow: hidden;",
        h2(tags$u("Under the Hood")),
        p("For users seeking a deeper understanding, this section details the data sources, modeling approach, and logic driving the regime-detection index.")
    ),
    
    bslib::accordion(
      open = FALSE,
      
      bslib::accordion_panel(title = "Data Preparation",
                             p("All data is sourced through the Federal Reserve Economic Data (FRED) API. Users can input time series such as interest rates, spreads, volatility indices, or economic indicators."),
                             p("Each time series is merged by date and cleaned. The underlying values are optionally standardized into z-scores to ensure comparability across different scales, particularly for modeling purposes."),
                             p("The app automatically renames and aligns the series for seamless integration into the Hidden Markov Model (HMM) engine.")
      ),
      
      bslib::accordion_panel(title = "Hidden Markov Model Fitting",
                             p("The Hidden Markov Model identifies latent regimes in the data. It assumes that the observed indicators are influenced by an unobservable (hidden) state, which evolves over time."),
                             p("Each observable variable is modeled as a Gaussian distribution, conditional on the hidden state. The user can define the number of states they wish the model to consider (e.g., 2 = Expansion and Recession; 3 = Expansion, Contraction, Crisis, etc.)."),
                             p("The HMM is fitted using the Expectation-Maximization (EM) algorithm via the 'depmixS4' package. The output includes estimated state probabilities over time and regime-switching parameters.")
      ),
      
      bslib::accordion_panel(title = "Credit Cycle Index",
                             p("Once the model is fit, each time period is assigned a most-likely hidden state. For each state, the average (mean) value of each input indicator is calculated."),
                             p("These state-level means are used to compute a 1-dimensional distance metric (via classical multidimensional scaling, or MDS), allowing us to map regimes along a -1 to +1 index."),
                             p("Regimes that are statistically similar cluster near each other, while those that are dissimilar (e.g., stress/crisis vs. expansion) lie at opposite ends of the spectrum."),
                             p("This approach ensures that the index is driven by all input indicators collectively — not just one dominant variable.")
      ),
      
      bslib::accordion_panel(title = "Summary Table & Interpretation",
                             p("Users can toggle between viewing raw averages or standardized z-scores for each hidden state."),
                             p("The standardized (normalized) table is particularly useful for interpreting how each indicator deviates from its own historical mean across states."),
                             p("For example, a high VIX and wide TED spread would show high z-scores in crisis regimes, and negative z-scores in expansion regimes."),
                             p("These tables are updated dynamically, and may be re-calculated for new inputs by re-running the model.")
      )
    )
  )
}
  
    
#' methodology Server Functions
#'
#' @noRd 
mod_methodology_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_methodology_ui("methodology_1")
    
## To be copied in the server
# mod_methodology_server("methodology_1")

#' random UI Function
#'
#' @description A shiny Module that displays three random shinipsum outputs:  a DT, a plot, and text.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_random_ui <- function(id) {
  ns <- NS(id)  # Namespacing function
  tagList(
    h2("A Random DT"),
    DT::DTOutput(ns("data_table")),
    
    h2("A Random Plot"),
    plotOutput(ns("plot")),
    
    h2("A Random Text"),
    tableOutput(ns("text"))
  )
}
    
#' random Server Functions
#'
#' @noRd 
mod_random_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    # Render the random DT
    output$data_table <- DT::renderDT({
      shinipsum::random_DT(5, 5)
    })
    
    # Render the random ggplot
    output$plot <- renderPlot({
      shinipsum::random_ggplot()
    })
    
    # Render the random text
    output$text <- renderText({
      shinipsum::random_text(nwords = 50)
    })
  })
}
    
## To be copied in the UI
# mod_random_ui("random_1")
    
## To be copied in the server
# mod_random_server("random_1")

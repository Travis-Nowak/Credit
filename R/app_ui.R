#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import DT
#' @import ggplot2
#' @importFrom bslib bs_theme font_google
#' @noRd

app_ui <- function(request) {
  shiny::fluidPage(
    shiny::titlePanel("Markov Switching App"),
    
    shiny::tabsetPanel(
      type = "tabs",
      shiny::tabPanel("About", mod_about_ui("my_about")),
      shiny::tabPanel("Methodology", mod_methodology_ui("my_methodology")),
      shiny::tabPanel("Data",
                      
                      sidebarLayout(
                        sidebarPanel(
                          mod_fred_key_ui("fred_key_module"),
                          mod_seriesid_ui("seriesid_module"),
                          mod_list_data_ui("list_data_module"),
                          width = 4
                        ),
                        mainPanel(
                          mod_plot_data_ui("plot_module"),
                          width = 8
                        )
                      )
      ),
      shiny::tabPanel("Model", mod_hmm_ui("my_model")),
      shiny::tabPanel("Example Case", mod_example_case_ui("example_case_1"))
    )
  )
}


#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "Credit"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}

#' Primero cargamos las librerías
library(shiny)
library(tidyverse)
library(leaflet)
library(sf)
library(sp)

#' Interfaz de usuario
ui <- fluidPage(
  titlePanel("Creación de Aplicación con Shiny"), # colocamos un título
  sidebarLayout(                                  # se agrega el espacio de trabajo
    sidebarPanel(
      fileInput("archivo", "Ingresar CSV Aqui",   # se cargará un archivo csv
                multiple = FALSE,
                accept = c("text/csv","text/comma-separated-values,text/plain",".csv")
      ),
      tags$hr(),
      h5(helpText("Seleccione los parametros:")),
      checkboxInput(inputId = 'header', 'Header', T),
      checkboxInput(inputId = "stringAsFactors", "stringAsFactors", T),
      br(),
      radioButtons("sep", "Separador",
                   choices = c(Coma = ",",
                               puntoyComa = ";",
                               Tab = "\t",
                               espacio=''),
                   selected = ","),
      radioButtons("quote", "Cita",
                   choices = c(Ninguna = "",
                               "cita doble" = '"',
                               "cita simple" = "'"),
                   selected = '"')
      
    ),
    mainPanel(uiOutput("tb"))
  )
)

server <- function(input,output){
  data <- reactive({
    file <- input$archivo
    if(is.null(file)){return()} 
    read.table(file=file$datapath,
               sep=input$sep,
               header = input$header,
               stringsAsFactors = input$stringAsFactors)
  })
  output$filedf <- renderTable({
    if(is.null(data())){return ()}
    input$archivo
  })
  output$sum <- renderTable({
    if(is.null(data())){return ()}
    summary(data())
  })
  output$table <- renderTable({
    if(is.null(data())){return ()}
    data()
  })
  
  
  output$plot <- renderPlot({
    df <- read.csv(input$archivo$datapath,
                   header = input$header,
                   sep = input$sep,
                   quote = input$quote)
    sf <- st_as_sf(df,coords = c("Longitude", "Latitude"),         # se transforma el archivo en un objeto sf
                   crs= "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")
    plot(sf)
    
  })
  
  output$map<- renderLeaflet({
    df <- read.csv(input$archivo$datapath,
                   header = input$header,
                   sep = input$sep,
                   quote = input$quote)
    mapa<-leaflet() %>% 
      addCircles(data = df, lat = df$Latitude, lng = df$Longitude)%>%
      addTiles()
  })
  output$tb <- renderUI({
    if(is.null(data()))
      h5("desarrollado con", tags$img(src='RStudio-Ball.png', heigth=200, width=200))
    else
      tabsetPanel(tabPanel("Nombre del archivo", tableOutput("filedf")),
                  tabPanel("Data", tableOutput("table")),
                  tabPanel("Resumen", tableOutput("sum")),
                  tabPanel("Mapa", leafletOutput("map")),
                  tabPanel("Objeto espacial", plotOutput("plot"))
      )
  })
  
}


shinyApp(ui = ui, server = server)
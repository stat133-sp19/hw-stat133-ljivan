
library(shiny)
library(ggplot2)
library(rsconnect)
ui <- fluidPage(
  
  titlePanel("Savings Simulations"),
  fluidRow(
    column(width = 3,
           sliderInput("initial",
                       "Initial Amount:",
                       min = 0, 
                       max = 100000,
                       value = 1000,
                       step = 500, 
                       pre = "$"
           ),
           sliderInput("contrib",
                       "Annual Contribution:",
                       min = 0,
                       max = 50000,
                       value = 2000,
                       step = 500,
                       pre = "$")
    ),
    column( width = 3, 
            
            sliderInput( "return",
                         "Return Rate(in %):",
                         min = 0, 
                         max = 20,
                         value = 5,
                         step = 0.1
    ),
            sliderInput("growth",
                        "Growth Rate (in %):",
                        min = 0,
                        max = 20,
                        value = 2,
                        step = 0.1)
    ),
    column(width = 3, 
           sliderInput("years",
                       "Years:",
                       min = 0, 
                       max = 50,
                       value = 20,
                       step =1
           ),
           selectInput("facet",
                       "Facet?",
                       c("No","Yes"))
    )),
  
  hr(),
  
  h1("Timelines"),
  
  plotOutput("timeline"),
  
  h2("Balances"),
  
  tableOutput("balance")
  
)

#' @title future value
#' @description computes the future value of an investment
#' @param amount initial invested amount
#' @param rate annual rate of reurn
#' @param years number of years
#' @return computed future value
future_value <- function(amount,rate,years){
  return( amount*(1+rate)^years)
}

#' @title future value of Annuity
#' @description computes the future value of Annuity of an investment
#' @param contrib  invested amount at the end of the year
#' @param rate annual rate of reurn
#' @param years number of years
#' @return computed future value of Annuity

annuity <- function(contrib, rate, years){
  FVA <- ((1+rate)^years-1)*contrib/rate
  return( FVA)
}

#' @title future value of Growing Annuity
#' @description computes the future value of Growing Annuity of an investment
#' @param contrib  contributed amount at the end of the year
#' @param rate annual rate of reurn
#' @param years number of years
#' @param growth annual growth rate
#' @return computed future value of growing Annuity
growing_annuity <- function(contrib, rate, growth,years) {
  FVGA <- ((1 + rate)^years-(1 + growth)^years)*contrib/(rate - growth)
  return(FVGA)
}

server <- function(input, output) {
  
  dat <- reactive({
    year = input$years
    no_contrib <- rep(0, year )
    fixed_contrib <- rep(0, year )
    growing_contrib <- rep(0, year )
    for(i in 0:year){
      year <- 0:year
      no_contrib[i] = future_value(input$initial,input$return/100,i)
      fixed_contrib[i] = future_value(input$initial,input$return/100,i) + annuity(input$contrib,input$return/100,i)
      growing_contrib[i] = future_value(input$initial,input$return/100,i) + growing_annuity(input$contrib,input$return/100,input$growth/100,i)
    }
    no_contrib = c(1000, no_contrib)
    fixed_contrib = c(1000, fixed_contrib)
    growing_contrib = c(1000, growing_contrib)

    dat <- data.frame(
      year = rep(c(0: input$years),3),
      types = c(no_contrib,fixed_contrib,growing_contrib),
      group = rep(c("no_contrib","fixed_contrib","growing_contrib"),each = input$years+1)
    )
    
    return(dat)
  })
  
  bal <- reactive({
    year = input$years
    no_contrib <- rep(0, year)
    fixed_contrib <- rep(0, year)
    growing_contrib <- rep(0, year)
    for(i in 0:year){
      no_contrib[i] = future_value(input$initial,input$return/100,i)
      fixed_contrib[i] = future_value(input$initial,input$return/100,i) + annuity(input$contrib,input$return/100,i)
      growing_contrib[i] = future_value(input$initial,input$return/100,i) + growing_annuity(input$contrib,input$return/100,input$growth/100,i)
    
    }
    no_contrib = c(1000, no_contrib)
    fixed_contrib = c(1000, fixed_contrib)
    growing_contrib = c(1000, growing_contrib)
    
    bal <- data.frame(
      year = 0: input$years,
      no_contrib,
      fixed_contrib,
      growing_contrib)
    
     return(bal)
  })
  
  output$timeline <- renderPlot({
    if(input$facet == "No"){
      ggplot(data = dat(), aes(x=year,y=types,goup = group,color = group)) +
        geom_line()+
        geom_point()+
        ggtitle('Timeline Graph')+
        #scale_colour_manual("",values=c('no_contrib' = "red",'fixed_contrib' = "blue",'growing_contrib' = "green"))+
        xlab('Year')+
        ylab('Future Value')+

        theme_minimal() 
      }  else(ggplot(data = dat(),aes(year,types,color = group))+
           geom_line()+
           geom_point()+
           geom_area(aes(fill = group),alpha = 0.5, linetype = 0)+
           labs(title = "Three modes of investing", year = "Year", y = "Value")+
           facet_wrap(~group)+
           theme_bw()
    )
  })
  
  output$balance <- renderTable({
    head(bal(),11)
  })
}


# Run the application 
shinyApp(ui = ui, server = server)


library(ggplot2)
library(tidyverse)
library(shiny)
library(shinydashboard)
library(tidyverse)
library(DT)
library(shinythemes)

df=read.csv("Data/ONLINE EDUCATION SYSTEM REVIEW.csv",stringsAsFactors = TRUE)

df$Gender<- as.factor(df$Gender)
df$Performance.in.online<- as.factor(df$Performance.in.online)
df$Do.elderly.people.monitor.you.<-as.factor(df$Do.elderly.people.monitor.you.)

mentor<- list("Yes","No")

Gender<-list("Male","Female")
Homelocation<- list("Urban","Rural")
Education<-list("School","Under Graduate", "Post Graduate")

Economicstatus<- list("Poor","Middle Class", "Rich")
FamilySize<-list("1","2", "3", "4", "5", "6", "7", "8", "9", "10", "11+") 

ui <- shinyUI(dashboardPage( skin = 'blue',
                             
                             dashboardHeader( title = "Online Education Performance Dashboard", titleWidth = 700),
                             
                             dashboardSidebar(
                               sidebarMenu(
                                 id = "sidebar",
                                 
                                 #first menu item
                                 menuItem(text = "Overview", tabName="home", icon = icon("graduation-cap")),
                                 
                                 #second menu item 
                                 menuItem(text = "performance", tabName="a_tab", icon = icon("bar-chart")),
                                 
                                 #third menu item
                                 menuItem(text = "Box and Whisker Plots", tabName="chart", icon = icon("bar-chart")),
                                 
                                 #fourth menu item
                                 menuItem(text = "Demographics", tabName="demog", icon = icon("address-book")),
                                 
                                 #about data item
                                 menuItem(text = "About Data", tabName="about", icon = icon("table"))
                                 
                                 
                               )
                               
                             ),
                             dashboardBody(
                               
                               tabItems(
                                 #the Overview tab
                                 tabItem('home',
                                         fluidRow(
                                           box(
                                             title = "" , width = 12
                                             ,status = "primary"
                                             ,solidHeader = FALSE 
                                             ,collapsible = TRUE 
                                             ,plotOutput("plot1", height = "300px")
                                           ),
                                           
                                           box(
                                             title = ""
                                             ,status = "primary"
                                             ,solidHeader = FALSE 
                                             ,collapsible = TRUE 
                                             ,plotOutput("plot2", height = "300px")
                                           ),

                                           tabBox(
                                             title = "",
                                             # The id lets us use input$tabset1 on the server to find the current tab
                                             id = "tabset1", height = "250px",
                                             tabPanel("Tab1", plotOutput("plot3",height = "300px")),
                                             tabPanel("Tab2", plotOutput("plot4",height = "300px"))
                                             
                                           )
                                         )
                                         ),
                                 
                                 
                                 #first performance tab
                                 tabItem('a_tab',
                                         titlePanel("Performance Online and Time Spend on Social Media"), 
                                         sidebarLayout(
                                           
                                           sidebarPanel(
                                             p(" Do students have mentors and is there a relationship between time spent on social media and online performance?"),
                                             br(),
                                             br(),
                                             selectInput("mentor","Having a mentor",choices=mentor),
                                             selectInput("gender","Gender",choices=Gender),
                                             actionButton("plot","Click")
                                           ),
                                           
                                           mainPanel(
                                             plotOutput("violin"),
                                             
                                             plotOutput("barPlot")
                                             
                                           )
                                         )
                                 ),
                                 
                              
                                 #the about tab
                                 tabItem('about',
                                         mainPanel(align = 'Center',
                                                   # h1('Data', style = "font-size:80px;" ),
                                                   br(),
                                                   img(src='UM LOGO.png', width = 180, height = 60, align = 'Center'),
                                                   br(),
                                                   br(),
                                                   br(),
                                                   p("Hi!!!This WQD 7001 group project.\n", style = "font-size:29px;"),
                                                   br(),
                                                   p("Our team members.\n", style = "font-size:20px;"),
                                                   br(),
                                                   img(src='Team.png', width = 960, height = 260, align = 'Center'),
                                                   br(),
                                                   tags$a(href="https://www.kaggle.com/datasets/sujaradha/online-education-system-review?select=ONLINE+EDUCATION+SYSTEM+REVIEW.csv", "For the Data"),
                                                   br(),
                                                   tags$a(href="https://www.kaggle.com/datasets/sujaradha/online-education-system-review?select=ONLINE+EDUCATION+SYSTEM+REVIEW.csv", "GitHub"),
                                                   br(),

                                         )),
                                 
                                 
                                 #the regression tab
                   
                                 tabItem('chart',
                                         titlePanel("Box and Whisker Plots"),
                                         sidebarLayout(
                                           sidebarPanel(
                                             
                                             
                                             selectInput("indepvar", label = h3("Explanatory variable"),
                                                         choices = list("Economic status" = 'Economic.status' ,
                                                                        'Satisifaction about online education'='Your.level.of.satisfaction.in.Online.Education',
                                                                        
                                                                        
                                                                        'Group studies'='Engaged.in.group.studies.'
                                                                        
                                                                        
                                                         ), selected = 1)
                                           ),
                                           
                                           mainPanel(
                                             plotOutput("scatterplot"), # Plot
                                             
                                             verbatimTextOutput("summary")) # Regression output
                                           
                                           
                                         )
                                         
                                 ),
                                 
                                 
                                 #demographics tab
                                 tabItem('demog',
                                         titlePanel("Demographics Barchart"),
                                         sidebarLayout(
                                           sidebarPanel(
                                             p(" To understand demographic data of students causal effect we can use  interactive barplot"),
                                             br(),
                                             
                                             selectInput("Gender","Gender",choices= Gender),
                                             selectInput("hometown","Home location",choices=Homelocation),
                                             selectInput("economic_status","Economic status",choices=Economicstatus,selected = "Middle Class"), 
                                             selectInput("education_level","Level of education",choices=Education,selected = "Under Graduate"),
                                             #selectInput("choose","Demographic variable",choices = variables,multiple = TRUE),
                                             actionButton("action","Plot")
                                             
                                             #actionButtion("twoplot","twovariable")
                                           ),
                                           # Show a plot
                                           mainPanel(
                                             h5(strong("Click Plot to see visual")),
                                             plotOutput("dPlot"),
                                             p("* Certain combinations are unavailable due to the shallowness of the data.", style =  "font-size:11px;")
                                           )
                                           
                                         )
                                         
                                 )
                               )
                             )
)
)
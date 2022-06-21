library(ggplot2)
library(tidyverse)
library(shiny)
library(shinydashboard)
library(shinythemes)
library(DT)
library(dashboardthemes)
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
                                 menuItem(text = "performance", tabName="a_tab", icon = icon("chart-bar")),
                                 
                                 #third menu item
                                 menuItem(text = "Economic", tabName="E_chart", icon = icon("chart-bar")),
                                 
                                 #fourth menu item
                                 menuItem(text = "Personal", tabName="P_chart", icon = icon("address-book")),
                                 
                                 #about data item
                                 menuItem(text = "About Data", tabName="about", icon = icon("table"))
                                 
                                 
                               )
                               
                             ),
                             dashboardBody(
                               shinyDashboardThemes(
                                theme = "purple_gradient"
                              ),
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
                                             actionButton("plot","plot")
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
                                                   img(src='um_logo.png', width = 360, height = 120, align = 'Center'),
                                                   br(),
                                                   br(),
                                                   br(),
                                                   p("Hi!!!This WQD 7001 group project.\n", style = "font-size:29px;"),
                                                   br(),
                                                   p("Welcome to our shiny app！！！ Here you will find out about student performance in online education",style = "font-size:24px;"),
                                                   br(),
                                                   p("Our team members: \n", style = "font-size:20px;"),
                                                   br(),
                                                   img(src='Team.png', width = 960, height = 260, align = 'Center'),
                                                   br(),
                                                   tags$a(href="https://www.kaggle.com/datasets/sujaradha/online-education-system-review?select=ONLINE+EDUCATION+SYSTEM+REVIEW.csv", "For the Data"),
                                                   br(),
                                                   tags$a(href="https://github.com/ranlinsheng/Online-Performance-Dashboard", "GitHub"),
                                                   br(),

                                         )),
                                 
                                 
                                 #the Economic tab
                   
                                 tabItem('E_chart',
                                         fluidRow(
                                           box(
                                             title = "Student Performance Online vs Economic status" , width = 12
                                             ,status = "primary"
                                             ,solidHeader = FALSE 
                                             ,collapsible = TRUE 
                                             ,plotOutput("plot5", height = "300px")
                                           ),
                                           
                                           box(
                                             title = "Student Performance Online vs Typy of Device",width = 12
                                             ,status = "primary"
                                             ,solidHeader = FALSE 
                                             ,collapsible = TRUE 
                                             ,plotOutput("plot6", height = "300px")
                                           )
                                         )
                                         
                                 ),
                                 
                                 
                                 #Personal tab
                                 tabItem('P_chart',
                                         titlePanel("Personal Barchart"),
                                         sidebarLayout(
                                           sidebarPanel(
                                             p(" To understand distribution of online performance related to personal information"),
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
                                           )
                                           
                                         )
                                         
                                 )
                               )
                             )
)
)
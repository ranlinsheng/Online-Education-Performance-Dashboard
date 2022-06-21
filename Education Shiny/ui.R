library(ggplot2)
library(tidyverse)
library(shiny)
library(shinydashboard)
library(shinythemes)
library(DT)
library(dashboardthemes)
library(plotly)

df=read.csv("Data/ONLINE EDUCATION SYSTEM REVIEW.csv",stringsAsFactors = TRUE)
df1=read.csv("Data/before vs after.csv",stringsAsFactors = TRUE)
df2=read.csv("Data/SocialMedia vs Performance.csv",stringsAsFactors = TRUE)


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
                                 menuItem(text = "About Dashboard", tabName="A_Dashboard", icon = icon("home")),
                                 
                                 #second menu item
                                 menuItem(text = "Overview", tabName="home", icon = icon("graduation-cap")),
                                 
                                 #third menu item
                                 menuItem(text = "Economic", tabName="E_chart", icon = icon("chart-bar")),
                                 
                                 #fourth menu item
                                 menuItem(text = "Personal", tabName="P_chart", icon = icon("address-book")),
                                 
                                 #fifth menu item
                                 menuItem(text = "Relationship", tabName="R_chart", icon = icon("cog")),
                                 
                                 #about data item
                                 menuItem(text = "About Us", tabName="about", icon = icon("table"))
                                 
                                 
                               )
                               
                             ),
                             dashboardBody(
                               shinyDashboardThemes(
                                theme = "purple_gradient"
                              ),

                               tabItems(
                                 #The about dashboard tab
                                 tabItem('A_Dashboard',
                                         fluidRow(
                                           mainPanel(align = 'left',
                                                     
                                                     img(src='onlineclasses.jpg', width = 600, height = 300, align = 'Center'),
                                                     br(),
                                                     br()
                                                     ),
                                           tabBox(
                                             
                                             # The id lets us use input$tabset1 on the server to find the current tab
                                             id = "tabset1", height = "450px",
                                             tabPanel("About Dashboard", 
                                                      h1("About Dashoard"),
                                                      p("COVID-19 have brought significant disruptions to the education globally. World-wide pandemic is giving rise to learning losses and increases in inequality. \n
              To reduce the impact of pandemic to the education, education institutions are forced to begin remote. \n
              Remote learning brings more convinient as compared to traditional learning, students can access information from anywhere and anytime. Online education is flexible and can be tailored to different needs. \n
              However, online learning can be possible of lacking control and requires students to be self-disciplined. ", style =  "font-size:15px;"),
                                                      br(),
                                                      p("This dashboard is designed to understand how well students nowadays able to cope with the new learning method.\n
                                                     Analysis of the educational data showing the relationship of each factors and how the factors affecting student online learning performance.", style =  "font-size:15px;")
                                                      ),
                                             tabPanel("Overview", 
                                                      h1("Overview"),
                                                      p("In this section shows the analytic plots of online education performance by different categories.\n", style =  "font-size:15px;"),
                                                      p("- Comparison of student education performance before and after pandemic", style =  "font-size:15px;"),
                                                      p("- Online education performance by education level", style =  "font-size:15px;"),
                                                      p("- Online education performance by gender", style =  "font-size:15px;")
                                                      ),
                                             
                                             tabPanel("Economic", 
                                                      h1("Economic"),
                                                      p("In this section you can discover how economic factors affecting student performance during pandemic.",style =  "font-size:15px;"),
                                                      p("- Effect of economic status on student's online education performance.",style =  "font-size:15px;"),
                                                      p("- Effect of device used during online classes on student's performance.",style =  "font-size:15px;")),
                                             
                                             tabPanel("Personal", 
                                                      h1("Personal"),
                                                      p("In this tab showing how student personal factors affecting their online education performance.",style =  "font-size:15px;"),
                                                      p("- Relationship between time spent on social media and study performance.",style =  "font-size:15px;"),
                                                      p("- Comparison of student performance with or without supervision during online class.",style =  "font-size:15px;")
                                                      ),
                                                      
                                             tabPanel("Relationship", 
                                                      h1("Relationship"),
                                                      p("Visuallization of relationship betweeen each factors. ",style =  "font-size:15px;"),
                                                      p("Select parameters for analysis.",style =  "font-size:15px;"),
                                                      ),
                                             
                                             tabPanel("About Us", 
                                                      h1("About Us"),
                                                      p("Introduction of the team.",style =  "font-size:15px;"),
                                                      
                                             )
                                             
                                           )
                                           )
                                         ),
                                 

                                 
                                         

                                 #the Overview tab
                                 tabItem('home',
                                         fluidRow(
                                           box(
                                             title = "Comparison of Education Performance Before and During Pandemic" , width = 12
                                             ,status = "primary"
                                             ,solidHeader = FALSE 
                                             ,collapsible = TRUE 
                                             ,plotlyOutput("plot1", height = "300px")
                                           ),
                                           
                                           box(
                                             title = "Performance by Education Level"
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

                                 #the about us tab
                                 tabItem('about',
                                         mainPanel(align = 'Center',
                                                   # h1('Data', style = "font-size:80px;" ),
                                                   img(src='um_logo.png', width = 360, height = 120, align = 'Center'),
                                                   br(),
                                                   br(),
                                                   p("Hi!!!This WQD 7001 group project.\n", style = "font-size:29px;"),
                                                   br(),
                                                   p("Welcome to our shiny app！！！ Here you will find out about student performance in online education",style = "font-size:24px;"),
                                                   br(),
                                                   p("***********Our team members*********** \n", style = "font-size:20px;"),
                                                   br(),
                                                   p("--Linsheng Ran"),
                                                   p("--Weng Jon Lee"),
                                                   p("--Wen Si"),
                                                   p("--Chia Siew Lang"),
                                                   p("--Tuan Nurul Ain Afiqah Binti Tuan Chik"),
                                                   br(),
                                                   tags$a(href="https://www.kaggle.com/datasets/sujaradha/online-education-system-review?select=ONLINE+EDUCATION+SYSTEM+REVIEW.csv", "For the Data"),
                                                   br(),
                                                   tags$a(href="https://github.com/ranlinsheng/Online-Education-Performance-Dashboard", "GitHub"),
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
                                 #the Personal tab
                                 
                                 tabItem('P_chart',
                                         fluidRow(
                                           box(
                                             title = "Effect of Time Spent on Social Media on Education " , width = 12
                                             ,status = "primary"
                                             ,solidHeader = FALSE 
                                             ,collapsible = TRUE 
                                             ,plotlyOutput("plot7", height = "300px")
                                           ),
                                           
                                           box(
                                             title = "Effect of Supervision on Education Performance",width = 12
                                             ,status = "primary"
                                             ,solidHeader = FALSE 
                                             ,collapsible = TRUE 
                                             ,plotOutput("plot8", height = "300px")
                                           )
                                         )
                                         
                                 ),
                                 
                                 
                                 #relationship tab
                                 tabItem('R_chart',
                                         titlePanel("Relationship Barchart"),
                                         sidebarLayout(
                                           sidebarPanel(
                                             p(" To understand how each parameters affecting students’ online learning performance"),
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
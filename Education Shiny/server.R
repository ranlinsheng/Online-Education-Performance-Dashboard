server <- function(input,output){
  df=read.csv("Data/ONLINE EDUCATION SYSTEM REVIEW.csv",stringsAsFactors = TRUE)
  Gender<- list("Male","Female")
  Homelocation<- list("Urban","Rural")
  Education<-list("School","Under Graduate", "Post Graduate")
  library(scales) 
  library(tigerstats)
  
  Economicstatus<- list("Poor","Middle Class", "Rich")
  FamilySize<-list("1","2", "3", "4", "5", "6", "7", "8", "9", "10", "11+")
  #variables<-list("Gender","Level.of.Education","Home.Location","Economic.status")
  
  barplot_action<-eventReactive(input$plot,{filter(df,(Do.elderly.people.monitor.you.==input$mentor & Gender==input$gender))})

  #########overview page  #####
  #Scatterplot
  output$plot1 <- renderPlot({
    
    After <- df$Performance.in.online
    Before <- strtoi(substr(df$Average.marks.scored.before.pandemic.in.traditional.classroom,1,1))
    plot(x=Before, y=After, xlab = "Performance Before Pandemic", ylab = "Performance During Pandemic", xlim = c(1,10), ylim = c(1,10), main = "Comparison of Education Performance Before and During Pandemic", pch=19)
    lines(x=Before, y=Before, col="yellow", lwd=2.0)
  })
  
  
  output$plot2 <- renderPlot({
    Education_Level <- df$Level.of.Education
    After <- df$Performance.in.online
    Before <- strtoi(substr(df$Average.marks.scored.before.pandemic.in.traditional.classroom,1,1))
    d <- After - Before
    Difference <- ifelse(d==0,"Maintain", ifelse(d>0,"Improved","Under"))
    
    tb1 <- cbind(Education_Level,Difference)
    tb1 <- colPerc(xtabs(~ Difference+Education_Level,data=tb1))
    tb1 <- tb1[1:3,1:3]
    barplot(tb1, col=colors()[c(23,2,12)],main = "Performance by Education Level",border="white", 
            space=0.08, font.axis=2,xlab = "Education Level", ylab = "Percentage",
            legend.text = TRUE,args.legend = list(x="topright", bty = "n", inset=c(0, 1)))
  })
  output$plot3 <- renderPlot({
    Gender <- df$Gender
    After <- df$Performance.in.online
    Before <- strtoi(substr(df$Average.marks.scored.before.pandemic.in.traditional.classroom,1,1))
    d <- After - Before
    Difference <- ifelse(d==0,"Maintain", ifelse(d>0,"Improved","Under"))
    tb2 <- cbind(Gender,Difference)
    tb2 <- xtabs(~ Difference+Gender,data=tb2)
    tb2
    lab <- rownames(tb2)
    lab
    tb2f <- tb2[1:3,1]
    tb2f
    tb2m <- tb2[1:3,2]
    tb2m
    pie(tb2f, labels=lab, main = "Female Education Performance", col = c("green","grey", "pink"),clockwise = T)
    legend("topright", c("Improved","Maintain","Under"), cex = 0.8, fill = c("green","grey", "pink"))
  })
  
  output$plot4 <- renderPlot({
    Gender <- df$Gender
    After <- df$Performance.in.online
    Before <- strtoi(substr(df$Average.marks.scored.before.pandemic.in.traditional.classroom,1,1))
    d <- After - Before
    Difference <- ifelse(d==0,"Maintain", ifelse(d>0,"Improved","Under"))
    tb2 <- cbind(Gender,Difference)
    tb2 <- xtabs(~ Difference+Gender,data=tb2)
    tb2
    lab <- rownames(tb2)
    lab
    tb2f <- tb2[1:3,1]
    tb2f
    tb2m <- tb2[1:3,2]
    tb2m
    pie(tb2m, labels=lab, main = "Male Education Performance", col = c("green","grey", "pink"),clockwise = T)
    legend("topright", c("Improved","Maintain","Under"), cex = 0.8, fill = c("green","grey", "pink"))
  })##############
  
  
  #first performance tab  
  output$violin<-renderPlot({
    # df %>% filter(Do.elderly.people.monitor.you.==input$mentor) %>% 
    v1<-barplot_action() 
    v1 %>%
      ggplot() +
      geom_violin(aes(x =Performance.in.online , y = Time.spent.on.social.media..Hours., 
                      fill = Do.elderly.people.monitor.you.),trim=FALSE) +
      labs(x = 'Performance in online', y = "Time spent on social media /Hours.") +
      ggtitle("Performance in online VS Time spent on social media Hours") +
      theme_bw() +
      theme(axis.text.x = element_text(face = 'bold', size = 10),
            axis.text.y = element_text(face = 'bold', size = 10))
    
  }) 
  
  output$barPlot <- renderPlot({
    v<-barplot_action()
    
    # draw the barplot 
    v %>%  group_by(Performance.in.online) %>% summarise(N=n()) %>%
      ggplot(aes(x=Performance.in.online,y=N,fill=Performance.in.online))+
      geom_bar(stat = 'identity',color=as.factor('black'))+labs(x="Student Performance Online",y="Number of Students")+
      scale_y_continuous(labels = scales::comma_format(accuracy = 1))+
      geom_text(aes(label=N),vjust=-0.25,size=2) + 
      theme_bw() 
  })
  
  # economic output
  output$plot5 <- renderPlot({
    ggplot(df)+
      geom_bar(aes(x=Performance.in.online,fill = Economic.status))
  })
  
  # economic2 output
  output$plot6 <- renderPlot({
    ggplot(df)+
      geom_bar(aes(x=Performance.in.online,fill = Device.type.used.to.attend.classes))
  }) 
  
  
  #demographics tab Bar chart
  action<-eventReactive(input$action,{filter(df,(Gender==input$Gender & Level.of.Education ==input$education_level & Home.Location==input$hometown & Economic.status==input$economic_status ))})
  
 # two_variable<-eventReactive()
  #three_variable<-
  #four_variable<-
  output$dPlot <- renderPlot({
    v<-action()
    
    
    
    # draw the barplot 
    v %>%  group_by(Performance.in.online) %>% summarise(N=n()) %>%
      ggplot(aes(x=Performance.in.online,y=N,fill=Performance.in.online))+
      geom_bar(stat = 'identity',color='black')+labs(x="Student Performance Online",y="Number of Students")+
      scale_y_continuous(labels = scales::comma_format(accuracy = 1))+
      geom_text(aes(label=N),vjust=-0.25,size=2)+
      theme_bw()+
      theme(axis.text = element_text(color='black',face="bold"),
            axis.title = element_text(color='black',face="bold"),
            legend.text = element_text(color='black'),
            legend.title = element_text(color='black'))
  })

}


# Run the application 
#shinyApp(ui = ui, server = server)

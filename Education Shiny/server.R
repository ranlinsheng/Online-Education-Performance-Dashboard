server <- function(input,output){
  df=read.csv("Data/ONLINE EDUCATION SYSTEM REVIEW.csv",stringsAsFactors = TRUE)
  df1=read.csv("Data/before vs after.csv",stringsAsFactors = TRUE)
  df2=read.csv("Data/SocialMedia vs Performance.csv",stringsAsFactors = TRUE)
  
  Gender<- list("Male","Female")
  Homelocation<- list("Urban","Rural")
  Education<-list("School","Under Graduate", "Post Graduate")
  library(scales) 
  library(tigerstats)
  library(plotly)
  
  Economicstatus<- list("Poor","Middle Class", "Rich")
  FamilySize<-list("1","2", "3", "4", "5", "6", "7", "8", "9", "10", "11+")
  #variables<-list("Gender","Level.of.Education","Home.Location","Economic.status")
  
  barplot_action<-eventReactive(input$plot,{filter(df,(Do.elderly.people.monitor.you.==input$mentor & Gender==input$gender))})

  #overview page
  #Before vs After "Comparison of Education Performance Before and During Pandemic"
  output$plot1 <- renderPlotly({
    plot_ly(data = df1,x=~Performance.Before.Pandemic,y=~Performance.During.Pandemic
            ,type = "scatter",mode = "markers",colors="blue",marker=list(size=df1$Count,opacity=0.5))

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
    barplot(tb1, col=colors()[c(23,89,12)],main = "",border="white", 
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
    lab <- rownames(tb2)
    tb2f <- tb2[1:3,1]
    tb2m <- tb2[1:3,2]
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
    lab <- rownames(tb2)
    tb2f <- tb2[1:3,1]
    tb2m <- tb2[1:3,2]
    pie(tb2m, labels=lab, main = "Male Education Performance", col = c("green","grey", "pink"),clockwise = T)
    legend("topright", c("Improved","Maintain","Under"), cex = 0.8, fill = c("green","grey", "pink"))
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
    ggplot(data=df, aes(x=Performance.in.online, fill=Economic.status)) +
      geom_bar( position=position_dodge())+
      scale_fill_manual(values=c("#9933FF",
                                 "#33FFFF",
                                 "red",
                                 "darkblue"))+
      theme_dark()

  })
  
  # economic2 output
  output$plot6 <- renderPlot({
    ggplot(df)+
      geom_line(aes(x=Performance.in.online, color=Device.type.used.to.attend.classes),stat="count")+
      scale_color_manual(values=c("#CAFF70", "#FF69B4", "#56B4E9"))+
      theme_dark()
  }) 
  
  # Personal output1
  output$plot7 <- renderPlotly({
    plot_ly(data = df2,x=~Time.spent.on.social.media..Hours.,
            y=~Performance.During.Pandemic,type = "scatter",mode = "markers",
            colors="pink",marker=list(size=df2$Count,opacity=0.5))
    
  })
  
  # Personal output2
  output$plot8 <- renderPlot({
    #Personalfactor"Effect of Supervision on Education Performance"
    Supervision <- df$Do.elderly.people.monitor.you.
    After <- df$Performance.in.online
    tb6 <- rbind(Supervision,After)
    tb6 <- xtabs(~ Supervision+After,data=tb6)
    tb6
    barplot(tb6,beside = T,xlab = "Value",ylab = "Online Education Performance",
            main = "Effect of Supervision on Education Performance",
            col=colors()[c(13,36)],legend.text = TRUE,
            args.legend = list(x="topright", bty = "n", inset=c(-0.15, 1)),horiz = TRUE)
  }) 
  
  
  #relationship tab Bar chart
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

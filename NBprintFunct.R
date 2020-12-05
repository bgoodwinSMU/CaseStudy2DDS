printALL=function(model){
  trainPred=predict(model, newdata = train, type = "class")
  trainTable=table(train$Attrition, trainPred)
  testPred=predict(model, newdata=test, type="class")
  testTable=table(test$Attrition, testPred)
  trainAcc=(trainTable[1,1]+trainTable[2,2])/sum(trainTable)
  testAcc=(testTable[1,1]+testTable[2,2])/sum(testTable)
  message("Contingency Table for Training Data")
  print(trainTable)
  message("Contingency Table for Test Data")
  print(testTable)
  message("Accuracy")
  print(round(cbind(trainAccuracy=trainAcc, testAccuracy=testAcc),3))
}

ggplotConfusionMatrix <- function(m){
  mytitle <- paste("Accuracy", percent_format()(m$overall[1]),
                   "Sensitivity",percent_format()(m$byClass[1]),"Specificity",percent_format()(m$byClass[2]))
  p <-
    ggplot(data = as.data.frame(m$table) ,
           aes(x = Prediction, y = Reference)) +
    geom_tile(aes(fill = log(Freq)), colour = "white") +
    scale_fill_gradient(low = "white", high = "steelblue") +
    geom_text(aes(x = Reference, y = Prediction, label = Freq)) +
    theme(legend.position = "none") +
    ggtitle(mytitle)
  return(p)
}

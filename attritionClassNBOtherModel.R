###############################################################################
#Printing functions
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

###############################################################################

#Read in primary data ("CaseStudy2-data.txt")
primaryData <- read.table("CaseStudy2-data.txt",sep = ",",header = TRUE)

#Convert all CHR variables to factors to examine pairs data
primaryData_factor <- primaryData %>%
  mutate_if(sapply(primaryData, is.character), as.factor)


#Convert all CHR variables to ints for COV 
primaryData_int <- primaryData_factor %>%
  mutate_if(sapply(primaryData_factor, is.factor), as.integer)

nnDat <- primaryData_int[,-c(1,5,10,11,14,21,23,24,28)]

#Over sample to correct for imbalance
nnDat <- oversample(nnDat,classAttr = "Attrition",method = "ADASYN")


nnDat$Attrition <- (ifelse(nnDat$Attrition==1,"No","Yes"))
nnDat$Attrition <- as.factor(nnDat$Attrition)

set.seed(107)


inTrain <- createDataPartition(y=nnDat$Attrition,p=0.75,list = FALSE)
class(nnDat$Attrition)
levels(nnDat$Attrition)
training <- nnDat[inTrain,]
testing <- nnDat[-inTrain,]

ctrl <- trainControl(method = "repeatedcv", repeats = 3,classProbs = TRUE, summaryFunction = twoClassSummary)

noAttDs <- read.table("noAttrition.txt",sep = ",",header = TRUE)

nnDat1 <- noAttDs
#Remove unneeded cols
#noAttDs <- noAttDs[,-c(4,9,10,13,20,22,23,27)]

#Convert all CHR variables to factors to examine pairs data
nnDat1 <- nnDat1 %>%
  mutate_if(sapply(nnDat1, is.character), as.factor)




#Make factors
noAttDs <- noAttDs %>%
  mutate_if(sapply(noAttDs, is.integer), as.factor)
#Remove unneeded cols
noAttDs <- noAttDs[,-c(4,9,10,13,20,22,23,27)]


#Convert all CHR variables to ints for COV 
nnDat1 <- nnDat1 %>%
  mutate_if(sapply(nnDat1, is.factor), as.integer)

rdaGrid = data.frame(gamma = (0:4)/4, lambda = 3/4)
set.seed(123)
rdaFit <- train(Attrition ~ .,data = training,method = "rda",tuneGrid = rdaGrid,trControl = ctrl,metric = "ROC")
rdaFit

rdaClasses <- predict(rdaFit, newdata = testing)
cfm <- confusionMatrix(rdaClasses, testing$Attrition)
cfm
ggplotConfusionMatrix(cfm)


other1 <- predict(rdaFit,newdata = nnDat1,type = "raw")
#view(other1)


newDf <- noAttDs
newDf$Attrition=other1
View(newDf)

newDf <- newDf[,c(1,28)]

out <- write.csv(newDf,"~/Documents/Case2PredictionsGoodwinAttrition.csv",row.names = FALSE)


################################################################################

####Factor with over sampling, model 2####

##Data prep for NB
#Read in primary data ("CaseStudy2-data.txt")
primaryData <- read.table("CaseStudy2-data.txt",sep = ",",header = TRUE)

#Convert all CHR variables to factors to examine pairs data
primaryData_factor <- primaryData %>%
  mutate_if(sapply(primaryData, is.character), as.factor)


#Convert all CHR variables to ints for COV 
primaryData_int <- primaryData_factor %>%
  mutate_if(sapply(primaryData_factor, is.factor), as.integer)

nnDat <- primaryData_int[,-c(1,5,10,11,14,21,23,24,28)]

#Create DF
dataAllFact = primaryData_int[,-c(1,5,10,11,14,21,23,24,28)]


#Over sample to correct for imbalance
newDataAllFact <- oversample(dataAllFact,classAttr = "Attrition",method = "ADASYN")

#Oversample changes all to numeric, revert to factor
newDataAllFactor <- newDataAllFact %>%
  mutate_if(sapply(newDataAllFact, is.integer), as.factor)

newDataAllFactor$Attrition <- (ifelse(newDataAllFactor$Attrition==1,"No","Yes"))
newDataAllFactor$Attrition <- as.factor(newDataAllFactor$Attrition)

#Check out the imbalance ratio
imbalanceRatio(newDataAllFactor,"Attrition")

#Do the stuff for NB
#Set seed to easily duplicate results
set.seed(7267166)

#Split training and testing data
trainIndex=createDataPartition(newDataAllFactor$Attrition, p=0.70)$Resample1
train=newDataAllFactor[trainIndex, ]
test=newDataAllFactor[-trainIndex, ]

#Create classifier
NBclassfier=naiveBayes(Attrition~., data=train)

#call print function
printALL(NBclassfier)

#Generate CM
nb_train_predict <- predict(NBclassfier,test[,names(test) !="Attrition"])
cfm <- confusionMatrix(nb_train_predict,test$Attrition)
cfm

#Look at plot
ggplotConfusionMatrix(cfm)


###############################################################################
#Make predictions, with NB model
nb_train_predictNewDS <- predict(NBclassfier,noAttDs)
nb_train_predictNewDS

table(nb_train_predictNewDS)

newDf <- noAttDs
newDf$Attrition=nb_train_predictNewDS


newDf <- newDf[,c(1,28)]

out <- write.csv(newDf,"~/Documents/Case2PredictionsGoodwinAttrition.csv",row.names = FALSE)




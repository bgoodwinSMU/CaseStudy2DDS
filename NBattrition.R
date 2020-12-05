####Naive Bayes for Attrition####

##Data prep for NB
#Create DF
dataAllFact = primaryData_int[,-c(1,5,10,14,21,23,24,28)]

####Factor with original DF, model 1####

dataAllFactNoBal <- primaryData_int[,-c(1,5,10,14,21,23,24,28)]

#Convert all elements to factors
dataAllFactNoBal <- dataAllFactNoBal %>%
  mutate_if(sapply(dataAllFactNoBal, is.integer), as.factor)

dataAllFactNoBal$Attrition <- (ifelse(dataAllFactNoBal$Attrition==1,"No","Yes"))
dataAllFactNoBal$Attrition <- as.factor(dataAllFactNoBal$Attrition)

#Check out the imbalance ratio
imbalanceRatio(dataAllFactNoBal,"Attrition")

#Do the stuff for NB
#Set seed to easily duplicate results
set.seed(7267166)

#Split training and testing data
trainIndex=createDataPartition(dataAllFactNoBal$Attrition, p=0.7)$Resample1
train=dataAllFactNoBal[trainIndex, ]
test=dataAllFactNoBal[-trainIndex, ]

#Create classifier
NBclassfier=naiveBayes(Attrition~., data=train)

#call print function,check initial results
printALL(NBclassfier)

#Generate CM
nb_train_predict <- predict(NBclassfier,test[,names(test) !="Attrition"])
cfm <- confusionMatrix(nb_train_predict,test$Attrition)
cfm

#Look at plot
ggplotConfusionMatrix(cfm)

################################################################################

####Factor with over sampling, model 2####

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
trainIndex=createDataPartition(newDataAllFactor$Attrition, p=0.7)$Resample1
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

################################################################################

####Factor with over sampling,only outcome as factor, model 3####

#Over sample to correct for imbalance
newDataAttFact <- oversample(dataAllFact,classAttr = "Attrition",method = "ADASYN")

newDataAttFact$Attrition <- as.factor(newDataAttFact$Attrition)

newDataAttFact$Attrition <- (ifelse(newDataAttFact$Attrition==1,"No","Yes"))
newDataAttFact$Attrition <- as.factor(newDataAttFact$Attrition)

#Check out the imbalance ratio
imbalanceRatio(newDataAllFactor,"Attrition")

#Do the stuff for NB
#Set seed to easily duplicate results
set.seed(7267166)

#Split training and testing data
trainIndex=createDataPartition(newDataAttFact$Attrition, p=0.7)$Resample1
train=newDataAttFact[trainIndex, ]
test=newDataAttFact[-trainIndex, ]

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

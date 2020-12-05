#NN testing

#Read in primary data ("CaseStudy2-data.txt")
primaryData <- read.table("CaseStudy2-data.txt",sep = ",",header = TRUE)

#Convert all CHR variables to factors to examine pairs data
primaryData_factor <- primaryData %>%
  mutate_if(sapply(primaryData, is.character), as.factor)


#Convert all CHR variables to ints for COV 
primaryData_int <- primaryData_factor %>%
  mutate_if(sapply(primaryData_factor, is.factor), as.integer)

nnDat <- primaryData_int[,-c(1,5,10,14,21,23,24,28)]

nnDat$Attrition <- (ifelse(nnDat$Attrition==1,"No","Yes"))
#Over sample to correct for imbalance


nnDat$Attrition <- as.factor(nnDat$Attrition)


# define training control
train_control <- trainControl(method="repeatedcv", number=10, repeats = 1, classProbs = TRUE)

# train the model
model <- train(Attrition~., data=nnDat, trControl=train_control, method="pcaNNet", metric = "Kappa")

# summarize results
print(model)

# Confusion matrix
model %>% confusionMatrix() 



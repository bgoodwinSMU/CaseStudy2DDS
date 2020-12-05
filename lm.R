primaryData <- read.table("CaseStudy2-data.txt",sep = ",",header = TRUE)
salaryDatNoinfo <- compsetNoSalary

salaryDat <- primaryData[,c(16,20,30,7,36)]



salaryDatlm <- lm(MonthlyIncome~JobLevel+TotalWorkingYears+YearsWithCurrManager+DistanceFromHome,data = salaryDat)
summary(salaryDatlm)

RSS <- c(crossprod(salaryDatlm$residuals))
MSE <- RSS / length(salaryDatlm$residuals)
RMSE <- sqrt(MSE)
sig2 <- RSS / salaryDatlm$df.residual



##########EDA for Salary##########
salaryDatEDA <- primaryData[,-c(1,5,10,11,14,21,23,24,28)]
samp <- createDataPartition(salaryDatEDA$MonthlyIncome,p=0.8,list = FALSE)
training <- salaryDatEDA[samp,]
testing <- salaryDatEDA[-samp,]

tc <- trainControl(method = "cv",number = 10)
lm1_cv <- train(MonthlyIncome~.,data=salaryDatEDA,method="lm",trainControl=tc)
lm1_cv
ggplot(varImp(lm1_cv))

predictedSal <- predict(salaryDatlm,salaryDatNoinfo)
table(predictedSal)

newDf <- salaryDatNoinfo
newDf$MonthlyIncome=predictedSal
View(newDf)

newDf <- newDf[,c(1,36)]

out <- write.csv(newDf,"~/Documents/Case2PredictionsGoodwinSalary.csv",row.names = FALSE)

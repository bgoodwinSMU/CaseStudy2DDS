#Case Study 2 DDS (DS6306)

This repository contains all required project files as specified by class documents

Included in this repository are the following: Codebook, original data .txt file, both example .txt files concerning predictions for classification and regression, the competition for salary .xlsx file along with the competition for not attrition .txt file. This repository also contains my knitted HTML file of the project (as well as the original .rmd file, containing an executive summary), and the predicted .csv file this document you are currently reading also contains the project summmary below.

Project Summary

Frito-Lay contacted DDSAnalytics concerning it's specialization in talent management solutions.  The team at Frito-Lay is especially interested in DDSAnalytics claimed abilities to harness data science by predicting attrition.  DDSAnalytics has been tasked with conducting an analysis of existing employee data.

Specifically, DDSAnalytics will analyze factors that lead to attrition.

Some project deliverables:

Top three factors that lead to attrition.

Identification of trends hidden in the data concerning job role specific trends

Robust visualization of said trends 

Model for predicting attrition, alongside a .csv file containing predictions for attrition

Model for salary prediction, alongside a .csv file containing predictions for monthly salary

I am confident in the validity of this analysis and hope that Frito-Lay determines an appropriate course of action to take based on the work in this repository.

General Conclusions:

Attrition is a tricky variable of interest.  When the two groups are plotted, there is visual evidence supporting those who stay with their jobs are very similar to those who leave their jobs.  Luckily, using principal component anaylsis (PCA) I was able to derive some important trends between those who stayed and those who left jobs.  

PCA is a technique for dimensionality reduction, and worked well with this dataset as 38 variables were present in the initial dataset. (CaseStudy2-data.txt) The initial impression of the data was that it was quite noisy and contained many similar variables attempting to measure the same thing, and a few variables which did not yeild any results significant for the attrition analysis or for any of the other QOIs.  

Variables removed: ID,Daily Rate, Employee count, Employee Number, Hourly Rate, Monthly rate, Over18, Standardhours.
Many of these variables such as hourly rate, monthly rate, and daily rate did not contain specific infomration that I felt confident using in conjunction with the other measures of pay rates.  I opted instead for monthly income as the best measure of any employees earnings.  ID served no purpose and simply added noise to the data.  Employee count was a value of 1 for each entry in the data, and served no purpose to the analysis.  Employee number was also not used due to its unrelatedness to the QOIs.  All employees were over 18, and thus the variable was thrown away.  Each entry also reported 80 for Standard hours, and thus was deemed to be not of interest for the analysis.  

After the variables were removed, PCA was implemented.  The data had its dimensionality successfully reduced.  The data the PCA was performed on initially had 28 variables, and after dimensionality reduction, the data was reduced into 15 components.  Those 15 components accounted for 81% of the variation in the data, 80% was used as a general threshold, and is the level generally used for PCA anaylsis as a cutoff for compoents.  A scree plot was used in this determination.  

Since the data was reduced into 15 components, these new compoents need to be interpreted differently. After PCA is completed, we are left with multiple components, each of which have what are called loadings for each of the original variables.  The absolute magnitude of these loadings are extremely important as they generalize the crucial parts of each component.  In the attrition data, the first four components account for more variability in the data than the last 11, so the interpreations are below.

Keep in mind these interperations are of the components themselves, and are not necessarily what contributes towards attrition, but instead generalize the data on a higher level and are measures of employees.

PC1: The first component is positively correlated with total working years, years at company, job level, monthly income.  This suggests the give variables vary together and when one goes down, the others decrease as well.  The component could be considered a primary measure of career length and longevity and well as a measure of success.

PC2: The second component is mostly correlated with number of companies worked, and age, but in a negative direction.  Years with current manager and years in current role are correlated with the second component in the positive direction, which indicates that as number of companies and age decrease, years with current manager and years in current role increase.

PC3: The third component is most correlated with performance rating and percent salary hike, both in a negative direction.  Department and job role are correlated with the third component in a positive direction, suggesting that as performance rating and percent salary hike decrease, department and job role increase.

PC4: The fourth component is most correlated with stock option level.  Martial Status and percent salary hike are correlated with the fourth component, but in a negative direction.  This suggest that as stock option level increases, martial status and percent salary hike decrease.  

PCA also can be used to create plots called bi-plots, and these plots are useful for showing how the directionality of each loading is affected by two PCs.
Here is where we can start to say things about the components and their loadings as they are related to attrition.  

Bi-plot 1: We can see the loaings that point in the direction of the attrition ellipse.  In terms of the first component, we can see that Job Role and Marriage Status point more towards the attrition ellipse.  The same with Job Satisfaction and percent salary hike for the second component. 

Bi-plot 2: Looking at the biplot, we can see the loadings that point in the direction of the attrition ellipse.  In terms of the third component, we can see that department and job role point more towards the attrition ellipse, this is the second biplot that job role has pointed towards attrition, suggesting this may be a variable of interest concerning attrition.

Bi-plot 3: Looking at the biplot, we can see the loadings that point in the direction of the attrition ellipse.  In terms of the the fourth component, we can see that marital status and age point more towards the attrition ellipse, this is the second biplot that maritial status has pointed towards attrition, suggesting this may be another variable of interest concerning attrition.

PCA also revealed some interesting aspects of job roles.  Each job role was plotted as a general cluster on a bi-plot and the absolute magnitude of the top 4 loadings of PC1 and PC2 were added to the bi-plot. 

From the components and the bi-plot, there are some interesting takeaways about job roles.  

-Job roles tend to cluster around each other, indiciating they each have specific attributes that lend themselves to that job role (maybe not that profound, but certainly can be confirmed after looking at the plot)

-Managers and research directors tend to be more heavily associated with years of experience.

-Sales representatives and sales directors are associated with attrition in terms of abosolute of magnitude of their loadings.

-Interestingly, number of companies worked lands squarely in the middle of the pack and doesn't seem to have mich bearing on job role.

-Years with current manager doesn't seem to point to job roles in a specific direction, indicating should one wish to pivot, they should develop attributes more in line with the intended role (a decision that could be made based on this chart)

Classification of Attrition

Since attrition seemed to be hard to visually spot, this presented an interesting problem for classification.  Could a classifier examine the data on a level that is unobservable by the human eye? Furthermore, the balance of the data was very off.  Only 140 of the 830 employees were indicated as "Yes" for attrition, meaning that 730 of the employees indicated "No" for attrition.  This ratio was about .19, meaning that if you guessed that 4 out of 5 employees were "No" for attrition, they could potientially be fairly accurate.  

The solution was to oversample the data to restore balance between the no's and yes's.

For Bayesian classifcation, the preferred datatype is a factor,so the data was converted to all factors, including the outcome variable, "Attrition."  Making this a binary classification model.  The Bayesian classifer came in at 81% accuracy, 86% sensitivity, and 76% specificity.  

An additional model was used for classification.  Regularized Discrimiant Analysis was the second method (This operator performs a regularized discriminant analysis (RDA). for nominal labels and numerical attributes. Discriminant analysis is used to determine which variables discriminate between two or more naturally occurring groups, it may have a descriptive or a predictive objective.). I felt these characteristics were preferred for this data. After analysis I felt the RDA model was better suited, and chose to submit it's predictions for attrition. RDA resulted in 85% accuracy, 87% sensitivity, and 83% specificity.  Outperforming the Bayesian classifier on all metrics.

I believe the Bayesian classifer overestimated attrition in the testing dataset, classifying about 54% as yes, and RDA classified about 18% as yes.  RDA seems to be a better fit.

All classification was implemented using the Caret package for R.  The data was split up into testing and training and then validated.  The attrition estimates were generated using RDA.  

Finally, we discuss salary predictions.  A multiple linear regression model was used to achieve desired results. Initially a model was used using all predictors, however this yielded a R^2 value that was impossibly high.  A plot was then generated using the Caret package which visually showed the importance of each varible in the model.  The following variables were included in the final model: job level, totalworkingyears, yearswithcurrmanager, distance from home.  The linear model was generated and each of the variables were considered singificant at the P<0.05 level.  Addtionally the model itself was significant with P<0.05.  

In conclusion, we looked at factors that contribute to attrition, examined job role specific trends, predicted attrition using RDA, and predicted monthly income using a linear model.  I hope these results can be used in a meaningful way.  Thanks Frito-lay. 

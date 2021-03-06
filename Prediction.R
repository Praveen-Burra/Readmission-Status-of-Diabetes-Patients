#Loading the training Data Set
sampledata <- read.csv("C:\\Users\\Satya Praveen\\Desktop\\coding\\data-challenge\\data-challenge\\training_data.csv",sep=',')
head(sampledata) 

# Replacing the missing values with NA
sampledata[sampledata=="?"]<-NA 
head(sampledata)

# dimensions of the training data
dim(sampledata)

#To see how many NA values are there in each column in the given data. 
library(dplyr)
sampledata %>%
select(everything()) %>%  # replace to your needs
summarise_all(funs(sum(is.na(.)))) 

# So we have 7 variables having NA values which are:
# Race, Payer_code,medical_speciality, weight, diag-1,diag-2,diag-3
# Removing the Weight variable which has more than 78844 missing values.
sampledata$weight <- NULL

#Replacing the odd values like V45, E932 with NA in all the three variables(diag-1,diag-2,diag-3)
sampledata$diag_3 <- gsub("V.*",NA, sampledata$diag_3)
sampledata$diag_2 <- gsub("V.*",NA, sampledata$diag_2)
sampledata$diag_1 <- gsub("V.*",NA, sampledata$diag_1)

sampledata$diag_3 <- gsub("E.*",NA, sampledata$diag_3)
sampledata$diag_2 <- gsub("E.*",NA, sampledata$diag_2)
sampledata$diag_1 <- gsub("E.*",NA, sampledata$diag_1)

#FOr diag-3 variable 
#checking whether the variable is numeric or not
is.numeric(sampledata$diag_3) 
#converting to numeric
sampledata$diag_3 <- as.numeric(sampledata$diag_3) 
is.numeric(sampledata$diag_3)
# impute (replace NA values with mean)
sampledata$diag_3[is.na(sampledata$diag_3)] <- mean(sampledata$diag_3, na.rm = T)

#For diag-2
sampledata$diag_2 <- as.numeric(sampledata$diag_2) #converting to numeric
is.numeric(sampledata$diag_2)
#impute 
sampledata$diag_2[is.na(sampledata$diag_2)] <- mean(sampledata$diag_2, na.rm = T)

#For diag-1
sampledata$diag_1 <- as.numeric(sampledata$diag_1) #converting to numeric
is.numeric(sampledata$diag_1)
#impute
sampledata$diag_1[is.na(sampledata$diag_1)] <- mean(sampledata$diag_1, na.rm = T)

#replacing all NA values in the categorical data with None

#### For variable - Race
set.seed(1234)
# Get levels and add "None" level
levels <- levels(sampledata$race)
levels[length(levels) + 1] <- "None"

# refactor Race to include "None" as a factor level and replace NA with "None"
sampledata$race <- factor(sampledata$race, levels = levels)
sampledata$race[is.na(sampledata$race)] <- "None"


#### For variable - payer_code
set.seed(1235)

# Get levels and add "None" level
levels <- levels(sampledata$payer_code)
levels[length(levels) + 1] <- "None"

# refactor payer_code to include "None" as a factor level and replace NA with "None"
sampledata$payer_code <- factor(sampledata$payer_code, levels = levels)
sampledata$payer_code[is.na(sampledata$payer_code)] <- "None"


#### For variable - medical_speciality
set.seed(1236)

# Get levels and add "None"
levels <- levels(sampledata$medical_specialty)
levels[length(levels) + 1] <- "None"

# refactor medical_speciality to include "None" as a factor level and replace NA with "None"
sampledata$medical_specialty <- factor(sampledata$medical_specialty, levels = levels)
sampledata$medical_specialty[is.na(sampledata$medical_specialty)] <- "None"


######## dealing with categorical variables
convert <- c(3,4,5,10,11,22:48)
sampledata[,convert] <- data.frame(apply(sampledata[convert], 2, as.factor))

# checking whether the columns are converted to factor type
is.factor(sampledata[,23])
is.factor(sampledata[,20])


#### test for checking the important variables
#install.packages("Boruta")
#library(Boruta)
#set.seed(123)
#boruta_output <- Boruta(readmitted ~ ., data=sampledata, doTrace=2)  # perform Boruta search
#print(boruta.train)


#install.packages("randomForest")
#library(randomForest)
#model_rf<-randomForest(readmitted ~ ., data = sampledata[,48:49])
#These models and methods are taking too much time to process. Hence we will use H2o Environment linked with R for dealing with large datasets.

#
#
#

############################### TESTING DATA #################################
testdata = read.csv("C:\\Users\\Satya Praveen\\Desktop\\coding\\data-challenge\\data-challenge\\test_data.csv",sep = ',')
testdata[testdata=="?"]<-NA
head(testdata)

# dimensions of the test data
dim(testdata)

#To see how many NA values are there in each column in the given data. 
library(dplyr)
testdata %>%
  select(everything()) %>%  # replace to your needs
  summarise_all(funs(sum(is.na(.)))) 

# Removing the Weight variable which has more than 19725 missing values.
testdata$weight <- NULL

#Replacing the odd values like V45, E932 and manymore irrelevant numbers with NA in all the three variables
testdata$diag_3 <- gsub("V.*",NA, testdata$diag_3)
testdata$diag_2 <- gsub("V.*",NA, testdata$diag_2)
testdata$diag_1 <- gsub("V.*",NA, testdata$diag_1)

testdata$diag_3 <- gsub("E.*",NA, testdata$diag_3)
testdata$diag_2 <- gsub("E.*",NA, testdata$diag_2)
testdata$diag_1 <- gsub("E.*",NA, testdata$diag_1)

# Imputing the diag-1,2,3 columns missing values with their mean values
#FOr diag-3 variable
#checking whether the variable is numeric or not
is.numeric(testdata$diag_3)
testdata$diag_3 <- as.numeric(testdata$diag_3) 
#converting to numeric
is.numeric(testdata$diag_3)

#impute (replace with mean)
testdata$diag_3[is.na(testdata$diag_3)] <- mean(testdata$diag_3, na.rm = T)

#For diag-2
testdata$diag_2 <- as.numeric(testdata$diag_2) #converting to numeric
is.numeric(testdata$diag_2)
#impute 
testdata$diag_2[is.na(testdata$diag_2)] <- mean(testdata$diag_2, na.rm = T)

#For diag-1
testdata$diag_1 <- as.numeric(testdata$diag_1) #converting to numeric
is.numeric(testdata$diag_1)
#impute
testdata$diag_1[is.na(testdata$diag_1)] <- mean(testdata$diag_1, na.rm = T)

#replacing all NA values in the categorical data with None

#### For variable - Race
set.seed(45)

# Get levels and add "None"
levels <- levels(testdata$race)
levels[length(levels) + 1] <- "None"

# Refactor Race to include "None" as a factor level and replace NA with "None"
testdata$race <- factor(testdata$race, levels = levels)
testdata$race[is.na(testdata$race)] <- "None"

#### For variable - payer_code
set.seed(451)

# Get levels and add "None"
levels <- levels(testdata$payer_code)
levels[length(levels) + 1] <- "None"

# refactor Payer_code to include "None" as a factor level and replace NA with "None"
testdata$payer_code <- factor(testdata$payer_code, levels = levels)
testdata$payer_code[is.na(testdata$payer_code)] <- "None"


#### For variable - medical_speciality
set.seed(452)

# Get levels and add "None"
levels <- levels(testdata$medical_specialty)
levels[length(levels) + 1] <- "None"

# refactor medical_speicality to include "None" as a factor level and replace NA with "None"
testdata$medical_specialty <- factor(testdata$medical_specialty, levels = levels)
testdata$medical_specialty[is.na(testdata$medical_specialty)] <- "None"


######## dealing with categorical variables
convert <- c(3,4,5,10,11,22:48)
testdata[,convert] <- data.frame(apply(testdata[convert], 2, as.factor))

is.factor(testdata[,23]) # checking whether the columns are converted to factor type
is.factor(testdata[,20])


########################### MODELLING #######################
#install.packages("h2o")
library(h2o)

#To launch the H2O cluster
localH2O <- h2o.init(nthreads = -1)

# loading the training data into H2o environment from R
train.h2o <- as.h2o(sampledata)

test.h2o <- as.h2o(testdata)

colnames(train.h2o)


### GBM(Gradient Boosting) Model
y.dep <- 49 #deppendent variable
# Removing the encounter id and patient number from the dependent variables as they don't add any extra information for training the model.
x.indep <- c(3:48) #independent variables 

#
#GBM model on the training data set in H2o environment
gbm.model <- h2o.gbm(y=y.dep, x=x.indep, training_frame = train.h2o, ntrees = 1000, max_depth = 4, learn_rate = 0.01, seed = 1122)

# predicting the readmission results for the test data set 
predict.gbm <- as.data.frame(h2o.predict(gbm.model, test.h2o))

summary(predict.gbm)
# Shutting down the h2o environment
h2o.shutdown(prompt = FALSE)

# Final Output predictions dataframe containing the row identifiers(encounter_id and patient number)
Final_Output <- data.frame(encounter_id = testdata$encounter_id, readmitted = predict.gbm$predict)

#  Exporting the csv file and saving it.
write.csv(Final_Output, file = "Output.csv", row.names = F)


